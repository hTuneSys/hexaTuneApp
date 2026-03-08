// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_auth_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GoogleAuthRequest _$GoogleAuthRequestFromJson(Map<String, dynamic> json) =>
    _GoogleAuthRequest(
      idToken: json['idToken'] as String,
      deviceId: json['deviceId'] as String?,
    );

Map<String, dynamic> _$GoogleAuthRequestToJson(_GoogleAuthRequest instance) =>
    <String, dynamic>{
      'idToken': instance.idToken,
      'deviceId': instance.deviceId,
    };
