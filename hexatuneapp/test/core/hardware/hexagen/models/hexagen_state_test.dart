// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/hardware/hexagen/models/hexagen_state.dart';

void main() {
  group('HexagenState', () {
    test('default state is disconnected and uninitialized', () {
      const state = HexagenState();
      expect(state.isConnected, false);
      expect(state.isInitialized, false);
      expect(state.deviceId, isNull);
      expect(state.deviceName, isNull);
      expect(state.firmwareVersion, isNull);
    });

    test('isReady is false when not connected', () {
      const state = HexagenState(isInitialized: true, firmwareVersion: '1.0.0');
      expect(state.isReady, false);
    });

    test('isReady is false when no firmware version', () {
      const state = HexagenState(isConnected: true, isInitialized: true);
      expect(state.isReady, false);
    });

    test('isReady is true when connected, initialized, and has firmware', () {
      const state = HexagenState(
        isConnected: true,
        isInitialized: true,
        firmwareVersion: '1.0.0',
      );
      expect(state.isReady, true);
    });

    test('copyWith updates individual fields', () {
      const state = HexagenState();
      final updated = state.copyWith(
        isConnected: true,
        deviceId: 'dev-1',
        deviceName: 'hexaGen',
      );
      expect(updated.isConnected, true);
      expect(updated.deviceId, 'dev-1');
      expect(updated.deviceName, 'hexaGen');
      expect(updated.isInitialized, false);
    });

    test('equality works correctly', () {
      const a = HexagenState(isConnected: true, deviceId: '1');
      const b = HexagenState(isConnected: true, deviceId: '1');
      const c = HexagenState(isConnected: false, deviceId: '1');
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('hashCode is consistent for equal instances', () {
      const a = HexagenState(isConnected: true);
      const b = HexagenState(isConnected: true);
      expect(a.hashCode, b.hashCode);
    });

    test('toString includes field values', () {
      const state = HexagenState(isConnected: true);
      final str = state.toString();
      expect(str, contains('HexagenState'));
      expect(str, contains('isConnected'));
    });
  });
}
