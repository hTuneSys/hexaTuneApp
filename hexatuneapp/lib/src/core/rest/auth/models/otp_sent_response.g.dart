// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_sent_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OtpSentResponse _$OtpSentResponseFromJson(Map<String, dynamic> json) =>
    _OtpSentResponse(
      expiresInSeconds: (json['expiresInSeconds'] as num).toInt(),
    );

Map<String, dynamic> _$OtpSentResponseToJson(_OtpSentResponse instance) =>
    <String, dynamic>{'expiresInSeconds': instance.expiresInSeconds};
