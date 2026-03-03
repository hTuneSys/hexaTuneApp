// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/network/pagination_params.dart';

void main() {
  group('PaginationParams', () {
    test('toQueryParameters with all fields set', () {
      const params = PaginationParams(
        cursor: 'next-cursor-abc',
        limit: 25,
        sort: 'created_at:desc',
        query: 'search term',
      );

      expect(params.toQueryParameters(), {
        'cursor': 'next-cursor-abc',
        'limit': 25,
        'sort': 'created_at:desc',
        'q': 'search term',
      });
    });

    test('toQueryParameters with only cursor set', () {
      const params = PaginationParams(cursor: 'cursor-only');

      expect(params.toQueryParameters(), {
        'cursor': 'cursor-only',
      });
    });

    test('toQueryParameters with no fields returns empty map', () {
      const params = PaginationParams();

      expect(params.toQueryParameters(), isEmpty);
    });

    test('toQueryParameters maps query field to q key', () {
      const params = PaginationParams(query: 'my search');

      final result = params.toQueryParameters();
      expect(result.containsKey('q'), isTrue);
      expect(result.containsKey('query'), isFalse);
      expect(result['q'], 'my search');
    });
  });
}
