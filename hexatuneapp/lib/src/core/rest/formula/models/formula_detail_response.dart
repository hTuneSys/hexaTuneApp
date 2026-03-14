// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:hexatuneapp/src/core/rest/formula/models/formula_item_response.dart';

part 'formula_detail_response.freezed.dart';
part 'formula_detail_response.g.dart';

/// Detailed response model for a single formula with items.
@freezed
abstract class FormulaDetailResponse with _$FormulaDetailResponse {
  const factory FormulaDetailResponse({
    required String id,
    required String name,
    required List<String> labels,
    required List<FormulaItemResponse> items,
    required String createdAt,
    required String updatedAt,
  }) = _FormulaDetailResponse;

  factory FormulaDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$FormulaDetailResponseFromJson(json);
}
