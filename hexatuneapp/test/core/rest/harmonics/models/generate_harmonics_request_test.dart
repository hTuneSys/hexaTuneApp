// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/harmonics/models/generate_harmonics_request.dart';

void main() {
  group('GenerateHarmonicsRequest', () {
    test('can be created with required fields', () {
      final request = GenerateHarmonicsRequest(
        generationType: 'Binaural',
        sourceType: 'Formula',
        sourceId: 'frm-001',
      );
      expect(request.generationType, 'Binaural');
      expect(request.sourceType, 'Formula');
      expect(request.sourceId, 'frm-001');
    });

    test('serializes to JSON correctly', () {
      final request = GenerateHarmonicsRequest(
        generationType: 'Monaural',
        sourceType: 'Formula',
        sourceId: 'frm-abc',
      );
      final json = request.toJson();
      expect(json['generationType'], 'Monaural');
      expect(json['sourceType'], 'Formula');
      expect(json['sourceId'], 'frm-abc');
    });

    test('deserializes from JSON correctly', () {
      final json = {
        'generationType': 'Magnetic',
        'sourceType': 'Flow',
        'sourceId': 'flow-123',
      };
      final request = GenerateHarmonicsRequest.fromJson(json);
      expect(request.generationType, 'Magnetic');
      expect(request.sourceType, 'Flow');
      expect(request.sourceId, 'flow-123');
    });

    test('equality works correctly', () {
      final a = GenerateHarmonicsRequest(
        generationType: 'Binaural',
        sourceType: 'Formula',
        sourceId: 'frm-001',
      );
      final b = GenerateHarmonicsRequest(
        generationType: 'Binaural',
        sourceType: 'Formula',
        sourceId: 'frm-001',
      );
      final c = GenerateHarmonicsRequest(
        generationType: 'Monaural',
        sourceType: 'Formula',
        sourceId: 'frm-001',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = GenerateHarmonicsRequest(
        generationType: 'Quantal',
        sourceType: 'Formula',
        sourceId: 'frm-xyz',
      );
      final roundTripped = GenerateHarmonicsRequest.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
