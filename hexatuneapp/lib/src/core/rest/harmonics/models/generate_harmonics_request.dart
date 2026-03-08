// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'generate_harmonics_request.freezed.dart';
part 'generate_harmonics_request.g.dart';

/// Request model for generating harmonic numbers.
@freezed
abstract class GenerateHarmonicsRequest with _$GenerateHarmonicsRequest {
  const factory GenerateHarmonicsRequest({required List<String> inventoryIds}) =
      _GenerateHarmonicsRequest;

  factory GenerateHarmonicsRequest.fromJson(Map<String, dynamic> json) =>
      _$GenerateHarmonicsRequestFromJson(json);
}
