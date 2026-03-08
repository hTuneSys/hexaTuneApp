// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/dsp/dsp_constants.dart';
import 'package:hexatuneapp/src/core/dsp/models/audio_asset.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';

/// Discovers audio assets from the bundled Flutter asset manifest.
///
/// Scans `assets/audio/ambience/{base,texture,events}/` for supported audio
/// files and provides structured access by layer type.
@singleton
class DspAssetService {
  DspAssetService(this._logService);

  final LogService _logService;
  List<AudioAsset> _assets = [];

  /// All discovered audio assets.
  List<AudioAsset> get allAssets => List.unmodifiable(_assets);

  /// All unique layer types found (e.g. `["base", "events", "texture"]`).
  List<String> get layerTypes =>
      _assets.map((a) => a.layerType).toSet().toList()..sort();

  /// Assets filtered by the given [layerType].
  List<AudioAsset> assetsForLayer(String layerType) =>
      _assets.where((a) => a.layerType == layerType).toList();

  /// Scan the Flutter asset manifest and populate the asset list.
  Future<void> discover() async {
    _assets = [];

    try {
      final assetMap = await AssetManifest.loadFromAssetBundle(rootBundle);
      final allKeys = assetMap.listAssets();

      for (final key in allKeys) {
        if (!key.startsWith(DspConstants.audioAssetRoot)) continue;
        if (!DspConstants.supportedExtensions.any(
          (ext) => key.toLowerCase().endsWith(ext),
        )) {
          continue;
        }

        final relative = key.substring(DspConstants.audioAssetRoot.length + 1);
        final parts = relative.split('/');
        if (parts.length < 2) continue;

        final layerType = parts[0];
        final fileName = parts.sublist(1).join('/');
        final name = fileNameToDisplayName(fileName);

        _assets.add(
          AudioAsset(layerType: layerType, name: name, assetPath: key),
        );
      }

      _assets.sort((a, b) {
        final c = a.layerType.compareTo(b.layerType);
        if (c != 0) return c;
        return a.name.compareTo(b.name);
      });

      _logService.info(
        'Discovered ${_assets.length} audio assets',
        category: LogCategory.dsp,
      );
      for (final a in _assets) {
        _logService.devLog(
          '  ${a.layerType}: ${a.name} -> ${a.assetPath}',
          category: LogCategory.dsp,
        );
      }
    } catch (e, st) {
      _logService.error(
        'Audio asset discovery failed: $e',
        category: LogCategory.dsp,
        exception: e,
        stackTrace: st,
      );
    }
  }

  static final _trailingTimestamp = RegExp(r'[\s_-]\d{10,}$');

  /// Converts a raw filename into a human-readable display name.
  static String fileNameToDisplayName(String fileName) {
    var name = fileName;

    for (final ext in DspConstants.supportedExtensions) {
      if (name.toLowerCase().endsWith(ext)) {
        name = name.substring(0, name.length - ext.length);
        break;
      }
    }

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
