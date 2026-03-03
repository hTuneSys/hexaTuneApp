// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_formula_item_quantity_request.freezed.dart';
part 'update_formula_item_quantity_request.g.dart';

/// Request model for updating a formula item quantity.
@freezed
abstract class UpdateFormulaItemQuantityRequest
    with _$UpdateFormulaItemQuantityRequest {
  const factory UpdateFormulaItemQuantityRequest({
    required int quantity,
  }) = _UpdateFormulaItemQuantityRequest;

  factory UpdateFormulaItemQuantityRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateFormulaItemQuantityRequestFromJson(json);
}
