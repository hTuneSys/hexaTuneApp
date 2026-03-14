// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/formula/models/add_formula_item_entry.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/add_formula_items_request.dart';

void main() {
  group('AddFormulaItemsRequest', () {
    test('can be created with required fields', () {
      final result = AddFormulaItemsRequest(
        items: [
          const AddFormulaItemEntry(
            inventoryId: 'inv-001',
            quantity: 5,
            sortOrder: 1,
          ),
        ],
      );
      expect(result.items, hasLength(1));
      expect(result.items.first.inventoryId, 'inv-001');
    });

    test('serializes to JSON correctly', () {
      final result = AddFormulaItemsRequest(
        items: [const AddFormulaItemEntry(inventoryId: 'inv-001')],
      );
      final json = result.toJson();
      expect(json['items'], hasLength(1));
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'items': [
          {'inventoryId': 'inv-001', 'quantity': 5, 'sortOrder': 1},
        ],
      };
      final result = AddFormulaItemsRequest.fromJson(json);
      expect(result.items, hasLength(1));
      expect(result.items.first.inventoryId, 'inv-001');
    });

    test('equality works correctly', () {
      final a = AddFormulaItemsRequest(
        items: [const AddFormulaItemEntry(inventoryId: 'inv-001')],
      );
      final b = AddFormulaItemsRequest(
        items: [const AddFormulaItemEntry(inventoryId: 'inv-001')],
      );
      final c = AddFormulaItemsRequest(
        items: [const AddFormulaItemEntry(inventoryId: 'inv-002')],
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = AddFormulaItemsRequest(
        items: [
          const AddFormulaItemEntry(
            inventoryId: 'inv-001',
            quantity: 5,
            sortOrder: 1,
          ),
        ],
      );
      final json = original.toJson();
      json['items'] = (json['items'] as List)
          .map((item) => (item as AddFormulaItemEntry).toJson())
          .toList();
      final roundTripped = AddFormulaItemsRequest.fromJson(json);
      expect(roundTripped, equals(original));
    });
  });
}
