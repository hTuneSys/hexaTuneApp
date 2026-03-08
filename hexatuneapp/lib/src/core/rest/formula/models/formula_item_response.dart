// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'formula_item_response.freezed.dart';
part 'formula_item_response.g.dart';

/// Response model for a single formula item.
@freezed
abstract class FormulaItemResponse with _$FormulaItemResponse {
  const factory FormulaItemResponse({
    required String id,
    required String inventoryId,
    required int sortOrder,
    required int quantity,
  }) = _FormulaItemResponse;

  factory FormulaItemResponse.fromJson(Map<String, dynamic> json) =>
      _$FormulaItemResponseFromJson(json);
}
