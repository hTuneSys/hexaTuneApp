// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancel_task_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CancelTaskResponse _$CancelTaskResponseFromJson(Map<String, dynamic> json) =>
    _CancelTaskResponse(
      taskId: json['taskId'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$CancelTaskResponseToJson(_CancelTaskResponse instance) =>
    <String, dynamic>{'taskId': instance.taskId, 'status': instance.status};
