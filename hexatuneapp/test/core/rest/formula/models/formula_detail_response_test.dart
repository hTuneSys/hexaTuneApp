// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/formula/models/formula_detail_response.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/formula_item_response.dart';

void main() {
  group('FormulaDetailResponse', () {
    test('can be created with required fields', () {
      final result = FormulaDetailResponse(
        id: 'formula-001',
        name: 'Detail Formula',
        labels: ['label1'],
        items: [
          const FormulaItemResponse(
            id: 'item-001',
            inventoryId: 'inv-001',
            sortOrder: 1,
            quantity: 10,
            timeMs: 1000,
            createdAt: '2026-01-01T00:00:00Z',
          ),
        ],
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      expect(result.id, 'formula-001');
      expect(result.items, hasLength(1));
      expect(result.items.first.inventoryId, 'inv-001');
    });

    test('serializes to JSON correctly', () {
      final result = FormulaDetailResponse(
        id: 'formula-001',
        name: 'Test',
        labels: ['a'],
        items: [
          const FormulaItemResponse(
            id: 'item-001',
            inventoryId: 'inv-001',
            sortOrder: 1,
            quantity: 10,
            timeMs: 1000,
            createdAt: '2026-01-01T00:00:00Z',
          ),
        ],
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final json = result.toJson();
      expect(json['id'], 'formula-001');
      expect(json['items'], hasLength(1));
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'id': 'formula-001',
        'name': 'Detail Formula',
        'labels': ['label1'],
        'items': [
          {
            'id': 'item-001',
            'inventoryId': 'inv-001',
            'sortOrder': 1,
            'quantity': 10,
            'timeMs': 1000,
            'createdAt': '2026-01-01T00:00:00Z',
          },
        ],
        'createdAt': '2026-01-01T00:00:00Z',
        'updatedAt': '2026-01-01T00:00:00Z',
      };
      final result = FormulaDetailResponse.fromJson(json);
      expect(result.id, 'formula-001');
      expect(result.items, hasLength(1));
      expect(result.items.first.quantity, 10);
    });

    test('equality works correctly', () {
      final a = FormulaDetailResponse(
        id: 'f-1',
        name: 'A',
        labels: [],
        items: [],
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final b = FormulaDetailResponse(
        id: 'f-1',
        name: 'A',
        labels: [],
        items: [],
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final c = FormulaDetailResponse(
        id: 'f-2',
        name: 'B',
        labels: [],
        items: [],
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = FormulaDetailResponse(
        id: 'formula-rt',
        name: 'RT',
        labels: ['l1'],
        items: [
          const FormulaItemResponse(
            id: 'item-rt',
            inventoryId: 'inv-rt',
            sortOrder: 1,
            quantity: 5,
            timeMs: 2000,
            createdAt: '2026-01-01T00:00:00Z',
          ),
        ],
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final json = original.toJson();
      json['items'] = (json['items'] as List)
          .map((item) => (item as FormulaItemResponse).toJson())
          .toList();
      final roundTripped = FormulaDetailResponse.fromJson(json);
      expect(roundTripped, equals(original));
    });
  });
}
