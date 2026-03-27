// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/dsp/dsp_constants.dart';
import 'package:hexatuneapp/src/core/dsp/models/dsp_state.dart';

void main() {
  group('DspState', () {
    test('default constructor provides correct defaults', () {
      const state = DspState();
      expect(state.isInitialized, isFalse);
      expect(state.isRendering, isFalse);
      expect(state.isBaseLoaded, isFalse);
      expect(state.carrierFrequency, DspConstants.carrierFrequency);
      expect(state.binauralEnabled, isTrue);
      expect(state.baseGain, DspConstants.defaultBaseGain);
      expect(state.textureGain, DspConstants.defaultTextureGain);
      expect(state.eventGain, DspConstants.defaultEventGain);
      expect(state.binauralGain, DspConstants.defaultBinauralGain);
      expect(state.masterGain, DspConstants.defaultMasterGain);
      expect(state.error, isNull);
    });

    test('hasError returns false when error is null', () {
      const state = DspState();
      expect(state.hasError, isFalse);
    });

    test('hasError returns true when error is set', () {
      const state = DspState(error: 'Engine init failed');
      expect(state.hasError, isTrue);
      expect(state.error, 'Engine init failed');
    });

    test('can be created with custom values', () {
      const state = DspState(
        isInitialized: true,
        isRendering: true,
        isBaseLoaded: true,
        carrierFrequency: 440.0,
        binauralEnabled: false,
        baseGain: 0.8,
        textureGain: 0.5,
        eventGain: 0.2,
        binauralGain: 0.1,
        masterGain: 0.9,
      );
      expect(state.isInitialized, isTrue);
      expect(state.isRendering, isTrue);
      expect(state.isBaseLoaded, isTrue);
      expect(state.carrierFrequency, 440.0);
      expect(state.binauralEnabled, isFalse);
      expect(state.baseGain, 0.8);
      expect(state.textureGain, 0.5);
      expect(state.eventGain, 0.2);
      expect(state.binauralGain, 0.1);
      expect(state.masterGain, 0.9);
    });

    test('equality works correctly', () {
      const a = DspState(isRendering: true, baseGain: 0.5);
      const b = DspState(isRendering: true, baseGain: 0.5);
      expect(a, equals(b));
    });

    test('inequality when fields differ', () {
      const a = DspState(isRendering: true);
      const b = DspState(isRendering: false);
      expect(a, isNot(equals(b)));
    });

    test('copyWith creates modified copy', () {
      const original = DspState(isInitialized: true, baseGain: 0.6);
      final modified = original.copyWith(isRendering: true);
      expect(modified.isInitialized, isTrue);
      expect(modified.isRendering, isTrue);
      expect(modified.baseGain, 0.6);
    });

    test('copyWith can set error', () {
      const original = DspState();
      final withError = original.copyWith(error: 'Something went wrong');
      expect(withError.hasError, isTrue);
      expect(withError.error, 'Something went wrong');
    });

    test('copyWith can clear error', () {
      const withError = DspState(error: 'Previous error');
      final cleared = withError.copyWith(error: null);
      expect(cleared.hasError, isFalse);
    });

    test('hashCode consistent with equality', () {
      const a = DspState(masterGain: 0.75);
      const b = DspState(masterGain: 0.75);
      expect(a.hashCode, equals(b.hashCode));
    });

    test('toString produces readable output', () {
      const state = DspState(isRendering: true);
      final str = state.toString();
      expect(str, contains('DspState'));
    });

    test('default gains match DspConstants', () {
      const state = DspState();
      expect(state.baseGain, DspConstants.defaultBaseGain);
      expect(state.textureGain, DspConstants.defaultTextureGain);
      expect(state.eventGain, DspConstants.defaultEventGain);
      expect(state.binauralGain, DspConstants.defaultBinauralGain);
      expect(state.masterGain, DspConstants.defaultMasterGain);
    });
  });
}
