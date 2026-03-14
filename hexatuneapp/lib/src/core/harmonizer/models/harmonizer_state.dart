// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:hexatuneapp/src/core/harmonizer/models/generation_type.dart';
import 'package:hexatuneapp/src/core/rest/harmonics/models/harmonic_packet_dto.dart';

part 'harmonizer_state.freezed.dart';

/// Possible statuses for the harmonizer player.
enum HarmonizerStatus { idle, preparing, playing, stopping, error }

/// Immutable snapshot of the harmonizer's current state.
@freezed
abstract class HarmonizerState with _$HarmonizerState {
  const factory HarmonizerState({
    /// The generation type currently active (null when idle).
    GenerationType? activeType,

    /// Current status of the harmonizer.
    @Default(HarmonizerStatus.idle) HarmonizerStatus status,

    /// The ambience config ID loaded for this session (monaural/binaural).
    String? ambienceId,

    /// The formula ID that produced the current sequence (for UI restoration).
    String? formulaId,

    /// The frequency step sequence from the API.
    @Default([]) List<HarmonicPacketDto> sequence,

    /// Current infinite-loop cycle number (0-based).
    @Default(0) int currentCycle,

    /// Index of the step currently playing within the cycle.
    @Default(0) int currentStepIndex,

    /// Total duration of one full cycle (excluding one-shot after first).
    @Default(Duration.zero) Duration totalCycleDuration,

    /// Duration of the very first cycle (includes one-shots).
    @Default(Duration.zero) Duration firstCycleDuration,

    /// Time remaining in the current cycle (countdown).
    @Default(Duration.zero) Duration remainingInCycle,

    /// Whether we are in the first cycle (one-shots still active).
    @Default(true) bool isFirstCycle,

    /// Human-readable error message when status is [HarmonizerStatus.error].
    String? errorMessage,

    /// True after a graceful stop has been requested.
    @Default(false) bool gracefulStopRequested,
  }) = _HarmonizerState;
}
