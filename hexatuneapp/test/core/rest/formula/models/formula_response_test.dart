// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/formula/models/formula_response.dart';

void main() {
  group('FormulaResponse', () {
    test('can be created with required fields', () {
      final result = FormulaResponse(
        id: 'formula-001',
        name: 'Test Formula',
        labels: ['label1'],
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      expect(result.id, 'formula-001');
      expect(result.name, 'Test Formula');
      expect(result.labels, ['label1']);
      expect(result.createdAt, '2026-01-01T00:00:00Z');
      expect(result.updatedAt, '2026-01-01T00:00:00Z');
    });

    test('serializes to JSON correctly', () {
      final result = FormulaResponse(
        id: 'formula-001',
        name: 'Test Formula',
        labels: ['label1'],
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final json = result.toJson();
      expect(json['id'], 'formula-001');
      expect(json['name'], 'Test Formula');
      expect(json['labels'], ['label1']);
      expect(json['createdAt'], '2026-01-01T00:00:00Z');
      expect(json['updatedAt'], '2026-01-01T00:00:00Z');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'id': 'formula-001',
        'name': 'Test Formula',
        'labels': ['label1'],
        'createdAt': '2026-01-01T00:00:00Z',
        'updatedAt': '2026-01-01T00:00:00Z',
      };
      final result = FormulaResponse.fromJson(json);
      expect(result.id, 'formula-001');
      expect(result.name, 'Test Formula');
      expect(result.labels, ['label1']);
      expect(result.createdAt, '2026-01-01T00:00:00Z');
      expect(result.updatedAt, '2026-01-01T00:00:00Z');
    });

    test('equality works correctly', () {
      final a = FormulaResponse(
        id: 'formula-001',
        name: 'Test Formula',
        labels: ['label1'],
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final b = FormulaResponse(
        id: 'formula-001',
        name: 'Test Formula',
        labels: ['label1'],
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final c = FormulaResponse(
        id: 'different',
        name: 'Test Formula',
        labels: ['label1'],
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = FormulaResponse(
        id: 'formula-001',
        name: 'Test Formula',
        labels: ['label1'],
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final roundTripped = FormulaResponse.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
