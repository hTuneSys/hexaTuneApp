// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/hardware/headset/headset_state.dart';

void main() {
  group('HeadsetState', () {
    test('default state has no connections', () {
      const state = HeadsetState();
      expect(state.wiredConnected, false);
      expect(state.wirelessConnected, false);
      expect(state.isAnyConnected, false);
    });

    test('isAnyConnected is true when wired is connected', () {
      const state = HeadsetState(wiredConnected: true);
      expect(state.isAnyConnected, true);
    });

    test('isAnyConnected is true when wireless is connected', () {
      const state = HeadsetState(wirelessConnected: true);
      expect(state.isAnyConnected, true);
    });

    test('isAnyConnected is true when both are connected', () {
      const state = HeadsetState(wiredConnected: true, wirelessConnected: true);
      expect(state.isAnyConnected, true);
    });

    test('copyWith updates wiredConnected', () {
      const state = HeadsetState();
      final updated = state.copyWith(wiredConnected: true);
      expect(updated.wiredConnected, true);
      expect(updated.wirelessConnected, false);
    });

    test('copyWith updates wirelessConnected', () {
      const state = HeadsetState();
      final updated = state.copyWith(wirelessConnected: true);
      expect(updated.wiredConnected, false);
      expect(updated.wirelessConnected, true);
    });

    test('equality works correctly', () {
      const a = HeadsetState(wiredConnected: true);
      const b = HeadsetState(wiredConnected: true);
      const c = HeadsetState(wirelessConnected: true);
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('hashCode is consistent for equal instances', () {
      const a = HeadsetState(wiredConnected: true);
      const b = HeadsetState(wiredConnected: true);
      expect(a.hashCode, b.hashCode);
    });

    test('toString includes field values', () {
      const state = HeadsetState(wiredConnected: true);
      final str = state.toString();
      expect(str, contains('HeadsetState'));
      expect(str, contains('wiredConnected'));
    });
  });
}
