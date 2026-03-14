// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_task_response.freezed.dart';
part 'create_task_response.g.dart';

/// Response model for task creation.
@freezed
abstract class CreateTaskResponse with _$CreateTaskResponse {
  const factory CreateTaskResponse({
    required String taskId,
    required String status,
    required String scheduledAt,
    String? executeAfter,
  }) = _CreateTaskResponse;

  factory CreateTaskResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateTaskResponseFromJson(json);
}
