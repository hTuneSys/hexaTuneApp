// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

/// Prerequisite validation result for a generation type.
enum HarmonizerValidation {
  /// All prerequisites are met — harmonizing can start.
  valid,

  /// Headphones must be connected (binaural mode).
  headsetRequired,

  /// A hexaGen device must be connected (magnetic mode).
  hexagenRequired,

  /// The generation type is not yet supported (photonic / quantal).
  notSupported,
}
