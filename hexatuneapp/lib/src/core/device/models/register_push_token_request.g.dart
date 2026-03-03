// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_push_token_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RegisterPushTokenRequest _$RegisterPushTokenRequestFromJson(
  Map<String, dynamic> json,
) => _RegisterPushTokenRequest(
  token: json['token'] as String,
  platform: json['platform'] as String,
);

Map<String, dynamic> _$RegisterPushTokenRequestToJson(
  _RegisterPushTokenRequest instance,
) => <String, dynamic>{'token': instance.token, 'platform': instance.platform};
