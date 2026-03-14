// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/hardware/headset/headset_detector_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HeadsetDetectorChannel', () {
    late HeadsetDetectorChannel channel;

    setUp(() {
      channel = HeadsetDetectorChannel();
    });

    test('can be instantiated', () {
      expect(channel, isNotNull);
    });

    test('getCurrentState returns state from platform', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('com.hexatune/audio_device_detector'),
            (call) async {
              if (call.method == 'getCurrentState') {
                return {'wired': true, 'wireless': false};
              }
              return null;
            },
          );

      final state = await channel.getCurrentState();
      expect(state.wired, true);
      expect(state.wireless, false);

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('com.hexatune/audio_device_detector'),
            null,
          );
    });

    test(
      'getCurrentState defaults to false when platform returns null',
      () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              const MethodChannel('com.hexatune/audio_device_detector'),
              (call) async {
                if (call.method == 'getCurrentState') {
                  return <String, bool>{};
                }
                return null;
              },
            );

        final state = await channel.getCurrentState();
        expect(state.wired, false);
        expect(state.wireless, false);

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              const MethodChannel('com.hexatune/audio_device_detector'),
              null,
            );
      },
    );
  });
}
