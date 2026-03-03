// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'audit_log_dto.freezed.dart';
part 'audit_log_dto.g.dart';

/// Single audit log entry from GET /api/v1/audit/logs.
@freezed
abstract class AuditLogDto with _$AuditLogDto {
  const factory AuditLogDto({
    required String id,
    required String tenantId,
    required String actorType,
    String? actorId,
    required String action,
    required String resourceType,
    String? resourceId,
    required String outcome,
    required String severity,
    required String traceId,
    required bool containsPii,
    required String occurredAt,
    required String createdAt,
  }) = _AuditLogDto;

  factory AuditLogDto.fromJson(Map<String, dynamic> json) =>
      _$AuditLogDtoFromJson(json);
}
