// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'generate_harmonics_request.freezed.dart';
part 'generate_harmonics_request.g.dart';

/// Request model for generating a harmonic packet sequence.
@freezed
abstract class GenerateHarmonicsRequest with _$GenerateHarmonicsRequest {
  const factory GenerateHarmonicsRequest({
    /// The generation type (Monaural, Binaural, Magnetic, Photonic, Quantal).
    required String generationType,

    /// The source type (Flow, Formula).
    required String sourceType,

    /// The source identifier (e.g. formula ID when sourceType is Formula).
    required String sourceId,
  }) = _GenerateHarmonicsRequest;

  factory GenerateHarmonicsRequest.fromJson(Map<String, dynamic> json) =>
      _$GenerateHarmonicsRequestFromJson(json);
}
