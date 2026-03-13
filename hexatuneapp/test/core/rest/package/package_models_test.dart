// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/package/models/package_response.dart';

void main() {
  group('PackageResponse', () {
    test('fromJson creates instance with all fields', () {
      final json = {
        'id': 'pkg-001',
        'name': 'Relaxation Suite',
        'description': 'A package of relaxation flows',
        'labels': ['wellness', 'sleep'],
        'imageUploaded': true,
        'createdAt': '2026-01-01T00:00:00Z',
        'updatedAt': '2026-01-02T00:00:00Z',
      };
      final response = PackageResponse.fromJson(json);
      expect(response.id, 'pkg-001');
      expect(response.name, 'Relaxation Suite');
      expect(response.description, 'A package of relaxation flows');
      expect(response.labels, ['wellness', 'sleep']);
      expect(response.imageUploaded, true);
    });

    test('toJson produces correct keys', () {
      const response = PackageResponse(
        id: 'pkg-001',
        name: 'Relaxation Suite',
        description: 'A package of relaxation flows',
        labels: ['wellness'],
        imageUploaded: false,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-02T00:00:00Z',
      );
      final json = response.toJson();
      expect(json['id'], 'pkg-001');
      expect(json['name'], 'Relaxation Suite');
      expect(json['imageUploaded'], false);
    });
  });
}
