// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'switch_tenant_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SwitchTenantResponse _$SwitchTenantResponseFromJson(
  Map<String, dynamic> json,
) => _SwitchTenantResponse(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  sessionId: json['sessionId'] as String,
);

Map<String, dynamic> _$SwitchTenantResponseToJson(
  _SwitchTenantResponse instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'sessionId': instance.sessionId,
};
