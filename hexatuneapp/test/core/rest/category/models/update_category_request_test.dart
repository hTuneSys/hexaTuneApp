// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/category/models/update_category_request.dart';

void main() {
  group('UpdateCategoryRequest', () {
    test('can be created with optional fields', () {
      const result = UpdateCategoryRequest(
        name: 'Updated Name',
        labels: ['updated'],
      );
      expect(result.name, 'Updated Name');
      expect(result.labels, ['updated']);
    });

    test('can be created with no fields', () {
      const result = UpdateCategoryRequest();
      expect(result.name, isNull);
      expect(result.labels, isNull);
    });

    test('serializes to JSON correctly', () {
      const result = UpdateCategoryRequest(name: 'Test');
      final json = result.toJson();
      expect(json['name'], 'Test');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'name': 'Test',
        'labels': ['a', 'b'],
      };
      final result = UpdateCategoryRequest.fromJson(json);
      expect(result.name, 'Test');
      expect(result.labels, ['a', 'b']);
    });

    test('equality works correctly', () {
      const a = UpdateCategoryRequest(name: 'Same');
      const b = UpdateCategoryRequest(name: 'Same');
      const c = UpdateCategoryRequest(name: 'Different');
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      const original = UpdateCategoryRequest(name: 'RT', labels: ['x']);
      final roundTripped = UpdateCategoryRequest.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
