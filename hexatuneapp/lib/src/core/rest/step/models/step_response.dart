// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'step_response.freezed.dart';
part 'step_response.g.dart';

/// Response model for step endpoints.
@freezed
abstract class StepResponse with _$StepResponse {
  const factory StepResponse({
    required String id,
    required String name,
    required String description,
    required List<String> labels,
    required bool imageUploaded,
    required String createdAt,
    required String updatedAt,
  }) = _StepResponse;

  factory StepResponse.fromJson(Map<String, dynamic> json) =>
      _$StepResponseFromJson(json);
}
