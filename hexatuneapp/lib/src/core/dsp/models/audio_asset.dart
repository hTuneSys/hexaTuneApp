// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_asset.freezed.dart';

/// Represents a single audio file discovered in the asset bundle.
@freezed
abstract class AudioAsset with _$AudioAsset {
  const factory AudioAsset({
    /// Layer type: "base", "texture", or "events".
    required String layerType,

    /// Display name derived from the filename (without extension).
    required String name,

    /// Full asset path for loading via the asset bundle.
    required String assetPath,
  }) = _AudioAsset;
}
