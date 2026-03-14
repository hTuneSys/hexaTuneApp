// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flow_step_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FlowStepResponse _$FlowStepResponseFromJson(Map<String, dynamic> json) =>
    _FlowStepResponse(
      id: json['id'] as String,
      stepId: json['stepId'] as String,
      sortOrder: (json['sortOrder'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      timeMs: (json['timeMs'] as num).toInt(),
    );

Map<String, dynamic> _$FlowStepResponseToJson(_FlowStepResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'stepId': instance.stepId,
      'sortOrder': instance.sortOrder,
      'quantity': instance.quantity,
      'timeMs': instance.timeMs,
    };
