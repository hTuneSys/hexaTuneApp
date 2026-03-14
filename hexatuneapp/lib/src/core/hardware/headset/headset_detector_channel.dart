// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/services.dart';

/// Platform channel wrapper for native audio device detection.
///
/// Uses [AudioManager.registerAudioDeviceCallback] on Android and
/// [AVAudioSession.routeChangeNotification] on iOS to detect wired
/// and wireless (including BLE) headset connections.
class HeadsetDetectorChannel {
  static const _methodChannel = MethodChannel(
    'com.hexatune/audio_device_detector',
  );
  static const _eventChannel = EventChannel('com.hexatune/audio_device_events');

  /// Queries the current wired/wireless headset connection state.
  ///
  /// Returns a map with `wired` and `wireless` boolean values.
  Future<({bool wired, bool wireless})> getCurrentState() async {
    final result = await _methodChannel.invokeMapMethod<String, bool>(
      'getCurrentState',
    );
    return (
      wired: result?['wired'] ?? false,
      wireless: result?['wireless'] ?? false,
    );
  }

  /// A broadcast stream of headset events.
  ///
  /// Emits string event names: `wired_connected`, `wired_disconnected`,
  /// `wireless_connected`, `wireless_disconnected`.
  Stream<String> get events {
    return _eventChannel.receiveBroadcastStream().map((e) => e as String);
  }
}
