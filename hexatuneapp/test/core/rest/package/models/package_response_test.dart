// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/package/models/package_response.dart';

void main() {
  group('PackageResponse', () {
    test('can be created with required fields', () {
      final result = PackageResponse(
        id: 'pkg-001',
        name: 'Relaxation Suite',
        description: 'A package of relaxation flows',
        labels: ['wellness'],
        imageUploaded: true,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      expect(result.id, 'pkg-001');
      expect(result.name, 'Relaxation Suite');
      expect(result.description, 'A package of relaxation flows');
      expect(result.labels, ['wellness']);
      expect(result.imageUploaded, true);
      expect(result.createdAt, '2026-01-01T00:00:00Z');
      expect(result.updatedAt, '2026-01-01T00:00:00Z');
    });

    test('serializes to JSON correctly', () {
      final result = PackageResponse(
        id: 'pkg-001',
        name: 'Relaxation Suite',
        description: 'A package of relaxation flows',
        labels: ['wellness'],
        imageUploaded: true,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final json = result.toJson();
      expect(json['id'], 'pkg-001');
      expect(json['name'], 'Relaxation Suite');
      expect(json['description'], 'A package of relaxation flows');
      expect(json['labels'], ['wellness']);
      expect(json['imageUploaded'], true);
      expect(json['createdAt'], '2026-01-01T00:00:00Z');
      expect(json['updatedAt'], '2026-01-01T00:00:00Z');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'id': 'pkg-001',
        'name': 'Relaxation Suite',
        'description': 'A package of relaxation flows',
        'labels': ['wellness'],
        'imageUploaded': true,
        'createdAt': '2026-01-01T00:00:00Z',
        'updatedAt': '2026-01-01T00:00:00Z',
      };
      final result = PackageResponse.fromJson(json);
      expect(result.id, 'pkg-001');
      expect(result.name, 'Relaxation Suite');
      expect(result.description, 'A package of relaxation flows');
      expect(result.labels, ['wellness']);
      expect(result.imageUploaded, true);
      expect(result.createdAt, '2026-01-01T00:00:00Z');
      expect(result.updatedAt, '2026-01-01T00:00:00Z');
    });

    test('equality works correctly', () {
      final a = PackageResponse(
        id: 'pkg-001',
        name: 'Relaxation Suite',
        description: 'A package of relaxation flows',
        labels: ['wellness'],
        imageUploaded: true,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final b = PackageResponse(
        id: 'pkg-001',
        name: 'Relaxation Suite',
        description: 'A package of relaxation flows',
        labels: ['wellness'],
        imageUploaded: true,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final c = PackageResponse(
        id: 'different',
        name: 'Relaxation Suite',
        description: 'A package of relaxation flows',
        labels: ['wellness'],
        imageUploaded: true,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = PackageResponse(
        id: 'pkg-001',
        name: 'Relaxation Suite',
        description: 'A package of relaxation flows',
        labels: ['wellness'],
        imageUploaded: true,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final roundTripped = PackageResponse.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
