// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/formula/models/update_formula_request.dart';

void main() {
  group('UpdateFormulaRequest', () {
    test('can be created with optional fields', () {
      const result = UpdateFormulaRequest(
        name: 'Updated Formula',
        labels: ['updated'],
      );
      expect(result.name, 'Updated Formula');
      expect(result.labels, ['updated']);
    });

    test('can be created with no fields', () {
      const result = UpdateFormulaRequest();
      expect(result.name, isNull);
      expect(result.labels, isNull);
    });

    test('serializes to JSON correctly', () {
      const result = UpdateFormulaRequest(name: 'Test');
      final json = result.toJson();
      expect(json['name'], 'Test');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'name': 'New Name',
        'labels': ['label1'],
      };
      final result = UpdateFormulaRequest.fromJson(json);
      expect(result.name, 'New Name');
      expect(result.labels, ['label1']);
    });

    test('equality works correctly', () {
      const a = UpdateFormulaRequest(name: 'Same');
      const b = UpdateFormulaRequest(name: 'Same');
      const c = UpdateFormulaRequest(name: 'Different');
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      const original = UpdateFormulaRequest(name: 'RT', labels: ['x']);
      final roundTripped = UpdateFormulaRequest.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
