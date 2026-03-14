// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_task_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateTaskRequest _$CreateTaskRequestFromJson(Map<String, dynamic> json) =>
    _CreateTaskRequest(
      taskType: json['taskType'] as String,
      payload: json['payload'] as Map<String, dynamic>,
      cronExpression: json['cronExpression'] as String?,
      executeAfter: json['executeAfter'] as String?,
    );

Map<String, dynamic> _$CreateTaskRequestToJson(_CreateTaskRequest instance) =>
    <String, dynamic>{
      'taskType': instance.taskType,
      'payload': instance.payload,
      'cronExpression': instance.cronExpression,
      'executeAfter': instance.executeAfter,
    };
