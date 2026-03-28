// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:hexatuneapp/src/core/harmonizer/models/generation_type.dart';
import 'package:hexatuneapp/src/core/rest/harmonics/models/harmonic_packet_dto.dart';

part 'harmonizer_config.freezed.dart';

/// Configuration needed to start a harmonizer session.
@freezed
abstract class HarmonizerConfig with _$HarmonizerConfig {
  const factory HarmonizerConfig({
    /// The generation type to use.
    required GenerationType type,

    /// Optional ambience config ID (monaural / binaural only).
    String? ambienceId,

    /// The harmonic packet sequence to harmonize (from API response).
    required List<HarmonicPacketDto> steps,

    /// The formula ID that generated this sequence (for UI state restoration).
    String? formulaId,

    /// Number of cycles to repeat (null = infinite).
    int? repeatCount,
  }) = _HarmonizerConfig;
}
