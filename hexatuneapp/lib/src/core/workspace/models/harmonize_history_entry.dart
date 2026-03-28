// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'harmonize_history_entry.freezed.dart';
part 'harmonize_history_entry.g.dart';

/// A lightweight inventory reference for history entries.
@freezed
abstract class HistoryInventoryItem with _$HistoryInventoryItem {
  const factory HistoryInventoryItem({
    required String id,
    required String name,
  }) = _HistoryInventoryItem;

  factory HistoryInventoryItem.fromJson(Map<String, dynamic> json) =>
      _$HistoryInventoryItemFromJson(json);
}

/// A recorded harmonize session for the workspace "Recently Used" section.
///
/// Stores just enough data to display the card and re-trigger harmonization
/// with the same source. Limited to the last 20 entries.
@freezed
abstract class HarmonizeHistoryEntry with _$HarmonizeHistoryEntry {
  const factory HarmonizeHistoryEntry({
    /// Source type: 'Formula', 'Inventory', or 'Flow'.
    required String sourceType,

    /// Formula ID (when sourceType is 'Formula').
    String? formulaId,

    /// Formula name (when sourceType is 'Formula').
    String? formulaName,

    /// Selected inventories (when sourceType is 'Inventory').
    @Default([]) List<HistoryInventoryItem> inventories,

    /// Flow ID (when sourceType is 'Flow', future use).
    String? flowId,

    /// Generation type used (e.g. 'Monaural', 'Binaural').
    required String generationType,

    /// Ambience config ID if one was selected.
    String? ambienceId,

    /// Repeat count (null = infinite).
    int? repeatCount,

    /// ISO 8601 timestamp of when the harmonize session started.
    required String harmonizedAt,
  }) = _HarmonizeHistoryEntry;

  factory HarmonizeHistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$HarmonizeHistoryEntryFromJson(json);
}
