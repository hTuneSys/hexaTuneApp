// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/inventory/models/image_url_response.dart';
import 'package:hexatuneapp/src/core/rest/inventory/models/inventory_response.dart';

void main() {
  group('InventoryResponse', () {
    test('fromJson creates instance with all fields', () {
      final json = {
        'id': 'inv-001',
        'categoryId': 'cat-001',
        'name': 'Red Paint',
        'labels': ['oil', 'red'],
        'imageUploaded': true,
        'createdAt': '2025-01-01T00:00:00Z',
        'updatedAt': '2025-01-02T00:00:00Z',
        'description': 'A red oil paint',
      };
      final response = InventoryResponse.fromJson(json);
      expect(response.id, 'inv-001');
      expect(response.categoryId, 'cat-001');
      expect(response.name, 'Red Paint');
      expect(response.labels, ['oil', 'red']);
      expect(response.imageUploaded, true);
      expect(response.description, 'A red oil paint');
    });

    test('toJson produces correct keys', () {
      const response = InventoryResponse(
        id: 'inv-001',
        categoryId: 'cat-001',
        name: 'Red Paint',
        labels: ['oil'],
        imageUploaded: false,
        createdAt: '2025-01-01T00:00:00Z',
        updatedAt: '2025-01-02T00:00:00Z',
      );
      final json = response.toJson();
      expect(json['id'], 'inv-001');
      expect(json['categoryId'], 'cat-001');
      expect(json['imageUploaded'], false);
    });

    test('description is optional', () {
      final json = {
        'id': 'inv-001',
        'categoryId': 'cat-001',
        'name': 'Paint',
        'labels': <String>[],
        'imageUploaded': false,
        'createdAt': '2025-01-01T00:00:00Z',
        'updatedAt': '2025-01-02T00:00:00Z',
      };
      final response = InventoryResponse.fromJson(json);
      expect(response.description, isNull);
    });
  });

  group('ImageUrlResponse', () {
    test('fromJson creates instance', () {
      final json = {'url': 'https://cdn.example.com/image.png'};
      final response = ImageUrlResponse.fromJson(json);
      expect(response.url, 'https://cdn.example.com/image.png');
    });

    test('toJson produces correct keys', () {
      const response = ImageUrlResponse(url: 'https://cdn.example.com/img.png');
      final json = response.toJson();
      expect(json['url'], 'https://cdn.example.com/img.png');
    });
  });
}
