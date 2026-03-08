// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:hexatuneapp/src/core/rest/harmonics/models/harmonic_assignment_dto.dart';

part 'generate_harmonics_response.freezed.dart';
part 'generate_harmonics_response.g.dart';

/// Response model for a successful harmonic generation.
@freezed
abstract class GenerateHarmonicsResponse with _$GenerateHarmonicsResponse {
  const factory GenerateHarmonicsResponse({
    required String requestId,
    required List<HarmonicAssignmentDto> assignments,
    required int totalAssigned,
  }) = _GenerateHarmonicsResponse;

  factory GenerateHarmonicsResponse.fromJson(Map<String, dynamic> json) =>
      _$GenerateHarmonicsResponseFromJson(json);
}
