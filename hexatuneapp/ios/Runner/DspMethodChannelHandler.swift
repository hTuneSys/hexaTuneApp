// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import Foundation
import Flutter

/// Handles the `com.hexatune/dsp_audio` MethodChannel on iOS.
///
/// Bridges Flutter DSP commands to the native DspAudioService and
/// the statically-linked hexaTuneDsp FFI library.
class DspMethodChannelHandler: NSObject {
    private let dspAudioService = DspAudioService()
    private let decoder = DspAudioDecoder()
    private var decodeCache: [String: DspAudioDecoder.DecodedAudio] = [:]

    private static let tag = "HTD"

    func register(with messenger: FlutterBinaryMessenger) {
        let channel = FlutterMethodChannel(
            name: "com.hexatune/dsp_audio",
            binaryMessenger: messenger
        )
        channel.setMethodCallHandler { [weak self] call, result in
            self?.handle(call: call, result: result)
        }
    }

    private func getOrDecode(_ assetPath: String) -> DspAudioDecoder.DecodedAudio? {
        if let cached = decodeCache[assetPath] { return cached }
        guard let decoded = decodeFlutterAsset(assetPath) else { return nil }
        decodeCache[assetPath] = decoded
        return decoded
    }

    private func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any]

        switch call.method {
        case "startAudio":
            let sampleRate = args?["sampleRate"] as? Int ?? 48000
            let enginePtr = (args?["enginePtr"] as? NSNumber)?.uintValue ?? 0
            dspAudioService.start(sampleRate: sampleRate, enginePointer: enginePtr)
            result(nil)

        case "stopAudio":
            dspAudioService.stop()
            result(nil)

        case "loadBase":
            guard let assetPath = args?["assetPath"] as? String,
                  let enginePtr = (args?["enginePtr"] as? NSNumber)?.uintValue else {
                result(FlutterError(code: "ARGS", message: "Missing arguments", details: nil))
                return
            }
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self = self,
                      let audio = self.getOrDecode(assetPath) else {
                    DispatchQueue.main.async { result(FlutterError(code: "DECODE", message: "Decode failed", details: nil)) }
                    return
                }
                let rc = audio.samples.withUnsafeBufferPointer { ptr -> Int32 in
                    var config = HtdLayerConfig(
                        samples: ptr.baseAddress,
                        num_frames: UInt32(audio.numFrames),
                        channels: UInt32(audio.channels)
                    )
                    return htd_engine_set_base(OpaquePointer(bitPattern: enginePtr), &config)
                }
                NSLog("[\(DspMethodChannelHandler.tag)] loadBase: \(assetPath) -> rc=\(rc)")
                DispatchQueue.main.async { result(Int(rc)) }
            }

        case "loadTexture":
            guard let assetPath = args?["assetPath"] as? String,
                  let enginePtr = (args?["enginePtr"] as? NSNumber)?.uintValue,
                  let index = args?["index"] as? Int else {
                result(FlutterError(code: "ARGS", message: "Missing arguments", details: nil))
                return
            }
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self = self,
                      let audio = self.getOrDecode(assetPath) else {
                    DispatchQueue.main.async { result(FlutterError(code: "DECODE", message: "Decode failed", details: nil)) }
                    return
                }
                let rc = audio.samples.withUnsafeBufferPointer { ptr -> Int32 in
                    var config = HtdLayerConfig(
                        samples: ptr.baseAddress,
                        num_frames: UInt32(audio.numFrames),
                        channels: UInt32(audio.channels)
                    )
                    return htd_engine_set_texture(OpaquePointer(bitPattern: enginePtr), UInt32(index), &config)
                }
                NSLog("[\(DspMethodChannelHandler.tag)] loadTexture[\(index)]: \(assetPath) -> rc=\(rc)")
                DispatchQueue.main.async { result(Int(rc)) }
            }

        case "loadEvent":
            guard let assetPath = args?["assetPath"] as? String,
                  let enginePtr = (args?["enginePtr"] as? NSNumber)?.uintValue,
                  let index = args?["index"] as? Int else {
                result(FlutterError(code: "ARGS", message: "Missing arguments", details: nil))
                return
            }
            let minMs = args?["minIntervalMs"] as? Int ?? 3000
            let maxMs = args?["maxIntervalMs"] as? Int ?? 8000
            let volMin = Float(args?["volumeMin"] as? Double ?? 0.3)
            let volMax = Float(args?["volumeMax"] as? Double ?? 0.8)
            let panMin = Float(args?["panMin"] as? Double ?? -0.5)
            let panMax = Float(args?["panMax"] as? Double ?? 0.5)

            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self = self,
                      let audio = self.getOrDecode(assetPath) else {
                    DispatchQueue.main.async { result(FlutterError(code: "DECODE", message: "Decode failed", details: nil)) }
                    return
                }
                let rc = audio.samples.withUnsafeBufferPointer { ptr -> Int32 in
                    var config = HtdEventConfig(
                        samples: ptr.baseAddress,
                        num_frames: UInt32(audio.numFrames),
                        channels: UInt32(audio.channels),
                        min_interval_ms: UInt32(minMs),
                        max_interval_ms: UInt32(maxMs),
                        volume_min: volMin,
                        volume_max: volMax,
                        pan_min: panMin,
                        pan_max: panMax
                    )
                    return htd_engine_set_event(OpaquePointer(bitPattern: enginePtr), UInt32(index), &config)
                }
                NSLog("[\(DspMethodChannelHandler.tag)] loadEvent[\(index)]: \(assetPath) -> rc=\(rc)")
                DispatchQueue.main.async { result(Int(rc)) }
            }

        case "clearBase":
            guard let enginePtr = (args?["enginePtr"] as? NSNumber)?.uintValue else {
                result(FlutterError(code: "ARGS", message: "Missing enginePtr", details: nil))
                return
            }
            let rc = htd_engine_clear_base(OpaquePointer(bitPattern: enginePtr))
            result(Int(rc))

        case "clearTexture":
            guard let enginePtr = (args?["enginePtr"] as? NSNumber)?.uintValue,
                  let index = args?["index"] as? Int else {
                result(FlutterError(code: "ARGS", message: "Missing arguments", details: nil))
                return
            }
            let rc = htd_engine_clear_texture(OpaquePointer(bitPattern: enginePtr), UInt32(index))
            result(Int(rc))

        case "clearEvent":
            guard let enginePtr = (args?["enginePtr"] as? NSNumber)?.uintValue,
                  let index = args?["index"] as? Int else {
                result(FlutterError(code: "ARGS", message: "Missing arguments", details: nil))
                return
            }
            let rc = htd_engine_clear_event(OpaquePointer(bitPattern: enginePtr), UInt32(index))
            result(Int(rc))

        case "clearAllLayers":
            guard let enginePtr = (args?["enginePtr"] as? NSNumber)?.uintValue else {
                result(FlutterError(code: "ARGS", message: "Missing enginePtr", details: nil))
                return
            }
            let rc = htd_engine_clear_all_layers(OpaquePointer(bitPattern: enginePtr))
            result(Int(rc))

        case "clearDecodeCache":
            let count = decodeCache.count
            decodeCache.removeAll()
            NSLog("[\(DspMethodChannelHandler.tag)] Decode cache cleared (\(count) entries)")
            result(count)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func decodeFlutterAsset(_ assetPath: String) -> DspAudioDecoder.DecodedAudio? {
        let key = FlutterDartProject.lookupKey(forAsset: assetPath)
        guard let bundlePath = Bundle.main.path(forResource: key, ofType: nil) else {
            NSLog("[\(DspMethodChannelHandler.tag)] Flutter asset not found: \(assetPath)")
            return nil
        }
        return decoder.decodeAsset(path: bundlePath)
    }
}
