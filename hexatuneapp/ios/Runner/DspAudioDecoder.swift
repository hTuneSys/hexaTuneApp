// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import Foundation
import AVFoundation

/// Decodes audio asset files (WAV, M4A, MP3, etc.) into PCM Float32 buffers.
class DspAudioDecoder {

    struct DecodedAudio {
        let samples: [Float]
        let numFrames: Int
        let channels: Int
        let sampleRate: Int
    }

    private static let tag = "HTD"

    func decodeAsset(path: String) -> DecodedAudio? {
        let url: URL
        if path.hasPrefix("/") {
            url = URL(fileURLWithPath: path)
        } else {
            guard let bundlePath = Bundle.main.path(forResource: path, ofType: nil) else {
                NSLog("[\(DspAudioDecoder.tag)] Asset not found: \(path)")
                return nil
            }
            url = URL(fileURLWithPath: bundlePath)
        }

        guard let audioFile = try? AVAudioFile(forReading: url) else {
            NSLog("[\(DspAudioDecoder.tag)] Cannot open audio file: \(path)")
            return nil
        }

        // AVAudioPCMBuffer and AVAudioFile.read require non-interleaved format.
        // We interleave manually afterward for the DSP engine.
        let format = AVAudioFormat(
            commonFormat: .pcmFormatFloat32,
            sampleRate: audioFile.processingFormat.sampleRate,
            channels: audioFile.processingFormat.channelCount,
            interleaved: false
        )!

        let frameCount = AVAudioFrameCount(audioFile.length)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else {
            NSLog("[\(DspAudioDecoder.tag)] Cannot create PCM buffer: \(path)")
            return nil
        }

        do {
            try audioFile.read(into: buffer)
        } catch {
            NSLog("[\(DspAudioDecoder.tag)] Read failed for \(path): \(error)")
            return nil
        }

        let channels = Int(format.channelCount)
        let numFrames = Int(buffer.frameLength)
        let totalSamples = numFrames * channels

        var samples = [Float](repeating: 0, count: totalSamples)
        if let floatData = buffer.floatChannelData {
            // Non-interleaved buffer → interleave for DSP engine
            for frame in 0..<numFrames {
                for ch in 0..<channels {
                    samples[frame * channels + ch] = floatData[ch][frame]
                }
            }
        }

        let sampleRate = Int(audioFile.processingFormat.sampleRate)
        NSLog("[\(DspAudioDecoder.tag)] Decoded: \(path) (\(numFrames) frames, \(channels)ch, \(sampleRate)Hz)")
        return DecodedAudio(samples: samples, numFrames: numFrames, channels: channels, sampleRate: sampleRate)
    }
}
