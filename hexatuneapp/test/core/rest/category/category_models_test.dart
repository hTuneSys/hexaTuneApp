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
        'name': 'Paints',
        'labels': ['oil', 'acrylic'],
        'createdAt': '2025-01-01T00:00:00Z',
        'updatedAt': '2025-01-02T00:00:00Z',
      };
      final response = CategoryResponse.fromJson(json);
      expect(response.id, 'cat-001');
      expect(response.name, 'Paints');
      expect(response.labels, ['oil', 'acrylic']);
    });

    test('toJson produces correct keys', () {
      const response = CategoryResponse(
        id: 'cat-001',
        name: 'Paints',
        labels: ['oil'],
        createdAt: '2025-01-01T00:00:00Z',
        updatedAt: '2025-01-02T00:00:00Z',
      );
      final json = response.toJson();
      expect(json['id'], 'cat-001');
      expect(json['name'], 'Paints');
      expect(json['labels'], ['oil']);
    });
  });

  group('CreateCategoryRequest', () {
    test('fromJson creates instance', () {
      final json = {
        'name': 'Paints',
        'labels': ['oil'],
      };
      final request = CreateCategoryRequest.fromJson(json);
      expect(request.name, 'Paints');
      expect(request.labels, ['oil']);
    });

    test('toJson produces correct keys', () {
      const request = CreateCategoryRequest(name: 'Paints');
      final json = request.toJson();
      expect(json['name'], 'Paints');
    });

    test('labels is optional', () {
      const request = CreateCategoryRequest(name: 'Paints');
      expect(request.labels, isNull);
    });
  });

  group('UpdateCategoryRequest', () {
    test('fromJson creates instance', () {
      final json = {
        'name': 'Updated',
        'labels': ['new'],
      };
      final request = UpdateCategoryRequest.fromJson(json);
      expect(request.name, 'Updated');
      expect(request.labels, ['new']);
    });

    test('all fields are optional', () {
      const request = UpdateCategoryRequest();
      expect(request.name, isNull);
      expect(request.labels, isNull);
    });
  });
}
