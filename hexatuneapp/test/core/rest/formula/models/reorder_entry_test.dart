// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/formula/models/reorder_entry.dart';

void main() {
  group('ReorderEntry', () {
    test('can be created with required fields', () {
      final result = const ReorderEntry(itemId: 'item-001', sortOrder: 1);
      expect(result.itemId, 'item-001');
      expect(result.sortOrder, 1);
    });

    test('serializes to JSON correctly', () {
      final result = const ReorderEntry(itemId: 'item-001', sortOrder: 1);
      final json = result.toJson();
      expect(json['itemId'], 'item-001');
      expect(json['sortOrder'], 1);
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{'itemId': 'item-001', 'sortOrder': 1};
      final result = ReorderEntry.fromJson(json);
      expect(result.itemId, 'item-001');
      expect(result.sortOrder, 1);
    });

    test('equality works correctly', () {
      final a = const ReorderEntry(itemId: 'item-001', sortOrder: 1);
      final b = const ReorderEntry(itemId: 'item-001', sortOrder: 1);
      final c = const ReorderEntry(itemId: 'different', sortOrder: 1);
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const ReorderEntry(itemId: 'item-001', sortOrder: 1);
      final roundTripped = ReorderEntry.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
