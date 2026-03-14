// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/category/models/create_category_request.dart';

void main() {
  group('CreateCategoryRequest', () {
    test('can be created with required fields', () {
      final result = const CreateCategoryRequest(name: 'New Category');
      expect(result.name, 'New Category');
    });

    test('serializes to JSON correctly', () {
      final result = const CreateCategoryRequest(name: 'New Category');
      final json = result.toJson();
      expect(json['name'], 'New Category');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{'name': 'New Category'};
      final result = CreateCategoryRequest.fromJson(json);
      expect(result.name, 'New Category');
    });

    test('equality works correctly', () {
      final a = const CreateCategoryRequest(name: 'New Category');
      final b = const CreateCategoryRequest(name: 'New Category');
      final c = const CreateCategoryRequest(name: 'different');
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const CreateCategoryRequest(name: 'New Category');
      final roundTripped = CreateCategoryRequest.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
