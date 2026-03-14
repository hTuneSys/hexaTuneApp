// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/formula/models/reorder_entry.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/reorder_formula_items_request.dart';

void main() {
  group('ReorderFormulaItemsRequest', () {
    test('can be created with required fields', () {
      final result = ReorderFormulaItemsRequest(
        items: [const ReorderEntry(itemId: 'item-001', sortOrder: 1)],
      );
      expect(result.items, hasLength(1));
      expect(result.items.first.itemId, 'item-001');
    });

    test('serializes to JSON correctly', () {
      final result = ReorderFormulaItemsRequest(
        items: [const ReorderEntry(itemId: 'item-001', sortOrder: 1)],
      );
      final json = result.toJson();
      expect(json['items'], hasLength(1));
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'items': [
          {'itemId': 'item-001', 'sortOrder': 1},
        ],
      };
      final result = ReorderFormulaItemsRequest.fromJson(json);
      expect(result.items, hasLength(1));
      expect(result.items.first.sortOrder, 1);
    });

    test('equality works correctly', () {
      final a = ReorderFormulaItemsRequest(
        items: [const ReorderEntry(itemId: 'item-001', sortOrder: 1)],
      );
      final b = ReorderFormulaItemsRequest(
        items: [const ReorderEntry(itemId: 'item-001', sortOrder: 1)],
      );
      final c = ReorderFormulaItemsRequest(
        items: [const ReorderEntry(itemId: 'item-002', sortOrder: 2)],
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = ReorderFormulaItemsRequest(
        items: [const ReorderEntry(itemId: 'item-rt', sortOrder: 5)],
      );
      final json = original.toJson();
      json['items'] = (json['items'] as List)
          .map((item) => (item as ReorderEntry).toJson())
          .toList();
      final roundTripped = ReorderFormulaItemsRequest.fromJson(json);
      expect(roundTripped, equals(original));
    });
  });
}
