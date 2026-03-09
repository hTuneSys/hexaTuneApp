// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'harmonic_packet_dto.freezed.dart';
part 'harmonic_packet_dto.g.dart';

/// A single packet in the harmonic sequence response.
@freezed
abstract class HarmonicPacketDto with _$HarmonicPacketDto {
  const factory HarmonicPacketDto({
    /// The harmonic value for this packet.
    required int value,

    /// Duration in milliseconds.
    required int durationMs,

    /// Whether this packet plays only once (in the first cycle).
    required bool isOneShot,
  }) = _HarmonicPacketDto;

  factory HarmonicPacketDto.fromJson(Map<String, dynamic> json) =>
      _$HarmonicPacketDtoFromJson(json);
}
