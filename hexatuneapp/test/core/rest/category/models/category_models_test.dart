// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/category/models/category_response.dart';
import 'package:hexatuneapp/src/core/rest/category/models/create_category_request.dart';
import 'package:hexatuneapp/src/core/rest/category/models/update_category_request.dart';

void main() {
  group('CategoryResponse', () {
    test('fromJson creates instance', () {
      final json = {
        'id': 'cat-001',
        'name': 'Colors',
        'labels': ['red', 'blue'],
        'createdAt': '2025-01-01T00:00:00Z',
        'updatedAt': '2025-06-01T00:00:00Z',
      };
      final response = CategoryResponse.fromJson(json);
      expect(response.id, 'cat-001');
      expect(response.name, 'Colors');
      expect(response.labels, ['red', 'blue']);
      expect(response.createdAt, '2025-01-01T00:00:00Z');
      expect(response.updatedAt, '2025-06-01T00:00:00Z');
    });

    test('fromJson with empty labels', () {
      final json = {
        'id': 'cat-002',
        'name': 'Empty',
        'labels': <String>[],
        'createdAt': '2025-01-01T00:00:00Z',
        'updatedAt': '2025-06-01T00:00:00Z',
      };
      final response = CategoryResponse.fromJson(json);
      expect(response.labels, isEmpty);
    });

    test('toJson produces correct keys', () {
      const response = CategoryResponse(
        id: 'cat-001',
        name: 'Colors',
        labels: ['red'],
        createdAt: '2025-01-01T00:00:00Z',
        updatedAt: '2025-06-01T00:00:00Z',
      );
      final json = response.toJson();
      expect(json['id'], 'cat-001');
      expect(json['name'], 'Colors');
      expect(json['labels'], ['red']);
      expect(json['createdAt'], '2025-01-01T00:00:00Z');
      expect(json['updatedAt'], '2025-06-01T00:00:00Z');
    });

    test('round-trip preserves values', () {
      const original = CategoryResponse(
        id: 'c',
        name: 'n',
        labels: ['l'],
        createdAt: 'ca',
        updatedAt: 'ua',
      );
      final restored = CategoryResponse.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('CreateCategoryRequest', () {
    test('fromJson with labels', () {
      final json = {
        'name': 'New Category',
        'labels': ['tag1', 'tag2'],
      };
      final request = CreateCategoryRequest.fromJson(json);
      expect(request.name, 'New Category');
      expect(request.labels, ['tag1', 'tag2']);
    });

    test('fromJson without optional labels', () {
      final json = {'name': 'Simple Category'};
      final request = CreateCategoryRequest.fromJson(json);
      expect(request.name, 'Simple Category');
      expect(request.labels, isNull);
    });

    test('toJson produces correct keys', () {
      const request = CreateCategoryRequest(name: 'Cat', labels: ['a']);
      final json = request.toJson();
      expect(json['name'], 'Cat');
      expect(json['labels'], ['a']);
    });

    test('round-trip preserves values', () {
      const original = CreateCategoryRequest(name: 'n');
      final restored = CreateCategoryRequest.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('UpdateCategoryRequest', () {
    test('fromJson with all fields', () {
      final json = {
        'name': 'Updated Name',
        'labels': ['new-label'],
      };
      final request = UpdateCategoryRequest.fromJson(json);
      expect(request.name, 'Updated Name');
      expect(request.labels, ['new-label']);
    });

    test('fromJson with no fields (all optional)', () {
      final json = <String, dynamic>{};
      final request = UpdateCategoryRequest.fromJson(json);
      expect(request.name, isNull);
      expect(request.labels, isNull);
    });

    test('toJson produces correct keys', () {
      const request = UpdateCategoryRequest(name: 'Up');
      final json = request.toJson();
      expect(json['name'], 'Up');
    });

    test('round-trip preserves values', () {
      const original = UpdateCategoryRequest(name: 'n', labels: ['l']);
      final restored = UpdateCategoryRequest.fromJson(original.toJson());
      expect(restored, original);
    });
  });
}
