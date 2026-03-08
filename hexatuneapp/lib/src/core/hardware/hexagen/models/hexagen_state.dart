// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'hexagen_state.freezed.dart';

/// Connection and device state for the hexaGen hardware.
@freezed
abstract class HexagenState with _$HexagenState {
  const factory HexagenState({
    @Default(false) bool isConnected,
    @Default(false) bool isInitialized,
    String? deviceId,
    String? deviceName,
    String? firmwareVersion,
  }) = _HexagenState;

  const HexagenState._();

  /// Whether the device is connected and ready for communication.
  bool get isReady => isConnected && isInitialized && firmwareVersion != null;
}
