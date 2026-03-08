// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_summary_dto.freezed.dart';
part 'task_summary_dto.g.dart';

/// Summary model for task list endpoints.
@freezed
abstract class TaskSummaryDto with _$TaskSummaryDto {
  const factory TaskSummaryDto({
    required String taskId,
    required String taskType,
    required String status,
    required String scheduledAt,
    required int retryCount,
    required int maxRetries,
    required String createdAt,
    required String updatedAt,
    String? cronExpression,
    String? executeAfter,
  }) = _TaskSummaryDto;

  factory TaskSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$TaskSummaryDtoFromJson(json);
}
