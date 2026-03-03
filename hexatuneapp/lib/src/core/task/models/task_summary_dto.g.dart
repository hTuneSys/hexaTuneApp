// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskSummaryDto _$TaskSummaryDtoFromJson(Map<String, dynamic> json) =>
    _TaskSummaryDto(
      taskId: json['taskId'] as String,
      taskType: json['taskType'] as String,
      status: json['status'] as String,
      scheduledAt: json['scheduledAt'] as String,
      retryCount: (json['retryCount'] as num).toInt(),
      maxRetries: (json['maxRetries'] as num).toInt(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      cronExpression: json['cronExpression'] as String?,
      executeAfter: json['executeAfter'] as String?,
    );

Map<String, dynamic> _$TaskSummaryDtoToJson(_TaskSummaryDto instance) =>
    <String, dynamic>{
      'taskId': instance.taskId,
      'taskType': instance.taskType,
      'status': instance.status,
      'scheduledAt': instance.scheduledAt,
      'retryCount': instance.retryCount,
      'maxRetries': instance.maxRetries,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'cronExpression': instance.cronExpression,
      'executeAfter': instance.executeAfter,
    };
