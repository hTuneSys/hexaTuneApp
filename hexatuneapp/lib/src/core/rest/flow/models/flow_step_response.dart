// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'flow_step_response.freezed.dart';
part 'flow_step_response.g.dart';

/// Response model for a step within a flow.
@freezed
abstract class FlowStepResponse with _$FlowStepResponse {
  const factory FlowStepResponse({
    required String id,
    required String stepId,
    required int sortOrder,
    required int quantity,

    /// Duration in milliseconds.
    required int timeMs,
  }) = _FlowStepResponse;

  factory FlowStepResponse.fromJson(Map<String, dynamic> json) =>
      _$FlowStepResponseFromJson(json);
}
