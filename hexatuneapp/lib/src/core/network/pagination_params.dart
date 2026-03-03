// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

/// Helper for building cursor-based pagination query parameters.
///
/// Used by all paginated list endpoints.
class PaginationParams {
  const PaginationParams({this.cursor, this.limit, this.sort, this.query});

  /// Cursor for the next page (from [PaginationMeta.nextCursor]).
  final String? cursor;

  /// Maximum number of items per page.
  final int? limit;

  /// Sort field and direction (e.g. "created_at:desc").
  final String? sort;

  /// Search query string.
  final String? query;

  /// Converts to a query parameter map for Dio requests.
  Map<String, dynamic> toQueryParameters() {
    return <String, dynamic>{
      if (cursor != null) 'cursor': cursor,
      if (limit != null) 'limit': limit,
      if (sort != null) 'sort': sort,
      if (query != null) 'q': query,
    };
  }
}
