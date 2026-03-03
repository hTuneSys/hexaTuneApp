// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_response.freezed.dart';
part 'category_response.g.dart';

/// Response model for category endpoints.
@freezed
abstract class CategoryResponse with _$CategoryResponse {
  const factory CategoryResponse({
    required String id,
    required String name,
    required List<String> labels,
    required String createdAt,
    required String updatedAt,
  }) = _CategoryResponse;

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseFromJson(json);
}
