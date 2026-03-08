// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refresh_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RefreshResponse _$RefreshResponseFromJson(Map<String, dynamic> json) =>
    _RefreshResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      sessionId: json['sessionId'] as String,
      expiresAt: json['expiresAt'] as String,
    );

Map<String, dynamic> _$RefreshResponseToJson(_RefreshResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'sessionId': instance.sessionId,
      'expiresAt': instance.expiresAt,
    };
