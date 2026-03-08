// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_category_request.freezed.dart';
part 'update_category_request.g.dart';

/// Body for PATCH /api/v1/categories/{id}.
@freezed
abstract class UpdateCategoryRequest with _$UpdateCategoryRequest {
  const factory UpdateCategoryRequest({String? name, List<String>? labels}) =
      _UpdateCategoryRequest;

  factory UpdateCategoryRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateCategoryRequestFromJson(json);
}
