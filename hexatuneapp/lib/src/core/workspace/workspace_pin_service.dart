// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:convert';

import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/storage/preferences_service.dart';
import 'package:hexatuneapp/src/core/workspace/models/pinned_formula.dart';

/// Manages locally-stored pinned formulas for the workspace.
///
/// Pinned formulas are persisted via [PreferencesService] as a JSON string
/// so they survive app restarts. Each pin stores only the formula ID and name.
@singleton
class WorkspacePinService {
  WorkspacePinService(this._prefs, this._logService);

  final PreferencesService _prefs;
  final LogService _logService;

  static const String _storageKey = 'workspace_pinned_formulas';

  List<PinnedFormula> _pins = [];

  /// All currently pinned formulas, in insertion order.
  List<PinnedFormula> get pins => List.unmodifiable(_pins);

  /// Load pinned formulas from local storage.
  Future<void> load() async {
    try {
      final raw = _prefs.getString(_storageKey);
      if (raw == null || raw.isEmpty) {
        _pins = [];
        return;
      }
      final List<dynamic> list = json.decode(raw);
      _pins = list
          .map((e) => PinnedFormula.fromJson(e as Map<String, dynamic>))
          .toList();
      _logService.info(
        'Loaded ${_pins.length} pinned formulas',
        category: LogCategory.storage,
      );
    } catch (e, st) {
      _logService.error(
        'Failed to load pinned formulas: $e',
        category: LogCategory.storage,
        exception: e,
        stackTrace: st,
      );
      _pins = [];
    }
  }

  /// Pin a formula by [id] and [name]. No-op if already pinned.
  Future<void> pin(String id, String name) async {
    if (isPinned(id)) return;

    _pins.add(PinnedFormula(id: id, name: name));
    await _persist();
    _logService.info(
      'Pinned formula "$name" ($id)',
      category: LogCategory.storage,
    );
  }

  /// Unpin a formula by [id]. No-op if not pinned.
  Future<void> unpin(String id) async {
    final initialLength = _pins.length;
    _pins.removeWhere((p) => p.id == id);

    if (_pins.length == initialLength) return;

    await _persist();
    _logService.info('Unpinned formula ($id)', category: LogCategory.storage);
  }

  /// Whether a formula with the given [id] is currently pinned.
  bool isPinned(String id) => _pins.any((p) => p.id == id);

  // ---------------------------------------------------------------------------
  // Internal
  // ---------------------------------------------------------------------------

  Future<void> _persist() async {
    final jsonStr = json.encode(_pins.map((p) => p.toJson()).toList());
    await _prefs.setString(_storageKey, jsonStr);
  }
}
