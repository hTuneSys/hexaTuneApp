// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

/// DSP engine constants mirroring native `hexatune_dsp_ffi.h` defines.
///
/// These values must stay in sync with the Rust FFI library (v0.1.2).
class DspConstants {
  DspConstants._();

  // --- Layer limits ---

  /// Maximum number of simultaneous texture layers.
  static const int maxTextureLayers = 3;

  /// Maximum number of simultaneous event slots.
  static const int maxEventSlots = 5;

  // --- Default gain values (0.0–1.0) ---

  /// Default base layer gain.
  static const double defaultBaseGain = 0.6;

  /// Default texture layer gain.
  static const double defaultTextureGain = 0.3;

  /// Default event layer gain.
  static const double defaultEventGain = 0.4;

  /// Default binaural beat gain.
  static const double defaultBinauralGain = 0.15;

  /// Default master output gain.
  static const double defaultMasterGain = 1.0;

  // --- Audio configuration ---

  /// Default sample rate for mobile audio (48 kHz).
  static const double sampleRate = 48000.0;

  /// Default crossfade length in sample frames (~42 ms at 48 kHz).
  static const int defaultCrossfadeFrames = 2048;

  /// Audio render buffer size in frames.
  static const int bufferSize = 1024;

  /// Stereo channel count.
  static const int stereoChannels = 2;

  // --- Default binaural configuration ---

  /// Fixed carrier / LO frequency in Hz for all DSP modes.
  ///
  /// Monaural: single channel plays at this frequency + delta.
  /// Binaural: left ear = this frequency, right ear = this + delta.
  static const double carrierFrequency = 220.0;

  /// Default frequency delta per cycle step in Hz.
  static const double defaultFrequencyDelta = 5.0;

  /// Default cycle step duration in seconds.
  static const double defaultCycleDuration = 30.0;

  // --- Event timing defaults ---

  /// Minimum interval between event triggers in milliseconds.
  static const int defaultEventMinIntervalMs = 3000;

  /// Maximum interval between event triggers in milliseconds.
  static const int defaultEventMaxIntervalMs = 8000;

  /// Minimum event rendering volume.
  static const double defaultEventVolumeMin = 0.3;

  /// Maximum event rendering volume.
  static const double defaultEventVolumeMax = 0.8;

  /// Minimum stereo pan (-1.0 = full left).
  static const double defaultEventPanMin = -0.5;

  /// Maximum stereo pan (1.0 = full right).
  static const double defaultEventPanMax = 0.5;

  // --- Asset discovery ---

  /// Root path for audio assets in the Flutter asset bundle.
  static const String audioAssetRoot = 'assets/audio/ambience';

  /// Supported audio file extensions.
  static const List<String> supportedExtensions = [
    '.m4a',
    '.wav',
    '.mp3',
    '.ogg',
  ];

  // --- Method channel ---

  /// Platform channel name for DSP audio communication.
  static const String methodChannelName = 'com.hexatune/dsp_audio';

  // --- Status logging ---

  /// Interval for status logging during rendering.
  static const Duration logInterval = Duration(seconds: 3);
}

/// Error codes returned by FFI functions (mirrors `HtdError` enum in C).
enum HtdError {
  ok(0),
  nullPointer(-1),
  invalidConfig(-2),
  initFailed(-3),
  invalidUtf8(-4),
  bufferTooSmall(-5),
  loadFailed(-6),
  layerLimitExceeded(-7),
  baseRequired(-8);

  const HtdError(this.code);

  /// Numeric error code matching the native library.
  final int code;

  /// Look up an [HtdError] by its native error code.
  static HtdError fromCode(int code) {
    for (final e in values) {
      if (e.code == code) return e;
    }
    return ok;
  }

  /// Human-readable description for logging.
  String get description {
    return switch (this) {
      ok => 'Success',
      nullPointer => 'Null pointer',
      invalidConfig => 'Invalid configuration',
      initFailed => 'Engine initialization failed',
      invalidUtf8 => 'Invalid UTF-8 string',
      bufferTooSmall => 'Buffer too small',
      loadFailed => 'Load failed',
      layerLimitExceeded => 'Layer limit exceeded',
      baseRequired => 'Base layer required',
    };
  }
}
