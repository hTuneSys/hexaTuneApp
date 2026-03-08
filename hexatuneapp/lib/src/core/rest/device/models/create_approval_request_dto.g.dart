// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_approval_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateApprovalRequestDto _$CreateApprovalRequestDtoFromJson(
  Map<String, dynamic> json,
) => _CreateApprovalRequestDto(
  requestingDeviceId: json['requestingDeviceId'] as String,
  operationType: json['operationType'] as String,
  operationMetadata: json['operationMetadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$CreateApprovalRequestDtoToJson(
  _CreateApprovalRequestDto instance,
) => <String, dynamic>{
  'requestingDeviceId': instance.requestingDeviceId,
  'operationType': instance.operationType,
  'operationMetadata': instance.operationMetadata,
};
