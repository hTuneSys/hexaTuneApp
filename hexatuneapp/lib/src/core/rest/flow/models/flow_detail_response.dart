// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:hexatuneapp/src/core/rest/flow/models/flow_step_response.dart';

part 'flow_detail_response.freezed.dart';
part 'flow_detail_response.g.dart';

/// Detailed response model for a single flow with its steps.
@freezed
abstract class FlowDetailResponse with _$FlowDetailResponse {
  const factory FlowDetailResponse({
    required String id,
    required String name,
    required String description,
    required List<String> labels,
    required bool imageUploaded,
    required List<FlowStepResponse> steps,
    required String createdAt,
    required String updatedAt,
  }) = _FlowDetailResponse;

  factory FlowDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$FlowDetailResponseFromJson(json);
}
