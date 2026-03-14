// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'ambience_config.freezed.dart';
part 'ambience_config.g.dart';

/// A saved ambience configuration combining sound layers and gain levels.
///
/// Each ambience is a user-created preset that can be loaded into the DSP
/// engine for playback. It stores references to audio assets by their
/// catalog IDs rather than full asset paths.
@freezed
abstract class AmbienceConfig with _$AmbienceConfig {
  const factory AmbienceConfig({
    /// Unique identifier (UUID v4).
    required String id,

    /// User-given display name.
    required String name,

    /// Selected base layer asset ID (from sounds_catalog.json), or null.
    String? baseAssetId,

    /// Selected texture layer asset IDs (0 to maxTextureLayers).
    @Default([]) List<String> textureAssetIds,

    /// Selected event layer asset IDs (0 to maxEventSlots).
    @Default([]) List<String> eventAssetIds,

    /// Base layer gain (0.0–1.0).
    @Default(0.6) double baseGain,

    /// Texture layer gain (0.0–1.0).
    @Default(0.3) double textureGain,

    /// Event layer gain (0.0–1.0).
    @Default(0.4) double eventGain,

    /// Master output gain (0.0–1.0).
    @Default(1.0) double masterGain,

    /// ISO 8601 creation timestamp.
    required String createdAt,

    /// ISO 8601 last-updated timestamp.
    required String updatedAt,
  }) = _AmbienceConfig;

  factory AmbienceConfig.fromJson(Map<String, dynamic> json) =>
      _$AmbienceConfigFromJson(json);
}
