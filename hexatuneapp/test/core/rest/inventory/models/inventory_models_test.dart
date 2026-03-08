// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/inventory/models/inventory_response.dart';
import 'package:hexatuneapp/src/core/rest/inventory/models/image_url_response.dart';

void main() {
  group('InventoryResponse', () {
    test('fromJson with all fields including optional description', () {
      final json = {
        'id': 'inv-001',
        'categoryId': 'cat-001',
        'name': 'Red Dye',
        'labels': ['dye', 'red'],
        'imageUploaded': true,
        'createdAt': '2025-01-01T00:00:00Z',
        'updatedAt': '2025-06-01T00:00:00Z',
        'description': 'A red dye item.',
      };
      final response = InventoryResponse.fromJson(json);
      expect(response.id, 'inv-001');
      expect(response.categoryId, 'cat-001');
      expect(response.name, 'Red Dye');
      expect(response.labels, ['dye', 'red']);
      expect(response.imageUploaded, true);
      expect(response.createdAt, '2025-01-01T00:00:00Z');
      expect(response.updatedAt, '2025-06-01T00:00:00Z');
      expect(response.description, 'A red dye item.');
    });

    test('fromJson without optional description', () {
      final json = {
        'id': 'inv-002',
        'categoryId': 'cat-002',
        'name': 'Blue Dye',
        'labels': <String>[],
        'imageUploaded': false,
        'createdAt': '2025-01-01T00:00:00Z',
        'updatedAt': '2025-06-01T00:00:00Z',
      };
      final response = InventoryResponse.fromJson(json);
      expect(response.description, isNull);
      expect(response.imageUploaded, false);
    });

    test('toJson produces correct keys', () {
      const response = InventoryResponse(
        id: 'inv-001',
        categoryId: 'cat-001',
        name: 'Item',
        labels: ['tag'],
        imageUploaded: true,
        createdAt: '2025-01-01T00:00:00Z',
        updatedAt: '2025-06-01T00:00:00Z',
        description: 'Desc',
      );
      final json = response.toJson();
      expect(json['id'], 'inv-001');
      expect(json['categoryId'], 'cat-001');
      expect(json['name'], 'Item');
      expect(json['labels'], ['tag']);
      expect(json['imageUploaded'], true);
      expect(json['description'], 'Desc');
    });

    test('round-trip preserves values', () {
      const original = InventoryResponse(
        id: 'i',
        categoryId: 'c',
        name: 'n',
        labels: ['l'],
        imageUploaded: false,
        createdAt: 'ca',
        updatedAt: 'ua',
      );
      final restored = InventoryResponse.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('ImageUrlResponse', () {
    test('fromJson creates instance', () {
      final json = {'url': 'https://cdn.example.com/img.png'};
      final response = ImageUrlResponse.fromJson(json);
      expect(response.url, 'https://cdn.example.com/img.png');
    });

    test('toJson produces correct keys', () {
      const response = ImageUrlResponse(url: 'https://cdn.example.com/img.png');
      final json = response.toJson();
      expect(json['url'], 'https://cdn.example.com/img.png');
    });

    test('round-trip preserves values', () {
      const original = ImageUrlResponse(url: 'https://u.rl');
      final restored = ImageUrlResponse.fromJson(original.toJson());
      expect(restored, original);
    });
  });
}
