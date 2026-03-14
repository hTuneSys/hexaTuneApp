// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_status_response.freezed.dart';
part 'task_status_response.g.dart';

/// Detailed status response for a single task.
@freezed
abstract class TaskStatusResponse with _$TaskStatusResponse {
  const factory TaskStatusResponse({
    required String taskId,
    required String taskType,
    required String status,
    required Map<String, dynamic> payload,
    required String scheduledAt,
    required int retryCount,
    required int maxRetries,
    required String createdAt,
    required String updatedAt,
    String? cronExpression,
    String? executeAfter,
    String? startedAt,
    String? completedAt,
    String? failedAt,
    String? cancelledAt,
    String? errorMessage,
    Map<String, dynamic>? result,
    int? progressPercentage,
    String? progressStatus,
  }) = _TaskStatusResponse;

  factory TaskStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskStatusResponseFromJson(json);
}
