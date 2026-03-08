// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/harmonics/models/generate_harmonics_request.dart';

void main() {
  group('GenerateHarmonicsRequest', () {
    test('can be created with inventoryIds', () {
      final request = GenerateHarmonicsRequest(
        inventoryIds: ['id-1', 'id-2', 'id-3'],
      );
      expect(request.inventoryIds, ['id-1', 'id-2', 'id-3']);
    });

    test('serializes to JSON correctly', () {
      final request = GenerateHarmonicsRequest(
        inventoryIds: ['abc-123', 'def-456'],
      );
      final json = request.toJson();
      expect(json['inventoryIds'], ['abc-123', 'def-456']);
    });

    test('deserializes from JSON correctly', () {
      final json = {
        'inventoryIds': ['abc-123', 'def-456'],
      };
      final request = GenerateHarmonicsRequest.fromJson(json);
      expect(request.inventoryIds, ['abc-123', 'def-456']);
    });

    test('supports empty inventoryIds list', () {
      final request = GenerateHarmonicsRequest(inventoryIds: []);
      expect(request.inventoryIds, isEmpty);
    });

    test('equality works correctly', () {
      final a = GenerateHarmonicsRequest(inventoryIds: ['id-1']);
      final b = GenerateHarmonicsRequest(inventoryIds: ['id-1']);
      final c = GenerateHarmonicsRequest(inventoryIds: ['id-2']);
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = GenerateHarmonicsRequest(inventoryIds: ['a', 'b', 'c']);
      final roundTripped = GenerateHarmonicsRequest.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
