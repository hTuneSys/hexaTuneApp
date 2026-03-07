// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_membership_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TenantMembershipResponse _$TenantMembershipResponseFromJson(
  Map<String, dynamic> json,
) => _TenantMembershipResponse(
  id: json['id'] as String,
  tenantId: json['tenantId'] as String,
  role: json['role'] as String,
  status: json['status'] as String,
  isOwner: json['isOwner'] as bool,
  joinedAt: json['joinedAt'] as String?,
);

Map<String, dynamic> _$TenantMembershipResponseToJson(
  _TenantMembershipResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'tenantId': instance.tenantId,
  'role': instance.role,
  'status': instance.status,
  'isOwner': instance.isOwner,
  'joinedAt': instance.joinedAt,
};
