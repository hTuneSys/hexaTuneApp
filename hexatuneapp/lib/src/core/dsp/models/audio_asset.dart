// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_asset.freezed.dart';

/// Represents a single audio file from the sounds catalog.
@freezed
abstract class AudioAsset with _$AudioAsset {
  const factory AudioAsset({
    /// Unique identifier (e.g. "forest", "bird").
    required String id,

    /// Layer type: "base", "texture", or "events".
    required String layerType,

    /// Fallback display name derived from the filename.
    required String name,

    /// Full asset path for loading audio via the asset bundle.
    required String assetPath,

    /// Asset path for the icon image.
    @Default('') String iconAsset,

    /// Localization key for the display name (e.g. "ambienceBaseForest").
    @Default('') String nameKey,
  }) = _AudioAsset;
}
