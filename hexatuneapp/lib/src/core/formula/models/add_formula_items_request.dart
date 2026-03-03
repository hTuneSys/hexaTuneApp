// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:hexatuneapp/src/core/formula/models/add_formula_item_entry.dart';

part 'add_formula_items_request.freezed.dart';
part 'add_formula_items_request.g.dart';

/// Request model for adding items to a formula.
@freezed
abstract class AddFormulaItemsRequest with _$AddFormulaItemsRequest {
  const factory AddFormulaItemsRequest({
    required List<AddFormulaItemEntry> items,
  }) = _AddFormulaItemsRequest;

  factory AddFormulaItemsRequest.fromJson(Map<String, dynamic> json) =>
      _$AddFormulaItemsRequestFromJson(json);
}
