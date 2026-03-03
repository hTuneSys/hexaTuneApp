// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/network/models/paginated_response.dart';

void main() {
  group('PaginatedResponse', () {
    test('fromJson with String type', () {
      final json = {
        'data': ['a', 'b', 'c'],
        'pagination': {
          'has_more': true,
          'limit': 10,
          'next_cursor': 'abc',
        },
      };
      final result = PaginatedResponse.fromJson(
        json,
        (item) => item as String,
      );
      expect(result.data, ['a', 'b', 'c']);
      expect(result.pagination.hasMore, true);
      expect(result.pagination.limit, 10);
      expect(result.pagination.nextCursor, 'abc');
    });

    test('fromJson with Map type', () {
      final json = {
        'data': [
          {'id': '1', 'name': 'first'},
          {'id': '2', 'name': 'second'},
        ],
        'pagination': {
          'has_more': false,
          'limit': 20,
          'next_cursor': null,
        },
      };
      final result = PaginatedResponse<Map<String, dynamic>>.fromJson(
        json,
        (item) => item as Map<String, dynamic>,
      );
      expect(result.data.length, 2);
      expect(result.data[0]['id'], '1');
      expect(result.data[1]['name'], 'second');
      expect(result.pagination.hasMore, false);
      expect(result.pagination.nextCursor, isNull);
    });

    test('hasMore getter delegates to pagination', () {
      final json = {
        'data': <String>[],
        'pagination': {
          'has_more': true,
          'limit': 5,
          'next_cursor': 'cur',
        },
      };
      final result = PaginatedResponse.fromJson(
        json,
        (item) => item as String,
      );
      expect(result.hasMore, true);
    });

    test('nextCursor getter delegates to pagination', () {
      final json = {
        'data': <String>[],
        'pagination': {
          'has_more': false,
          'limit': 5,
          'next_cursor': 'next-page',
        },
      };
      final result = PaginatedResponse.fromJson(
        json,
        (item) => item as String,
      );
      expect(result.nextCursor, 'next-page');
    });

    test('nextCursor is null when no more pages', () {
      final json = {
        'data': ['x'],
        'pagination': {
          'has_more': false,
          'limit': 10,
        },
      };
      final result = PaginatedResponse.fromJson(
        json,
        (item) => item as String,
      );
      expect(result.nextCursor, isNull);
      expect(result.hasMore, false);
    });
  });
}
