// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/harmonizer/models/harmonizer_config.dart';
import 'package:hexatuneapp/src/core/harmonizer/models/generation_type.dart';
import 'package:hexatuneapp/src/core/rest/harmonics/models/harmonic_packet_dto.dart';

void main() {
  group('HarmonizerConfig', () {
    test('creates monaural config without ambience', () {
      const config = HarmonizerConfig(
        type: GenerationType.monaural,
        steps: [
          HarmonicPacketDto(value: 5, durationMs: 30000, isOneShot: false),
        ],
      );

      expect(config.type, GenerationType.monaural);
      expect(config.ambienceId, isNull);
      expect(config.steps.length, 1);
    });

    test('creates binaural config with ambience', () {
      const config = HarmonizerConfig(
        type: GenerationType.binaural,
        ambienceId: 'rain-ambient',
        steps: [
          HarmonicPacketDto(value: 10, durationMs: 60000, isOneShot: false),
          HarmonicPacketDto(value: 7, durationMs: 30000, isOneShot: true),
        ],
      );

      expect(config.type, GenerationType.binaural);
      expect(config.ambienceId, 'rain-ambient');
      expect(config.steps.length, 2);
    });

    test('creates magnetic config', () {
      const config = HarmonizerConfig(
        type: GenerationType.magnetic,
        steps: [
          HarmonicPacketDto(value: 440, durationMs: 5000, isOneShot: false),
        ],
      );

      expect(config.type, GenerationType.magnetic);
      expect(config.ambienceId, isNull);
      expect(config.steps.first.value, 440);
    });

    test('equality works', () {
      const a = HarmonizerConfig(
        type: GenerationType.monaural,
        steps: [
          HarmonicPacketDto(value: 5, durationMs: 30000, isOneShot: false),
        ],
      );
      const b = HarmonizerConfig(
        type: GenerationType.monaural,
        steps: [
          HarmonicPacketDto(value: 5, durationMs: 30000, isOneShot: false),
        ],
      );
      expect(a, equals(b));
    });

    test('copyWith works', () {
      const config = HarmonizerConfig(
        type: GenerationType.monaural,
        steps: [
          HarmonicPacketDto(value: 5, durationMs: 30000, isOneShot: false),
        ],
      );
      final updated = config.copyWith(ambienceId: 'rain');
      expect(updated.ambienceId, 'rain');
      expect(updated.type, GenerationType.monaural);
    });
  });
}
