// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_meta.freezed.dart';
part 'pagination_meta.g.dart';

/// Cursor-based pagination metadata from the API.
@freezed
abstract class PaginationMeta with _$PaginationMeta {
  const factory PaginationMeta({
    @JsonKey(name: 'has_more') required bool hasMore,
    required int limit,
    @JsonKey(name: 'next_cursor') String? nextCursor,
  }) = _PaginationMeta;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaFromJson(json);
}
