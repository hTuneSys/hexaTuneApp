// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'approval_request_response_dto.freezed.dart';
part 'approval_request_response_dto.g.dart';

/// Response DTO for device approval endpoints.
@freezed
abstract class ApprovalRequestResponseDto with _$ApprovalRequestResponseDto {
  const factory ApprovalRequestResponseDto({
    required String requestId,
    required String accountId,
    required String requestingDeviceId,
    required String operationType,
    required String status,
    required String createdAt,
    required String expiresAt,
    required bool isExpired,
    String? approvingDeviceId,
    String? approvedAt,
    String? rejectedAt,
    Map<String, dynamic>? operationMetadata,
  }) = _ApprovalRequestResponseDto;

  factory ApprovalRequestResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ApprovalRequestResponseDtoFromJson(json);
}
