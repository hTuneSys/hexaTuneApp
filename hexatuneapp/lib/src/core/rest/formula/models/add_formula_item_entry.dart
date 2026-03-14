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
    int? quantity,
    int? sortOrder,

    /// Duration in milliseconds (defaults to 1000 if not provided).
    int? timeMs,
  }) = _AddFormulaItemEntry;

  factory AddFormulaItemEntry.fromJson(Map<String, dynamic> json) =>
      _$AddFormulaItemEntryFromJson(json);
}
