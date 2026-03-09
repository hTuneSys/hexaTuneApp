// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:hexatuneapp/src/core/rest/harmonics/models/harmonic_packet_dto.dart';

part 'generate_harmonics_response.freezed.dart';
part 'generate_harmonics_response.g.dart';

/// Response model for a successful harmonic generation.
@freezed
abstract class GenerateHarmonicsResponse with _$GenerateHarmonicsResponse {
  const factory GenerateHarmonicsResponse({
    /// The unique request identifier for this generation.
    required String requestId,

    /// The generation type used.
    required String generationType,

    /// The source type used.
    required String sourceType,

    /// The source identifier.
    required String sourceId,

    /// The generated harmonic packet sequence.
    required List<HarmonicPacketDto> sequence,

    /// Total number of packets in the sequence.
    required int totalItems,
  }) = _GenerateHarmonicsResponse;

  factory GenerateHarmonicsResponse.fromJson(Map<String, dynamic> json) =>
      _$GenerateHarmonicsResponseFromJson(json);
}
