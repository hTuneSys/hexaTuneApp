// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_request_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApprovalRequestResponseDto _$ApprovalRequestResponseDtoFromJson(
  Map<String, dynamic> json,
) => _ApprovalRequestResponseDto(
  requestId: json['requestId'] as String,
  accountId: json['accountId'] as String,
  requestingDeviceId: json['requestingDeviceId'] as String,
  operationType: json['operationType'] as String,
  status: json['status'] as String,
  createdAt: json['createdAt'] as String,
  expiresAt: json['expiresAt'] as String,
  isExpired: json['isExpired'] as bool,
  approvingDeviceId: json['approvingDeviceId'] as String?,
  approvedAt: json['approvedAt'] as String?,
  rejectedAt: json['rejectedAt'] as String?,
  operationMetadata: json['operationMetadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$ApprovalRequestResponseDtoToJson(
  _ApprovalRequestResponseDto instance,
) => <String, dynamic>{
  'requestId': instance.requestId,
  'accountId': instance.accountId,
  'requestingDeviceId': instance.requestingDeviceId,
  'operationType': instance.operationType,
  'status': instance.status,
  'createdAt': instance.createdAt,
  'expiresAt': instance.expiresAt,
  'isExpired': instance.isExpired,
  'approvingDeviceId': instance.approvingDeviceId,
  'approvedAt': instance.approvedAt,
  'rejectedAt': instance.rejectedAt,
  'operationMetadata': instance.operationMetadata,
};
