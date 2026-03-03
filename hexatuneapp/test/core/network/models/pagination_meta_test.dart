// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/network/models/pagination_meta.dart';

void main() {
  group('PaginationMeta', () {
    test('fromJson with all fields', () {
      final json = {
        'has_more': true,
        'limit': 25,
        'next_cursor': 'cursor-abc',
      };
      final meta = PaginationMeta.fromJson(json);
      expect(meta.hasMore, true);
      expect(meta.limit, 25);
      expect(meta.nextCursor, 'cursor-abc');
    });

    test('fromJson with next_cursor as null', () {
      final json = {
        'has_more': false,
        'limit': 10,
        'next_cursor': null,
      };
      final meta = PaginationMeta.fromJson(json);
      expect(meta.hasMore, false);
      expect(meta.limit, 10);
      expect(meta.nextCursor, isNull);
    });

    test('toJson produces correct snake_case keys', () {
      const meta = PaginationMeta(
        hasMore: true,
        limit: 50,
        nextCursor: 'next-123',
      );
      final json = meta.toJson();
      expect(json['has_more'], true);
      expect(json['limit'], 50);
      expect(json['next_cursor'], 'next-123');
    });

    test('toJson round-trip preserves values', () {
      const original = PaginationMeta(
        hasMore: false,
        limit: 10,
      );
      final json = original.toJson();
      final restored = PaginationMeta.fromJson(json);
      expect(restored, original);
    });
  });
}
