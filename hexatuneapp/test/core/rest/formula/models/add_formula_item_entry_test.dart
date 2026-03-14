// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/formula/models/add_formula_item_entry.dart';

void main() {
  group('AddFormulaItemEntry', () {
    test('can be created with required fields', () {
      final result = const AddFormulaItemEntry(inventoryId: 'inv-001');
      expect(result.inventoryId, 'inv-001');
      expect(result.timeMs, isNull);
    });

    test('can be created with optional timeMs', () {
      final result = const AddFormulaItemEntry(
        inventoryId: 'inv-001',
        timeMs: 5000,
      );
      expect(result.inventoryId, 'inv-001');
      expect(result.timeMs, 5000);
    });

    test('serializes to JSON correctly', () {
      final result = const AddFormulaItemEntry(
        inventoryId: 'inv-001',
        timeMs: 3000,
      );
      final json = result.toJson();
      expect(json['inventoryId'], 'inv-001');
      expect(json['timeMs'], 3000);
    });

    test('serializes to JSON without timeMs when null', () {
      final result = const AddFormulaItemEntry(inventoryId: 'inv-001');
      final json = result.toJson();
      expect(json['inventoryId'], 'inv-001');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{'inventoryId': 'inv-001', 'timeMs': 10000};
      final result = AddFormulaItemEntry.fromJson(json);
      expect(result.inventoryId, 'inv-001');
      expect(result.timeMs, 10000);
    });

    test('equality works correctly', () {
      final a = const AddFormulaItemEntry(inventoryId: 'inv-001');
      final b = const AddFormulaItemEntry(inventoryId: 'inv-001');
      final c = const AddFormulaItemEntry(inventoryId: 'different');
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const AddFormulaItemEntry(inventoryId: 'inv-001');
      final roundTripped = AddFormulaItemEntry.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
