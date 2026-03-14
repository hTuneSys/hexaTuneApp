// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

/// The five generation types supported by the Harmonizer.
enum GenerationType {
  monaural,
  binaural,
  magnetic,
  photonic,
  quantal;

  /// Whether this type is currently implemented and usable.
  bool get isActive => this == monaural || this == binaural || this == magnetic;

  /// Whether headphones are required (binaural only).
  bool get requiresHeadset => this == binaural;

  /// Whether a hexaGen device is required (magnetic only).
  bool get requiresHexagen => this == magnetic;

  /// Whether DSP ambience layers can be used (monaural / binaural).
  bool get supportsDspAmbience => this == monaural || this == binaural;

  /// Whether this type is driven by the DSP engine.
  bool get usesDsp => this == monaural || this == binaural;

  /// API value sent to the backend.
  String get apiValue => name[0].toUpperCase() + name.substring(1);
}
