// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/dsp/dsp_constants.dart';
import 'package:hexatuneapp/src/core/dsp/models/dsp_state.dart';

/// DspService requires native FFI bindings that are not available in test mode.
/// These tests verify the public API surface and constant integration.
/// Full integration tests run on physical devices during Android testing.
void main() {
  group('DspService', () {
    group('static constants match DspConstants', () {
      test('default gains are initialized from DspConstants', () {
        const state = DspState();
        expect(state.baseGain, DspConstants.defaultBaseGain);
        expect(state.textureGain, DspConstants.defaultTextureGain);
        expect(state.eventGain, DspConstants.defaultEventGain);
        expect(state.binauralGain, DspConstants.defaultBinauralGain);
        expect(state.masterGain, DspConstants.defaultMasterGain);
      });

      test('default carrier frequency matches', () {
        const state = DspState();
        expect(state.carrierFrequency, DspConstants.carrierFrequency);
      });

      test('default binaural enabled matches', () {
        const state = DspState();
        expect(state.binauralEnabled, isTrue);
      });
    });

    group('DspState transitions', () {
      test('initial state is idle', () {
        const state = DspState();
        expect(state.isInitialized, isFalse);
        expect(state.isPlaying, isFalse);
        expect(state.isBaseLoaded, isFalse);
        expect(state.hasError, isFalse);
      });

      test('state can transition to initialized', () {
        final state = const DspState().copyWith(isInitialized: true);
        expect(state.isInitialized, isTrue);
        expect(state.isPlaying, isFalse);
      });

      test('state can transition to playing', () {
        final state = const DspState().copyWith(
          isInitialized: true,
          isPlaying: true,
          isBaseLoaded: true,
        );
        expect(state.isPlaying, isTrue);
        expect(state.isBaseLoaded, isTrue);
      });

      test('state can represent error', () {
        final state = const DspState().copyWith(
          error: 'FFI library not available',
        );
        expect(state.hasError, isTrue);
        expect(state.error, contains('FFI'));
      });

      test('state can recover from error', () {
        final errorState = const DspState(error: 'init failed');
        final recoveredState = errorState.copyWith(
          error: null,
          isInitialized: true,
        );
        expect(recoveredState.hasError, isFalse);
        expect(recoveredState.isInitialized, isTrue);
      });
    });

    group('gain state changes', () {
      test('gains can be updated independently', () {
        var state = const DspState();
        state = state.copyWith(baseGain: 0.8);
        expect(state.baseGain, 0.8);
        expect(state.textureGain, DspConstants.defaultTextureGain);
      });

      test('all gains can be at maximum', () {
        const state = DspState(
          baseGain: 1.0,
          textureGain: 1.0,
          eventGain: 1.0,
          binauralGain: 1.0,
          masterGain: 1.0,
        );
        expect(state.baseGain, 1.0);
        expect(state.textureGain, 1.0);
        expect(state.eventGain, 1.0);
        expect(state.binauralGain, 1.0);
        expect(state.masterGain, 1.0);
      });

      test('all gains can be at minimum', () {
        const state = DspState(
          baseGain: 0.0,
          textureGain: 0.0,
          eventGain: 0.0,
          binauralGain: 0.0,
          masterGain: 0.0,
        );
        expect(state.baseGain, 0.0);
        expect(state.masterGain, 0.0);
      });
    });
  });
}
