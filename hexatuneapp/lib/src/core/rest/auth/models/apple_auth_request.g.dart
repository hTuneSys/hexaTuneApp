// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apple_auth_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppleAuthRequest _$AppleAuthRequestFromJson(Map<String, dynamic> json) =>
    _AppleAuthRequest(
      idToken: json['idToken'] as String,
      authorizationCode: json['authorizationCode'] as String?,
      deviceId: json['deviceId'] as String?,
    );

Map<String, dynamic> _$AppleAuthRequestToJson(_AppleAuthRequest instance) =>
    <String, dynamic>{
      'idToken': instance.idToken,
      'authorizationCode': instance.authorizationCode,
      'deviceId': instance.deviceId,
    };
