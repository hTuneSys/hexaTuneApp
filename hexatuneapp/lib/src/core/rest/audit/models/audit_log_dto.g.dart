// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuditLogDto _$AuditLogDtoFromJson(Map<String, dynamic> json) => _AuditLogDto(
  id: json['id'] as String,
  tenantId: json['tenantId'] as String,
  actorType: json['actorType'] as String,
  actorId: json['actorId'] as String?,
  action: json['action'] as String,
  resourceType: json['resourceType'] as String,
  resourceId: json['resourceId'] as String?,
  outcome: json['outcome'] as String,
  severity: json['severity'] as String,
  traceId: json['traceId'] as String,
  containsPii: json['containsPii'] as bool,
  occurredAt: json['occurredAt'] as String,
  createdAt: json['createdAt'] as String,
);

Map<String, dynamic> _$AuditLogDtoToJson(_AuditLogDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenantId': instance.tenantId,
      'actorType': instance.actorType,
      'actorId': instance.actorId,
      'action': instance.action,
      'resourceType': instance.resourceType,
      'resourceId': instance.resourceId,
      'outcome': instance.outcome,
      'severity': instance.severity,
      'traceId': instance.traceId,
      'containsPii': instance.containsPii,
      'occurredAt': instance.occurredAt,
      'createdAt': instance.createdAt,
    };
