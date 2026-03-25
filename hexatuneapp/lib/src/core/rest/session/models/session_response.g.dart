// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionResponse _$SessionResponseFromJson(Map<String, dynamic> json) =>
    _SessionResponse(
      id: json['id'] as String,
      accountId: json['accountId'] as String,
      deviceId: json['deviceId'] as String,
      lastActivityAt: json['lastActivityAt'] as String,
      createdAt: json['createdAt'] as String,
      expiresAt: json['expiresAt'] as String,
    );

Map<String, dynamic> _$SessionResponseToJson(_SessionResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountId': instance.accountId,
      'deviceId': instance.deviceId,
      'lastActivityAt': instance.lastActivityAt,
      'createdAt': instance.createdAt,
      'expiresAt': instance.expiresAt,
    };
