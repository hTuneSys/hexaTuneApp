// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import Flutter
import AVFoundation

/// Detects wired and wireless (including BLE) audio device connections
/// using `AVAudioSession.routeChangeNotification`.
///
/// Communicates with the Dart side via a `FlutterMethodChannel` for queries
/// and a `FlutterEventChannel` for real-time connection/disconnection events.
class AudioDeviceDetector: NSObject, FlutterStreamHandler {
    private let methodChannel: FlutterMethodChannel
    private let eventChannel: FlutterEventChannel
    private var eventSink: FlutterEventSink?

    init(messenger: FlutterBinaryMessenger) {
        methodChannel = FlutterMethodChannel(
            name: "com.hexatune/audio_device_detector",
            binaryMessenger: messenger
        )
        eventChannel = FlutterEventChannel(
            name: "com.hexatune/audio_device_events",
            binaryMessenger: messenger
        )
        super.init()
    }

    func start() {
        methodChannel.setMethodCallHandler { [weak self] call, result in
            self?.onMethodCall(call, result: result)
        }
        eventChannel.setStreamHandler(self)
    }

    // MARK: - FlutterStreamHandler

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleRouteChange),
            name: AVAudioSession.routeChangeNotification,
            object: AVAudioSession.sharedInstance()
        )
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        NotificationCenter.default.removeObserver(
            self,
            name: AVAudioSession.routeChangeNotification,
            object: AVAudioSession.sharedInstance()
        )
        eventSink = nil
        return nil
    }

    // MARK: - Route change handling

    @objc private func handleRouteChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
            return
        }

        switch reason {
        case .newDeviceAvailable:
            let route = AVAudioSession.sharedInstance().currentRoute
            if hasWiredHeadset(in: route) {
                eventSink?("wired_connected")
            } else if hasWirelessHeadset(in: route) {
                eventSink?("wireless_connected")
            }

        case .oldDeviceUnavailable:
            if let previousRoute = userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription {
                if hasWiredHeadset(in: previousRoute) {
                    eventSink?("wired_disconnected")
                } else if hasWirelessHeadset(in: previousRoute) {
                    eventSink?("wireless_disconnected")
                }
            }

        default:
            break
        }
    }

    // MARK: - Method channel

    private func onMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getCurrentState":
            let route = AVAudioSession.sharedInstance().currentRoute
            result([
                "wired": hasWiredHeadset(in: route),
                "wireless": hasWirelessHeadset(in: route),
            ])
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Device type helpers

    private func hasWiredHeadset(in route: AVAudioSessionRouteDescription) -> Bool {
        return route.outputs.contains { $0.portType == .headphones || $0.portType == .usbAudio }
    }

    private func hasWirelessHeadset(in route: AVAudioSessionRouteDescription) -> Bool {
        return route.outputs.contains {
            $0.portType == .bluetoothA2DP ||
            $0.portType == .bluetoothHFP ||
            $0.portType == .bluetoothLE
        }
    }
}
