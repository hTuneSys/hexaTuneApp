// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'reorder_entry.freezed.dart';
part 'reorder_entry.g.dart';

/// A single reorder entry for formula items (sortOrder must be non-negative).
@freezed
abstract class ReorderEntry with _$ReorderEntry {
  const factory ReorderEntry({required String itemId, required int sortOrder}) =
      _ReorderEntry;

  factory ReorderEntry.fromJson(Map<String, dynamic> json) =>
      _$ReorderEntryFromJson(json);
}
