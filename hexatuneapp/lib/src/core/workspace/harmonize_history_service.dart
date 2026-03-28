// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:convert';

import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/storage/preferences_service.dart';
import 'package:hexatuneapp/src/core/workspace/models/harmonize_history_entry.dart';

/// Manages locally-stored harmonize history for the workspace.
///
/// Persists the last [maxEntries] harmonize sessions via [PreferencesService]
/// as a JSON string so they survive app restarts.
@singleton
class HarmonizeHistoryService {
  HarmonizeHistoryService(this._prefs, this._logService);

  final PreferencesService _prefs;
  final LogService _logService;

  static const String _storageKey = 'workspace_harmonize_history';
  static const int maxEntries = 20;

  List<HarmonizeHistoryEntry> _entries = [];
  bool _loaded = false;

  /// All recorded history entries, most recent first.
  List<HarmonizeHistoryEntry> get entries => List.unmodifiable(_entries);

  /// Load history from local storage.
  ///
  /// Only reads from preferences on the first call. After that, in-memory
  /// state (kept up-to-date by [add]) is the source of truth.
  Future<void> load() async {
    if (_loaded) return;
    _loaded = true;
    try {
      final raw = _prefs.getString(_storageKey);
      if (raw == null || raw.isEmpty) {
        _entries = [];
        return;
      }
      final List<dynamic> list = json.decode(raw);
      _entries = list
          .map((e) => HarmonizeHistoryEntry.fromJson(e as Map<String, dynamic>))
          .toList();
      _logService.info(
        'Loaded ${_entries.length} harmonize history entries',
        category: LogCategory.storage,
      );
    } catch (e, st) {
      _logService.error(
        'Failed to load harmonize history: $e',
        category: LogCategory.storage,
        exception: e,
        stackTrace: st,
      );
      _entries = [];
    }
  }

  /// Record a new harmonize session. Keeps only the last [maxEntries].
  Future<void> add(HarmonizeHistoryEntry entry) async {
    _entries.insert(0, entry);
    if (_entries.length > maxEntries) {
      _entries = _entries.sublist(0, maxEntries);
    }
    await _persist();
    _logService.info(
      'Recorded harmonize history: ${entry.sourceType}',
      category: LogCategory.storage,
    );
  }

  /// Clear all history entries.
  Future<void> clear() async {
    _entries = [];
    await _persist();
  }

  // ---------------------------------------------------------------------------
  // Internal
  // ---------------------------------------------------------------------------

  Future<void> _persist() async {
    final jsonStr = json.encode(_entries.map((e) => e.toJson()).toList());
    await _prefs.setString(_storageKey, jsonStr);
  }
}
