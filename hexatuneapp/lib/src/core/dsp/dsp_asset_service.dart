// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/dsp/models/audio_asset.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';

/// Loads the sounds catalog JSON and provides structured access to audio
/// assets with icon paths and localization keys.
@singleton
class DspAssetService {
  DspAssetService(this._logService);

  final LogService _logService;
  List<AudioAsset> _assets = [];

  static const String catalogPath = 'assets/audio/ambience/sounds_catalog.json';

  /// All discovered audio assets.
  List<AudioAsset> get allAssets => List.unmodifiable(_assets);

  /// All unique layer types found (e.g. `["base", "events", "texture"]`).
  List<String> get layerTypes =>
      _assets.map((a) => a.layerType).toSet().toList()..sort();

  /// Assets filtered by the given [layerType].
  List<AudioAsset> assetsForLayer(String layerType) =>
      _assets.where((a) => a.layerType == layerType).toList();

  /// Load the sounds catalog from the bundled JSON file.
  Future<void> discover() async {
    _assets = [];

    try {
      final jsonStr = await rootBundle.loadString(catalogPath);
      final Map<String, dynamic> catalog = json.decode(jsonStr);
      final List<dynamic> sounds = catalog['sounds'] ?? [];

      for (final entry in sounds) {
        final id = entry['id'] as String;
        final type = entry['type'] as String;
        final audioAsset = entry['audioAsset'] as String;
        final iconAsset = entry['iconAsset'] as String? ?? '';
        final nameKey = entry['nameKey'] as String? ?? '';
        final name = fileNameToDisplayName(audioAsset.split('/').last);

        _assets.add(
          AudioAsset(
            id: id,
            layerType: type,
            name: name,
            assetPath: audioAsset,
            iconAsset: iconAsset,
            nameKey: nameKey,
          ),
        );
      }

      _assets.sort((a, b) {
        final c = a.layerType.compareTo(b.layerType);
        if (c != 0) return c;
        return a.name.compareTo(b.name);
      });

      _logService.info(
        'Loaded ${_assets.length} sounds from catalog',
        category: LogCategory.dsp,
      );
      for (final a in _assets) {
        _logService.devLog(
          '  ${a.layerType}: ${a.id} -> ${a.assetPath}',
          category: LogCategory.dsp,
        );
      }
    } catch (e, st) {
      _logService.error(
        'Sound catalog load failed: $e',
        category: LogCategory.dsp,
        exception: e,
        stackTrace: st,
      );
    }
  }

  /// Resolve the localized display name for a [nameKey].
  ///
  /// Falls back to [AudioAsset.name] if the key is not found or no
  /// [BuildContext] / [AppLocalizations] is available.
  static String resolveLocalizedName(BuildContext context, AudioAsset asset) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null || asset.nameKey.isEmpty) return asset.name;

    return _nameKeyMap[asset.nameKey]?.call(l10n) ?? asset.name;
  }

  /// Static map from JSON nameKey values to generated l10n getters.
  ///
  /// When adding new sounds, add a corresponding entry here and in the
  /// ARB files.
  static final Map<String, String Function(AppLocalizations)> _nameKeyMap = {
    'ambienceBaseForest': (l) => l.ambienceBaseForest,
    'ambienceBaseOcean': (l) => l.ambienceBaseOcean,
    'ambienceBaseRain': (l) => l.ambienceBaseRain,
    'ambienceTextureWave': (l) => l.ambienceTextureWave,
    'ambienceTextureWindThroughTrees': (l) => l.ambienceTextureWindThroughTrees,
    'ambienceEventBird': (l) => l.ambienceEventBird,
    'ambienceEventCat': (l) => l.ambienceEventCat,
    'ambienceEventFish': (l) => l.ambienceEventFish,
    'ambienceEventThunder': (l) => l.ambienceEventThunder,
  };

  static final _trailingTimestamp = RegExp(r'[\s_-]\d{10,}$');

  /// Converts a raw filename into a human-readable display name (fallback).
  static String fileNameToDisplayName(String fileName) {
    var name = fileName;

    final dotIdx = name.lastIndexOf('.');
    if (dotIdx >= 0) name = name.substring(0, dotIdx);

    name = name.replaceAll(_trailingTimestamp, '');
    name = name.replaceAll('_', ' ').replaceAll('-', ' ');
    name = name.replaceAll(RegExp(r'\s{2,}'), ' ').trim();

    if (name.isNotEmpty) {
      name = name
          .split(' ')
          .map((w) {
            if (w.isEmpty) return w;
            return w[0].toUpperCase() + w.substring(1);
          })
          .join(' ');
    }
    return name;
  }
}
