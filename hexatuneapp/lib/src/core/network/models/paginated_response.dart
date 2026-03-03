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
  const PaginatedResponse({
    required this.data,
    required this.pagination,
  });

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
    return PaginatedResponse(
      data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
      pagination: PaginationMeta.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
    );
  }

  /// Whether there are more pages available.
  bool get hasMore => pagination.hasMore;

  /// The cursor to use for fetching the next page, or null.
  String? get nextCursor => pagination.nextCursor;
}
