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
      );
      expect(result.id, 'item-001');
      expect(result.inventoryId, 'inv-001');
      expect(result.sortOrder, 1);
      expect(result.quantity, 10);
    });

    test('serializes to JSON correctly', () {
      final result = const FormulaItemResponse(
        id: 'item-001',
        inventoryId: 'inv-001',
        sortOrder: 1,
        quantity: 10,
      );
      final json = result.toJson();
      expect(json['id'], 'item-001');
      expect(json['inventoryId'], 'inv-001');
      expect(json['sortOrder'], 1);
      expect(json['quantity'], 10);
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'id': 'item-001',
        'inventoryId': 'inv-001',
        'sortOrder': 1,
        'quantity': 10,
      };
      final result = FormulaItemResponse.fromJson(json);
      expect(result.id, 'item-001');
      expect(result.inventoryId, 'inv-001');
      expect(result.sortOrder, 1);
      expect(result.quantity, 10);
    });

    test('equality works correctly', () {
      final a = const FormulaItemResponse(
        id: 'item-001',
        inventoryId: 'inv-001',
        sortOrder: 1,
        quantity: 10,
      );
      final b = const FormulaItemResponse(
        id: 'item-001',
        inventoryId: 'inv-001',
        sortOrder: 1,
        quantity: 10,
      );
      final c = const FormulaItemResponse(
        id: 'different',
        inventoryId: 'inv-001',
        sortOrder: 1,
        quantity: 10,
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
      );
      final roundTripped = FormulaItemResponse.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
