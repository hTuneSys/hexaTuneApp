// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/formula/models/formula_item_response.dart';

void main() {
  group('FormulaItemResponse', () {
    test('can be created with required fields', () {
      final result = const FormulaItemResponse(
        id: 'item-001',
        inventoryId: 'inv-001',
        sortOrder: 1,
        quantity: 10,
        timeMs: 1000,
        createdAt: '2026-01-01T00:00:00Z',
      );
      expect(result.id, 'item-001');
      expect(result.inventoryId, 'inv-001');
      expect(result.sortOrder, 1);
      expect(result.quantity, 10);
      expect(result.timeMs, 1000);
      expect(result.createdAt, '2026-01-01T00:00:00Z');
    });

    test('serializes to JSON correctly', () {
      final result = const FormulaItemResponse(
        id: 'item-001',
        inventoryId: 'inv-001',
        sortOrder: 1,
        quantity: 10,
        timeMs: 5000,
        createdAt: '2026-01-01T00:00:00Z',
      );
      final json = result.toJson();
      expect(json['id'], 'item-001');
      expect(json['inventoryId'], 'inv-001');
      expect(json['sortOrder'], 1);
      expect(json['quantity'], 10);
      expect(json['timeMs'], 5000);
      expect(json['createdAt'], '2026-01-01T00:00:00Z');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'id': 'item-001',
        'inventoryId': 'inv-001',
        'sortOrder': 1,
        'quantity': 10,
        'timeMs': 30000,
        'createdAt': '2026-01-01T00:00:00Z',
      };
      final result = FormulaItemResponse.fromJson(json);
      expect(result.id, 'item-001');
      expect(result.inventoryId, 'inv-001');
      expect(result.sortOrder, 1);
      expect(result.quantity, 10);
      expect(result.timeMs, 30000);
      expect(result.createdAt, '2026-01-01T00:00:00Z');
    });

    test('equality works correctly', () {
      final a = const FormulaItemResponse(
        id: 'item-001',
        inventoryId: 'inv-001',
        sortOrder: 1,
        quantity: 10,
        timeMs: 1000,
        createdAt: '2026-01-01T00:00:00Z',
      );
      final b = const FormulaItemResponse(
        id: 'item-001',
        inventoryId: 'inv-001',
        sortOrder: 1,
        quantity: 10,
        timeMs: 1000,
        createdAt: '2026-01-01T00:00:00Z',
      );
      final c = const FormulaItemResponse(
        id: 'different',
        inventoryId: 'inv-001',
        sortOrder: 1,
        quantity: 10,
        timeMs: 1000,
        createdAt: '2026-01-01T00:00:00Z',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const FormulaItemResponse(
        id: 'item-001',
        inventoryId: 'inv-001',
        sortOrder: 1,
        quantity: 10,
        timeMs: 15000,
        createdAt: '2026-01-01T00:00:00Z',
      );
      final roundTripped = FormulaItemResponse.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
