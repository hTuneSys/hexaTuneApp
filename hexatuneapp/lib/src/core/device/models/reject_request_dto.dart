// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'reject_request_dto.freezed.dart';
part 'reject_request_dto.g.dart';

/// Body for POST /api/v1/device-approvals/{id}/reject.
@freezed
abstract class RejectRequestDto with _$RejectRequestDto {
  const factory RejectRequestDto({
    required String rejectingDeviceId,
  }) = _RejectRequestDto;

  factory RejectRequestDto.fromJson(Map<String, dynamic> json) =>
      _$RejectRequestDtoFromJson(json);
}
