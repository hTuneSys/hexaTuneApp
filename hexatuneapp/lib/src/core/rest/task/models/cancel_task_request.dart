// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'cancel_task_request.freezed.dart';
part 'cancel_task_request.g.dart';

/// Request model for cancelling a task.
@freezed
abstract class CancelTaskRequest with _$CancelTaskRequest {
  const factory CancelTaskRequest({String? reason}) = _CancelTaskRequest;

  factory CancelTaskRequest.fromJson(Map<String, dynamic> json) =>
      _$CancelTaskRequestFromJson(json);
}
