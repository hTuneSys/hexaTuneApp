// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_status_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskStatusResponse _$TaskStatusResponseFromJson(Map<String, dynamic> json) =>
    _TaskStatusResponse(
      taskId: json['taskId'] as String,
      taskType: json['taskType'] as String,
      status: json['status'] as String,
      payload: json['payload'] as Map<String, dynamic>,
      scheduledAt: json['scheduledAt'] as String,
      retryCount: (json['retryCount'] as num).toInt(),
      maxRetries: (json['maxRetries'] as num).toInt(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      cronExpression: json['cronExpression'] as String?,
      executeAfter: json['executeAfter'] as String?,
      startedAt: json['startedAt'] as String?,
      completedAt: json['completedAt'] as String?,
      failedAt: json['failedAt'] as String?,
      cancelledAt: json['cancelledAt'] as String?,
      errorMessage: json['errorMessage'] as String?,
      result: json['result'] as Map<String, dynamic>?,
      progressPercentage: (json['progressPercentage'] as num?)?.toInt(),
      progressStatus: json['progressStatus'] as String?,
    );

Map<String, dynamic> _$TaskStatusResponseToJson(_TaskStatusResponse instance) =>
    <String, dynamic>{
      'taskId': instance.taskId,
      'taskType': instance.taskType,
      'status': instance.status,
      'payload': instance.payload,
      'scheduledAt': instance.scheduledAt,
      'retryCount': instance.retryCount,
      'maxRetries': instance.maxRetries,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'cronExpression': instance.cronExpression,
      'executeAfter': instance.executeAfter,
      'startedAt': instance.startedAt,
      'completedAt': instance.completedAt,
      'failedAt': instance.failedAt,
      'cancelledAt': instance.cancelledAt,
      'errorMessage': instance.errorMessage,
      'result': instance.result,
      'progressPercentage': instance.progressPercentage,
      'progressStatus': instance.progressStatus,
    };
