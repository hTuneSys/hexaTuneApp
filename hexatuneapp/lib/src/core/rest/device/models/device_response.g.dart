// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeviceResponse _$DeviceResponseFromJson(Map<String, dynamic> json) =>
    _DeviceResponse(
      id: json['id'] as String,
      isTrusted: json['isTrusted'] as bool,
      userAgent: json['userAgent'] as String,
      ipAddress: json['ipAddress'] as String,
      firstSeenAt: json['firstSeenAt'] as String,
      lastSeenAt: json['lastSeenAt'] as String,
    );

Map<String, dynamic> _$DeviceResponseToJson(_DeviceResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isTrusted': instance.isTrusted,
      'userAgent': instance.userAgent,
      'ipAddress': instance.ipAddress,
      'firstSeenAt': instance.firstSeenAt,
      'lastSeenAt': instance.lastSeenAt,
    };
