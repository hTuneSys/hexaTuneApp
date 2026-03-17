// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import Foundation
import AVFoundation

/// Real-time audio rendering service using AVAudioEngine.
///
/// Installs a render tap on the audio engine's main mixer node,
/// calling the Rust DSP engine to fill output buffers each cycle.
class DspAudioService {
    private var audioEngine: AVAudioEngine?
    private var enginePtr: UInt = 0
    private var isPlaying = false
    private var totalFramesRendered: UInt64 = 0
    /// Pre-allocated buffer for interleaved DSP output (deinterleaved into
    /// AVAudioEngine's non-interleaved buffers in the render callback).
    private var interleavedBuffer: UnsafeMutablePointer<Float>?
    private static let maxRenderFrames = 4096

    private static let tag = "HTD"

    init() {
        audioEngine = nil
    }

    func start(sampleRate: Int, enginePointer: UInt) {
        guard !isPlaying else { return }
        enginePtr = enginePointer
        totalFramesRendered = 0

        // Pre-allocate interleaved stereo buffer (avoid allocation on audio thread)
        interleavedBuffer = .allocate(capacity: DspAudioService.maxRenderFrames * 2)

        let engine = AVAudioEngine()
        // AVAudioEngine nodes require non-interleaved format
        let format = AVAudioFormat(
            commonFormat: .pcmFormatFloat32,
            sampleRate: Double(sampleRate),
            channels: 2,
            interleaved: false
        )!

        let srcNode = AVAudioSourceNode { [weak self] _, _, frameCount, audioBufferList -> OSStatus in
            guard let self = self, self.isPlaying,
                  let tmpBuf = self.interleavedBuffer else {
                let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
                for buffer in ablPointer {
                    memset(buffer.mData, 0, Int(buffer.mDataByteSize))
                }
                return noErr
            }

            let frames = min(frameCount, UInt32(DspAudioService.maxRenderFrames))

            // Render interleaved stereo from Rust DSP engine
            let rc = htd_engine_render(
                OpaquePointer(bitPattern: self.enginePtr),
                tmpBuf,
                frames
            )

            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            if rc != 0 {
                NSLog("[\(DspAudioService.tag)] Render error: \(rc)")
                for buffer in ablPointer {
                    memset(buffer.mData, 0, Int(buffer.mDataByteSize))
                }
            } else {
                // Deinterleave: tmpBuf = [L0, R0, L1, R1, ...] → separate L/R
                if ablPointer.count >= 2 {
                    let leftPtr = ablPointer[0].mData!.assumingMemoryBound(to: Float.self)
                    let rightPtr = ablPointer[1].mData!.assumingMemoryBound(to: Float.self)
                    for i in 0..<Int(frames) {
                        leftPtr[i] = tmpBuf[i * 2]
                        rightPtr[i] = tmpBuf[i * 2 + 1]
                    }
                }
            }
            self.totalFramesRendered += UInt64(frames)
            return noErr
        }

        engine.attach(srcNode)
        engine.connect(srcNode, to: engine.mainMixerNode, format: format)

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            try engine.start()
            audioEngine = engine
            isPlaying = true
            NSLog("[\(DspAudioService.tag)] Audio engine started (sampleRate=\(sampleRate))")
        } catch {
            NSLog("[\(DspAudioService.tag)] Audio engine start failed: \(error)")
            isPlaying = false
        }
    }

    func stop() {
        guard isPlaying else { return }
        isPlaying = false

        audioEngine?.stop()
        audioEngine = nil

        interleavedBuffer?.deallocate()
        interleavedBuffer = nil

        let totalSec = Double(totalFramesRendered) / 48000.0
        NSLog("[\(DspAudioService.tag)] Audio engine stopped: \(totalFramesRendered) frames (\(String(format: "%.1f", totalSec))s)")
        enginePtr = 0
    }
}
