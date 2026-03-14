// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_category_request.freezed.dart';
part 'create_category_request.g.dart';

/// Body for POST /api/v1/categories.
@freezed
abstract class CreateCategoryRequest with _$CreateCategoryRequest {
  const factory CreateCategoryRequest({
    required String name,
    List<String>? labels,
  }) = _CreateCategoryRequest;

  factory CreateCategoryRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCategoryRequestFromJson(json);
}
