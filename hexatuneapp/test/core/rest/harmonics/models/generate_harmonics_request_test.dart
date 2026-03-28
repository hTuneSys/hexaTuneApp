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
      expect(request.inventoryIds, isNull);
    });

    test('can be created with inventoryIds for Inventory source type', () {
      final request = GenerateHarmonicsRequest(
        generationType: 'Binaural',
        sourceType: 'Inventory',
        sourceId: 'tracking-uuid-001',
        inventoryIds: ['inv-001', 'inv-002', 'inv-003'],
      );
      expect(request.sourceType, 'Inventory');
      expect(request.sourceId, 'tracking-uuid-001');
      expect(request.inventoryIds, ['inv-001', 'inv-002', 'inv-003']);
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
      expect(json['inventoryIds'], isNull);
    });

    test('serializes inventoryIds to JSON when provided', () {
      final request = GenerateHarmonicsRequest(
        generationType: 'Binaural',
        sourceType: 'Inventory',
        sourceId: 'tracking-uuid',
        inventoryIds: ['inv-a', 'inv-b'],
      );
      final json = request.toJson();
      expect(json['sourceType'], 'Inventory');
      expect(json['inventoryIds'], ['inv-a', 'inv-b']);
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
      expect(request.inventoryIds, isNull);
    });

    test('deserializes inventoryIds from JSON correctly', () {
      final json = {
        'generationType': 'Binaural',
        'sourceType': 'Inventory',
        'sourceId': 'tracking-uuid',
        'inventoryIds': ['inv-001', 'inv-002'],
      };
      final request = GenerateHarmonicsRequest.fromJson(json);
      expect(request.sourceType, 'Inventory');
      expect(request.inventoryIds, ['inv-001', 'inv-002']);
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

    test('equality considers inventoryIds', () {
      final a = GenerateHarmonicsRequest(
        generationType: 'Binaural',
        sourceType: 'Inventory',
        sourceId: 'uuid-1',
        inventoryIds: ['inv-001'],
      );
      final b = GenerateHarmonicsRequest(
        generationType: 'Binaural',
        sourceType: 'Inventory',
        sourceId: 'uuid-1',
        inventoryIds: ['inv-001'],
      );
      final c = GenerateHarmonicsRequest(
        generationType: 'Binaural',
        sourceType: 'Inventory',
        sourceId: 'uuid-1',
        inventoryIds: ['inv-002'],
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

    test('round-trip serialization preserves inventoryIds', () {
      final original = GenerateHarmonicsRequest(
        generationType: 'Binaural',
        sourceType: 'Inventory',
        sourceId: 'tracking-uuid',
        inventoryIds: ['inv-a', 'inv-b', 'inv-c'],
      );
      final roundTripped = GenerateHarmonicsRequest.fromJson(original.toJson());
      expect(roundTripped, equals(original));
      expect(roundTripped.inventoryIds, ['inv-a', 'inv-b', 'inv-c']);
    });
  });
}
