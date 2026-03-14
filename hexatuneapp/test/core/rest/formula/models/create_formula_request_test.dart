// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/formula/models/create_formula_request.dart';

void main() {
  group('CreateFormulaRequest', () {
    test('can be created with required fields', () {
      final result = const CreateFormulaRequest(name: 'My Formula');
      expect(result.name, 'My Formula');
    });

    test('serializes to JSON correctly', () {
      final result = const CreateFormulaRequest(name: 'My Formula');
      final json = result.toJson();
      expect(json['name'], 'My Formula');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{'name': 'My Formula'};
      final result = CreateFormulaRequest.fromJson(json);
      expect(result.name, 'My Formula');
    });

    test('equality works correctly', () {
      final a = const CreateFormulaRequest(name: 'My Formula');
      final b = const CreateFormulaRequest(name: 'My Formula');
      final c = const CreateFormulaRequest(name: 'different');
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const CreateFormulaRequest(name: 'My Formula');
      final roundTripped = CreateFormulaRequest.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
