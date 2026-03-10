// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'dsp_state.freezed.dart';

/// Current state of the DSP audio engine.
@freezed
abstract class DspState with _$DspState {
  const factory DspState({
    /// Whether the DSP engine has been initialized.
    @Default(false) bool isInitialized,

    /// Whether audio is currently playing.
    @Default(false) bool isPlaying,

    /// Whether a base layer has been loaded.
    @Default(false) bool isBaseLoaded,

    /// Fixed carrier frequency in Hz (220 Hz, not configurable).
    @Default(220.0) double carrierFrequency,

    /// Whether binaural mode is enabled (vs AM mono).
    @Default(true) bool binauralEnabled,

    /// Current base gain (0.0–1.0).
    @Default(0.6) double baseGain,

    /// Current texture gain (0.0–1.0).
    @Default(0.3) double textureGain,

    /// Current event gain (0.0–1.0).
    @Default(0.4) double eventGain,

    /// Current binaural gain (0.0–1.0).
    @Default(0.15) double binauralGain,

    /// Current master gain (0.0–1.0).
    @Default(1.0) double masterGain,

    /// Error message if initialization or playback failed.
    String? error,
  }) = _DspState;

  const DspState._();

  /// Whether the engine is in an error state.
  bool get hasError => error != null;
}
