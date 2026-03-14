// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/category/models/category_response.dart';

void main() {
  group('CategoryResponse', () {
    test('can be created with required fields', () {
      final result = CategoryResponse(
        id: 'cat-001',
        name: 'Herbs',
        labels: ['organic', 'fresh'],
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      expect(result.id, 'cat-001');
      expect(result.name, 'Herbs');
      expect(result.labels, ['organic', 'fresh']);
      expect(result.createdAt, '2026-01-01T00:00:00Z');
      expect(result.updatedAt, '2026-01-01T00:00:00Z');
    });

    test('serializes to JSON correctly', () {
      final result = CategoryResponse(
        id: 'cat-001',
        name: 'Herbs',
        labels: ['organic', 'fresh'],
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final json = result.toJson();
      expect(json['id'], 'cat-001');
      expect(json['name'], 'Herbs');
      expect(json['labels'], ['organic', 'fresh']);
      expect(json['createdAt'], '2026-01-01T00:00:00Z');
      expect(json['updatedAt'], '2026-01-01T00:00:00Z');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'id': 'cat-001',
        'name': 'Herbs',
        'labels': ['organic', 'fresh'],
        'createdAt': '2026-01-01T00:00:00Z',
        'updatedAt': '2026-01-01T00:00:00Z',
      };
      final result = CategoryResponse.fromJson(json);
      expect(result.id, 'cat-001');
      expect(result.name, 'Herbs');
      expect(result.labels, ['organic', 'fresh']);
      expect(result.createdAt, '2026-01-01T00:00:00Z');
      expect(result.updatedAt, '2026-01-01T00:00:00Z');
    });

    test('equality works correctly', () {
      final a = CategoryResponse(
        id: 'cat-001',
        name: 'Herbs',
        labels: ['organic', 'fresh'],
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final b = CategoryResponse(
        id: 'cat-001',
        name: 'Herbs',
        labels: ['organic', 'fresh'],
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final c = CategoryResponse(
        id: 'different',
        name: 'Herbs',
        labels: ['organic', 'fresh'],
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = CategoryResponse(
        id: 'cat-001',
        name: 'Herbs',
        labels: ['organic', 'fresh'],
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final roundTripped = CategoryResponse.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
