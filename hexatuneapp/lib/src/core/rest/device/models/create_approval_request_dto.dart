// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_approval_request_dto.freezed.dart';
part 'create_approval_request_dto.g.dart';

/// Body for POST /api/v1/device-approvals/request.
@freezed
abstract class CreateApprovalRequestDto with _$CreateApprovalRequestDto {
  const factory CreateApprovalRequestDto({
    required String requestingDeviceId,
    required String operationType,
    Map<String, dynamic>? operationMetadata,
  }) = _CreateApprovalRequestDto;

  factory CreateApprovalRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateApprovalRequestDtoFromJson(json);
}
