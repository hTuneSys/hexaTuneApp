// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/harmonizer/models/generation_type.dart';
import 'package:hexatuneapp/src/pages/shared/harmonize_source.dart';

/// Pre-fill values for the harmonizer bottom sheet, typically
/// reconstructed from a [HarmonizeHistoryEntry].
class HarmonizePreset {
  final GenerationType type;
  final int? repeatCount;
  final String? ambienceId;

  const HarmonizePreset({
    required this.type,
    this.repeatCount,
    this.ambienceId,
  });
}

/// Holds the current harmonize source selection across bottom sheet
/// open/close cycles and app lifecycle transitions.
///
/// Registered as a lazy singleton so the state persists
/// as long as the app is alive.
@lazySingleton
class HarmonizeSourceHolder {
  /// The currently selected harmonize source.
  HarmonizeSource? source;

  /// Optional pre-fill values for harmonizer controls.
  HarmonizePreset? preset;

  /// Clears the current source and preset.
  void clear() {
    source = null;
    preset = null;
  }
}
