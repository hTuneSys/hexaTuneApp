// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/harmonizer/models/harmonizer_state.dart';
import 'package:hexatuneapp/src/core/harmonizer/models/generation_type.dart';
import 'package:hexatuneapp/src/core/rest/harmonics/models/harmonic_packet_dto.dart';

void main() {
  group('HarmonizerState', () {
    test('default state is idle with empty sequence', () {
      const state = HarmonizerState();
      expect(state.status, HarmonizerStatus.idle);
      expect(state.activeType, isNull);
      expect(state.ambienceId, isNull);
      expect(state.formulaId, isNull);
      expect(state.sequence, isEmpty);
      expect(state.currentCycle, 0);
      expect(state.currentStepIndex, 0);
      expect(state.totalCycleDuration, Duration.zero);
      expect(state.firstCycleDuration, Duration.zero);
      expect(state.remainingInCycle, Duration.zero);
      expect(state.isFirstCycle, isTrue);
      expect(state.errorMessage, isNull);
      expect(state.gracefulStopRequested, isFalse);
    });

    test('copyWith preserves unchanged fields', () {
      const state = HarmonizerState();
      final updated = state.copyWith(status: HarmonizerStatus.playing);

      expect(updated.status, HarmonizerStatus.playing);
      expect(updated.activeType, isNull);
      expect(updated.sequence, isEmpty);
    });

    test('copyWith updates multiple fields', () {
      const packets = [
        HarmonicPacketDto(value: 5, durationMs: 30000, isOneShot: false),
        HarmonicPacketDto(value: 10, durationMs: 15000, isOneShot: true),
      ];

      final state = const HarmonizerState().copyWith(
        activeType: GenerationType.binaural,
        status: HarmonizerStatus.playing,
        ambienceId: 'test-ambience',
        formulaId: 'formula-42',
        sequence: packets,
        currentCycle: 2,
        currentStepIndex: 1,
        totalCycleDuration: const Duration(seconds: 30),
        firstCycleDuration: const Duration(seconds: 45),
        remainingInCycle: const Duration(seconds: 15),
        isFirstCycle: false,
        gracefulStopRequested: true,
      );

      expect(state.activeType, GenerationType.binaural);
      expect(state.status, HarmonizerStatus.playing);
      expect(state.ambienceId, 'test-ambience');
      expect(state.formulaId, 'formula-42');
      expect(state.sequence.length, 2);
      expect(state.currentCycle, 2);
      expect(state.currentStepIndex, 1);
      expect(state.totalCycleDuration, const Duration(seconds: 30));
      expect(state.firstCycleDuration, const Duration(seconds: 45));
      expect(state.remainingInCycle, const Duration(seconds: 15));
      expect(state.isFirstCycle, isFalse);
      expect(state.gracefulStopRequested, isTrue);
    });

    test('error state includes message', () {
      final state = const HarmonizerState().copyWith(
        status: HarmonizerStatus.error,
        errorMessage: 'DSP init failed',
      );
      expect(state.status, HarmonizerStatus.error);
      expect(state.errorMessage, 'DSP init failed');
    });

    test('equality works correctly', () {
      const a = HarmonizerState();
      const b = HarmonizerState();
      expect(a, equals(b));

      final c = a.copyWith(status: HarmonizerStatus.playing);
      expect(a, isNot(equals(c)));
    });
  });

  group('HarmonizerStatus', () {
    test('has all expected values', () {
      expect(HarmonizerStatus.values, hasLength(5));
      expect(HarmonizerStatus.values, contains(HarmonizerStatus.idle));
      expect(HarmonizerStatus.values, contains(HarmonizerStatus.preparing));
      expect(HarmonizerStatus.values, contains(HarmonizerStatus.playing));
      expect(HarmonizerStatus.values, contains(HarmonizerStatus.stopping));
      expect(HarmonizerStatus.values, contains(HarmonizerStatus.error));
    });
  });
}
