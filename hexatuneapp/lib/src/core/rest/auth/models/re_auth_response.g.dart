// GENERATED CODE - DO NOT MODIFY BY HAND

part of 're_auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReAuthResponse _$ReAuthResponseFromJson(Map<String, dynamic> json) =>
    _ReAuthResponse(
      token: json['token'] as String,
      expiresAt: json['expiresAt'] as String,
    );

Map<String, dynamic> _$ReAuthResponseToJson(_ReAuthResponse instance) =>
    <String, dynamic>{'token': instance.token, 'expiresAt': instance.expiresAt};
