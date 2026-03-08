// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'cancel_task_response.freezed.dart';
part 'cancel_task_response.g.dart';

/// Response model for task cancellation.
@freezed
abstract class CancelTaskResponse with _$CancelTaskResponse {
  const factory CancelTaskResponse({
    required String taskId,
    required String status,
  }) = _CancelTaskResponse;

  factory CancelTaskResponse.fromJson(Map<String, dynamic> json) =>
      _$CancelTaskResponseFromJson(json);
}
