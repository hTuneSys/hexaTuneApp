// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'approve_request_dto.freezed.dart';
part 'approve_request_dto.g.dart';

/// Body for POST /api/v1/device-approvals/{id}/approve.
@freezed
abstract class ApproveRequestDto with _$ApproveRequestDto {
  const factory ApproveRequestDto({required String approvingDeviceId}) =
      _ApproveRequestDto;

  factory ApproveRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ApproveRequestDtoFromJson(json);
}
