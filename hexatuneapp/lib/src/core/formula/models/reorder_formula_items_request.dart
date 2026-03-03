// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:hexatuneapp/src/core/formula/models/reorder_entry.dart';

part 'reorder_formula_items_request.freezed.dart';
part 'reorder_formula_items_request.g.dart';

/// Request model for reordering formula items.
@freezed
abstract class ReorderFormulaItemsRequest with _$ReorderFormulaItemsRequest {
  const factory ReorderFormulaItemsRequest({
    required List<ReorderEntry> items,
  }) = _ReorderFormulaItemsRequest;

  factory ReorderFormulaItemsRequest.fromJson(Map<String, dynamic> json) =>
      _$ReorderFormulaItemsRequestFromJson(json);
}
