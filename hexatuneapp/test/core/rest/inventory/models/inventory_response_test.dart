// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/inventory/models/inventory_response.dart';

void main() {
  group('InventoryResponse', () {
    test('can be created with required fields', () {
      final result = InventoryResponse(
        id: 'inv-001',
        categoryId: 'cat-001',
        name: 'Lavender',
        labels: ['organic'],
        imageUploaded: true,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      expect(result.id, 'inv-001');
      expect(result.categoryId, 'cat-001');
      expect(result.name, 'Lavender');
      expect(result.labels, ['organic']);
      expect(result.imageUploaded, true);
      expect(result.createdAt, '2026-01-01T00:00:00Z');
      expect(result.updatedAt, '2026-01-01T00:00:00Z');
    });

    test('serializes to JSON correctly', () {
      final result = InventoryResponse(
        id: 'inv-001',
        categoryId: 'cat-001',
        name: 'Lavender',
        labels: ['organic'],
        imageUploaded: true,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final json = result.toJson();
      expect(json['id'], 'inv-001');
      expect(json['categoryId'], 'cat-001');
      expect(json['name'], 'Lavender');
      expect(json['labels'], ['organic']);
      expect(json['imageUploaded'], true);
      expect(json['createdAt'], '2026-01-01T00:00:00Z');
      expect(json['updatedAt'], '2026-01-01T00:00:00Z');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'id': 'inv-001',
        'categoryId': 'cat-001',
        'name': 'Lavender',
        'labels': ['organic'],
        'imageUploaded': true,
        'createdAt': '2026-01-01T00:00:00Z',
        'updatedAt': '2026-01-01T00:00:00Z',
      };
      final result = InventoryResponse.fromJson(json);
      expect(result.id, 'inv-001');
      expect(result.categoryId, 'cat-001');
      expect(result.name, 'Lavender');
      expect(result.labels, ['organic']);
      expect(result.imageUploaded, true);
      expect(result.createdAt, '2026-01-01T00:00:00Z');
      expect(result.updatedAt, '2026-01-01T00:00:00Z');
    });

    test('equality works correctly', () {
      final a = InventoryResponse(
        id: 'inv-001',
        categoryId: 'cat-001',
        name: 'Lavender',
        labels: ['organic'],
        imageUploaded: true,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final b = InventoryResponse(
        id: 'inv-001',
        categoryId: 'cat-001',
        name: 'Lavender',
        labels: ['organic'],
        imageUploaded: true,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final c = InventoryResponse(
        id: 'different',
        categoryId: 'cat-001',
        name: 'Lavender',
        labels: ['organic'],
        imageUploaded: true,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = InventoryResponse(
        id: 'inv-001',
        categoryId: 'cat-001',
        name: 'Lavender',
        labels: ['organic'],
        imageUploaded: true,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final roundTripped = InventoryResponse.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
