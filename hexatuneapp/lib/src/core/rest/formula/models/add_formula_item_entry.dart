// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_formula_item_entry.freezed.dart';
part 'add_formula_item_entry.g.dart';

/// A single entry when adding items to a formula.
@freezed
abstract class AddFormulaItemEntry with _$AddFormulaItemEntry {
  const factory AddFormulaItemEntry({
    required String inventoryId,

    /// Quantity (defaults to 1 if not provided, min 1, max 60).
    int? quantity,

    /// Sort order (defaults to 0 if not provided, must be non-negative).
    int? sortOrder,
  }) = _AddFormulaItemEntry;

  factory AddFormulaItemEntry.fromJson(Map<String, dynamic> json) =>
      _$AddFormulaItemEntryFromJson(json);
}
