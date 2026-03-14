// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'headset_state.freezed.dart';

/// Represents the current connection state of audio headsets.
@freezed
abstract class HeadsetState with _$HeadsetState {
  const factory HeadsetState({
    @Default(false) bool wiredConnected,
    @Default(false) bool wirelessConnected,
  }) = _HeadsetState;

  const HeadsetState._();

  /// Whether any headset (wired or wireless) is currently connected.
  bool get isAnyConnected => wiredConnected || wirelessConnected;
}
