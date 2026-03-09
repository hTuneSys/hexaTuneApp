// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/harmonics/models/harmonic_packet_dto.dart';

void main() {
  group('HarmonicPacketDto', () {
    test('can be created with required fields', () {
      final dto = HarmonicPacketDto(
        value: 440,
        durationMs: 30000,
        isOneShot: false,
      );
      expect(dto.value, 440);
      expect(dto.durationMs, 30000);
      expect(dto.isOneShot, false);
    });

    test('serializes to JSON correctly', () {
      final dto = HarmonicPacketDto(
        value: 528,
        durationMs: 15000,
        isOneShot: true,
      );
      final json = dto.toJson();
      expect(json['value'], 528);
      expect(json['durationMs'], 15000);
      expect(json['isOneShot'], true);
    });

    test('deserializes from JSON correctly', () {
      final json = {'value': 396, 'durationMs': 60000, 'isOneShot': false};
      final dto = HarmonicPacketDto.fromJson(json);
      expect(dto.value, 396);
      expect(dto.durationMs, 60000);
      expect(dto.isOneShot, false);
    });

    test('equality works correctly', () {
      final a = HarmonicPacketDto(
        value: 440,
        durationMs: 30000,
        isOneShot: false,
      );
      final b = HarmonicPacketDto(
        value: 440,
        durationMs: 30000,
        isOneShot: false,
      );
      final c = HarmonicPacketDto(
        value: 440,
        durationMs: 30000,
        isOneShot: true,
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = HarmonicPacketDto(
        value: 1760,
        durationMs: 45000,
        isOneShot: true,
      );
      final roundTripped = HarmonicPacketDto.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
