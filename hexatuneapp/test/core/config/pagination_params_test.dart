// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/network/pagination_params.dart';

void main() {
  group('PaginationParams (additional tests)', () {
    test('toQueryParameters with all fields', () {
      const params = PaginationParams(
        cursor: 'abc123',
        limit: 20,
        sort: 'created_at:desc',
        query: 'search term',
      );
      final map = params.toQueryParameters();
      expect(map['cursor'], 'abc123');
      expect(map['limit'], 20);
      expect(map['sort'], 'created_at:desc');
      expect(map['q'], 'search term');
    });

    test('toQueryParameters omits null fields', () {
      const params = PaginationParams(limit: 10);
      final map = params.toQueryParameters();
      expect(map, {'limit': 10});
      expect(map.containsKey('cursor'), false);
      expect(map.containsKey('sort'), false);
      expect(map.containsKey('q'), false);
    });

    test('toQueryParameters returns empty map when all null', () {
      const params = PaginationParams();
      final map = params.toQueryParameters();
      expect(map, isEmpty);
    });
  });
}
