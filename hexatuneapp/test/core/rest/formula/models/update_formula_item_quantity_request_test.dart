// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/formula/models/update_formula_item_quantity_request.dart';

void main() {
  group('UpdateFormulaItemQuantityRequest', () {
    test('can be created with required fields', () {
      final result = const UpdateFormulaItemQuantityRequest(quantity: 42);
      expect(result.quantity, 42);
    });

    test('serializes to JSON correctly', () {
      final result = const UpdateFormulaItemQuantityRequest(quantity: 42);
      final json = result.toJson();
      expect(json['quantity'], 42);
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{'quantity': 42};
      final result = UpdateFormulaItemQuantityRequest.fromJson(json);
      expect(result.quantity, 42);
    });

    test('equality works correctly', () {
      final a = const UpdateFormulaItemQuantityRequest(quantity: 42);
      final b = const UpdateFormulaItemQuantityRequest(quantity: 42);
      final c = const UpdateFormulaItemQuantityRequest(quantity: 999);
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const UpdateFormulaItemQuantityRequest(quantity: 42);
      final roundTripped = UpdateFormulaItemQuantityRequest.fromJson(
        original.toJson(),
      );
      expect(roundTripped, equals(original));
    });
  });
}
