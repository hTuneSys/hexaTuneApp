// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:hexatuneapp/src/core/network/models/pagination_meta.dart';

/// Generic paginated response wrapper for cursor-based pagination.
///
/// Usage:
/// ```dart
/// final result = PaginatedResponse.fromJson(
///   json,
///   (item) => CategoryResponse.fromJson(item as Map<String, dynamic>),
/// );
/// ```
class PaginatedResponse<T> {
  const PaginatedResponse({required this.data, required this.pagination});

  /// The list of items for the current page.
  final List<T> data;

  /// Pagination metadata (cursor, hasMore, limit).
  final PaginationMeta pagination;

  /// Deserializes a paginated response using [fromJsonT] for each
  /// item in the `data` array.
  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    final rawData = json['data'];
    final rawPagination = json['pagination'];
    if (rawData is! List) {
      throw FormatException(
        'PaginatedResponse: expected "data" to be a List, '
        'got ${rawData.runtimeType}',
      );
    }
    if (rawPagination is! Map<String, dynamic>) {
      throw FormatException(
        'PaginatedResponse: expected "pagination" to be a Map, '
        'got ${rawPagination.runtimeType}',
      );
    }
    return PaginatedResponse(
      data: rawData.map(fromJsonT).toList(),
      pagination: PaginationMeta.fromJson(rawPagination),
    );
  }

  /// Whether there are more pages available.
  bool get hasMore => pagination.hasMore;

  /// The cursor to use for fetching the next page, or null.
  String? get nextCursor => pagination.nextCursor;
}
