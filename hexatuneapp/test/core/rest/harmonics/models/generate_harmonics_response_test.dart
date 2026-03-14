// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/harmonics/models/generate_harmonics_response.dart';
import 'package:hexatuneapp/src/core/rest/harmonics/models/harmonic_packet_dto.dart';

void main() {
  group('GenerateHarmonicsResponse', () {
    test('can be created with required fields', () {
      final response = GenerateHarmonicsResponse(
        requestId: 'req-001',
        generationType: 'Binaural',
        sourceType: 'Formula',
        sourceId: 'frm-001',
        sequence: [
          HarmonicPacketDto(value: 440, durationMs: 30000, isOneShot: false),
        ],
        totalItems: 1,
      );
      expect(response.requestId, 'req-001');
      expect(response.generationType, 'Binaural');
      expect(response.sourceType, 'Formula');
      expect(response.sourceId, 'frm-001');
      expect(response.sequence, hasLength(1));
      expect(response.totalItems, 1);
    });

    test('serializes to JSON correctly', () {
      final response = GenerateHarmonicsResponse(
        requestId: 'req-abc',
        generationType: 'Monaural',
        sourceType: 'Formula',
        sourceId: 'frm-abc',
        sequence: [
          HarmonicPacketDto(value: 440, durationMs: 30000, isOneShot: false),
          HarmonicPacketDto(value: 528, durationMs: 15000, isOneShot: true),
        ],
        totalItems: 2,
      );
      final json = response.toJson();
      expect(json['requestId'], 'req-abc');
      expect(json['generationType'], 'Monaural');
      expect(json['totalItems'], 2);
      expect(json['sequence'], hasLength(2));
      expect(response.sequence.first.value, 440);
    });

    test('deserializes from JSON correctly', () {
      final json = {
        'requestId': 'req-xyz',
        'generationType': 'Magnetic',
        'sourceType': 'Flow',
        'sourceId': 'flow-001',
        'totalItems': 1,
        'sequence': [
          {'value': 396, 'durationMs': 60000, 'isOneShot': false},
        ],
      };
      final response = GenerateHarmonicsResponse.fromJson(json);
      expect(response.requestId, 'req-xyz');
      expect(response.generationType, 'Magnetic');
      expect(response.sourceType, 'Flow');
      expect(response.sourceId, 'flow-001');
      expect(response.totalItems, 1);
      expect(response.sequence.first.value, 396);
    });

    test('handles empty sequence list', () {
      final response = GenerateHarmonicsResponse(
        requestId: 'req-empty',
        generationType: 'Photonic',
        sourceType: 'Formula',
        sourceId: 'frm-empty',
        sequence: [],
        totalItems: 0,
      );
      expect(response.sequence, isEmpty);
      expect(response.totalItems, 0);
    });

    test('equality works correctly', () {
      final packet = HarmonicPacketDto(
        value: 440,
        durationMs: 30000,
        isOneShot: false,
      );
      final a = GenerateHarmonicsResponse(
        requestId: 'req-1',
        generationType: 'Binaural',
        sourceType: 'Formula',
        sourceId: 'frm-1',
        sequence: [packet],
        totalItems: 1,
      );
      final b = GenerateHarmonicsResponse(
        requestId: 'req-1',
        generationType: 'Binaural',
        sourceType: 'Formula',
        sourceId: 'frm-1',
        sequence: [packet],
        totalItems: 1,
      );
      expect(a, equals(b));
    });

    test('round-trip serialization preserves nested data', () {
      final original = GenerateHarmonicsResponse(
        requestId: 'round-trip',
        generationType: 'Binaural',
        sourceType: 'Formula',
        sourceId: 'frm-rt',
        sequence: [
          HarmonicPacketDto(value: 528, durationMs: 15000, isOneShot: true),
        ],
        totalItems: 1,
      );
      final json = original.toJson();
      json['sequence'] = (json['sequence'] as List)
          .map((p) => (p as HarmonicPacketDto).toJson())
          .toList();
      final roundTripped = GenerateHarmonicsResponse.fromJson(json);
      expect(roundTripped, equals(original));
    });
  });
}
