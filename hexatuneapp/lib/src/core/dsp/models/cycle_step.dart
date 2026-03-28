// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'cycle_step.freezed.dart';

/// A single step in the binaural frequency cycle.
@freezed
abstract class CycleStep with _$CycleStep {
  const factory CycleStep({
    /// Frequency offset in Hz from the carrier frequency.
    required double frequencyDelta,

    /// Duration of this step in seconds.
    required double durationSeconds,

    /// If true, this step runs only in the first cycle iteration.
    @Default(false) bool oneshot,
  }) = _CycleStep;
}
