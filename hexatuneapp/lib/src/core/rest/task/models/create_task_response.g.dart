// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_task_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateTaskResponse _$CreateTaskResponseFromJson(Map<String, dynamic> json) =>
    _CreateTaskResponse(
      taskId: json['taskId'] as String,
      status: json['status'] as String,
      scheduledAt: json['scheduledAt'] as String,
      executeAfter: json['executeAfter'] as String?,
    );

Map<String, dynamic> _$CreateTaskResponseToJson(_CreateTaskResponse instance) =>
    <String, dynamic>{
      'taskId': instance.taskId,
      'status': instance.status,
      'scheduledAt': instance.scheduledAt,
      'executeAfter': instance.executeAfter,
    };
