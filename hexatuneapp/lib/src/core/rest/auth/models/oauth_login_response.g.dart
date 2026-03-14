// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oauth_login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OAuthLoginResponse _$OAuthLoginResponseFromJson(Map<String, dynamic> json) =>
    _OAuthLoginResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      sessionId: json['sessionId'] as String,
      accountId: json['accountId'] as String,
      expiresAt: json['expiresAt'] as String,
      isNewAccount: json['isNewAccount'] as bool,
    );

Map<String, dynamic> _$OAuthLoginResponseToJson(_OAuthLoginResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'sessionId': instance.sessionId,
      'accountId': instance.accountId,
      'expiresAt': instance.expiresAt,
      'isNewAccount': instance.isNewAccount,
    };
