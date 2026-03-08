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

    private static let framesPerBuffer: UInt32 = 1024
    private static let tag = "HTD"

    init() {
        audioEngine = nil
    }

    func start(sampleRate: Int, enginePointer: UInt) {
        guard !isPlaying else { return }
        enginePtr = enginePointer
        totalFramesRendered = 0

        let engine = AVAudioEngine()
        let format = AVAudioFormat(
            commonFormat: .pcmFormatFloat32,
            sampleRate: Double(sampleRate),
            channels: 2,
            interleaved: true
        )!

        let srcNode = AVAudioSourceNode { [weak self] _, _, frameCount, audioBufferList -> OSStatus in
            guard let self = self, self.isPlaying else {
                let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
                for buffer in ablPointer {
                    memset(buffer.mData, 0, Int(buffer.mDataByteSize))
                }
                return noErr
            }

            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            for buffer in ablPointer {
                guard let data = buffer.mData else { continue }
                let floatPtr = data.assumingMemoryBound(to: Float.self)
                let frames = min(frameCount, UInt32(buffer.mDataByteSize) / (2 * MemoryLayout<Float>.stride))
                let rc = htd_engine_render(
                    OpaquePointer(bitPattern: self.enginePtr),
                    floatPtr,
                    frames
                )
                if rc != 0 {
                    NSLog("[\(DspAudioService.tag)] Render error: \(rc)")
                    memset(data, 0, Int(buffer.mDataByteSize))
                }
                self.totalFramesRendered += UInt64(frames)
            }
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

        let totalSec = Double(totalFramesRendered) / 48000.0
        NSLog("[\(DspAudioService.tag)] Audio engine stopped: \(totalFramesRendered) frames (\(String(format: "%.1f", totalSec))s)")
        enginePtr = 0
    }
}
