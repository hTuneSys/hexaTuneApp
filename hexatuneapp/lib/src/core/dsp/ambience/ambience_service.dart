// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import 'package:hexatuneapp/src/core/dsp/ambience/models/ambience_config.dart';
import 'package:hexatuneapp/src/core/dsp/dsp_constants.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/storage/preferences_service.dart';

/// Manages locally-stored ambience presets (CRUD).
///
/// Each ambience is a combination of sound layer selections and gain
/// settings that can be loaded into the DSP engine for playback.
/// Data is persisted via [PreferencesService] as a JSON string.
@singleton
class AmbienceService {
  AmbienceService(this._prefs, this._logService);

  final PreferencesService _prefs;
  final LogService _logService;

  static const String _storageKey = 'ambience_configs';
  static const _uuid = Uuid();

  List<AmbienceConfig> _configs = [];

  /// All saved ambience configs, sorted by most recently updated first.
  List<AmbienceConfig> get configs => List.unmodifiable(_configs);

  /// Load saved configs from local storage.
  Future<void> load() async {
    try {
      final raw = _prefs.getString(_storageKey);
      if (raw == null || raw.isEmpty) {
        _configs = [];
        return;
      }
      final List<dynamic> list = json.decode(raw);
      _configs = list
          .map((e) => AmbienceConfig.fromJson(e as Map<String, dynamic>))
          .toList();
      _sortByUpdated();
      _logService.info(
        'Loaded ${_configs.length} ambience configs',
        category: LogCategory.dsp,
      );
    } catch (e, st) {
      _logService.error(
        'Failed to load ambience configs: $e',
        category: LogCategory.dsp,
        exception: e,
        stackTrace: st,
      );
      _configs = [];
    }
  }

  /// Find a config by [id], or null if not found.
  AmbienceConfig? findById(String id) {
    for (final c in _configs) {
      if (c.id == id) return c;
    }
    return null;
  }

  /// Create a new ambience config and persist it.
  ///
  /// Returns the created config with generated ID and timestamps.
  /// Throws [ArgumentError] if [name] is empty.
  Future<AmbienceConfig> create({
    required String name,
    String? baseAssetId,
    List<String> textureAssetIds = const [],
    List<String> eventAssetIds = const [],
    double baseGain = DspConstants.defaultBaseGain,
    double textureGain = DspConstants.defaultTextureGain,
    double eventGain = DspConstants.defaultEventGain,
    double masterGain = DspConstants.defaultMasterGain,
  }) async {
    _validateName(name);
    _validateLayers(textureAssetIds, eventAssetIds);

    final now = DateTime.now().toUtc().toIso8601String();
    final config = AmbienceConfig(
      id: _uuid.v4(),
      name: name.trim(),
      baseAssetId: baseAssetId,
      textureAssetIds: List.unmodifiable(textureAssetIds),
      eventAssetIds: List.unmodifiable(eventAssetIds),
      baseGain: baseGain.clamp(0.0, 1.0),
      textureGain: textureGain.clamp(0.0, 1.0),
      eventGain: eventGain.clamp(0.0, 1.0),
      masterGain: masterGain.clamp(0.0, 1.0),
      createdAt: now,
      updatedAt: now,
    );

    _configs.add(config);
    _sortByUpdated();
    await _persist();

    _logService.info(
      'Created ambience "${config.name}" (${config.id})',
      category: LogCategory.dsp,
    );
    return config;
  }

  /// Update an existing ambience config by [id].
  ///
  /// Only the provided non-null fields are updated; others keep their
  /// current values. Returns the updated config.
  /// Throws [StateError] if not found, [ArgumentError] for invalid input.
  Future<AmbienceConfig> update(
    String id, {
    String? name,
    String? baseAssetId,
    bool clearBase = false,
    List<String>? textureAssetIds,
    List<String>? eventAssetIds,
    double? baseGain,
    double? textureGain,
    double? eventGain,
    double? masterGain,
  }) async {
    final idx = _configs.indexWhere((c) => c.id == id);
    if (idx < 0) throw StateError('Ambience config not found: $id');

    if (name != null) _validateName(name);

    final existing = _configs[idx];
    final newTextures = textureAssetIds ?? existing.textureAssetIds;
    final newEvents = eventAssetIds ?? existing.eventAssetIds;
    _validateLayers(newTextures, newEvents);

    final updated = existing.copyWith(
      name: name?.trim() ?? existing.name,
      baseAssetId: clearBase ? null : (baseAssetId ?? existing.baseAssetId),
      textureAssetIds: List.unmodifiable(newTextures),
      eventAssetIds: List.unmodifiable(newEvents),
      baseGain: (baseGain ?? existing.baseGain).clamp(0.0, 1.0),
      textureGain: (textureGain ?? existing.textureGain).clamp(0.0, 1.0),
      eventGain: (eventGain ?? existing.eventGain).clamp(0.0, 1.0),
      masterGain: (masterGain ?? existing.masterGain).clamp(0.0, 1.0),
      updatedAt: DateTime.now().toUtc().toIso8601String(),
    );

    _configs[idx] = updated;
    _sortByUpdated();
    await _persist();

    _logService.info(
      'Updated ambience "${updated.name}" (${updated.id})',
      category: LogCategory.dsp,
    );
    return updated;
  }

  /// Delete an ambience config by [id].
  ///
  /// Returns true if found and deleted, false otherwise.
  Future<bool> delete(String id) async {
    final removed = _configs.length;
    _configs.removeWhere((c) => c.id == id);

    if (_configs.length == removed) return false;

    await _persist();
    _logService.info(
      'Deleted ambience config ($id)',
      category: LogCategory.dsp,
    );
    return true;
  }

  /// Remove all saved ambience configs.
  Future<void> clearAll() async {
    _configs.clear();
    await _persist();
    _logService.info('Cleared all ambience configs', category: LogCategory.dsp);
  }

  // ---------------------------------------------------------------------------
  // Internal
  // ---------------------------------------------------------------------------

  void _sortByUpdated() {
    _configs.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Future<void> _persist() async {
    final jsonStr = json.encode(_configs.map((c) => c.toJson()).toList());
    await _prefs.setString(_storageKey, jsonStr);
  }

  void _validateName(String name) {
    if (name.trim().isEmpty) {
      throw ArgumentError('Ambience name cannot be empty');
    }
  }

  void _validateLayers(List<String> textures, List<String> events) {
    if (textures.length > DspConstants.maxTextureLayers) {
      throw ArgumentError(
        'Too many textures: ${textures.length} '
        '(max ${DspConstants.maxTextureLayers})',
      );
    }
    if (events.length > DspConstants.maxEventSlots) {
      throw ArgumentError(
        'Too many events: ${events.length} '
        '(max ${DspConstants.maxEventSlots})',
      );
    }
  }
}
