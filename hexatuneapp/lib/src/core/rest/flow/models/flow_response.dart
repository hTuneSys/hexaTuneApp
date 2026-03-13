// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'flow_response.freezed.dart';
part 'flow_response.g.dart';

/// Response model for flow list endpoints (without steps).
@freezed
abstract class FlowResponse with _$FlowResponse {
  const factory FlowResponse({
    required String id,
    required String name,
    required String description,
    required List<String> labels,
    required bool imageUploaded,
    required String createdAt,
    required String updatedAt,
  }) = _FlowResponse;

  factory FlowResponse.fromJson(Map<String, dynamic> json) =>
      _$FlowResponseFromJson(json);
}
