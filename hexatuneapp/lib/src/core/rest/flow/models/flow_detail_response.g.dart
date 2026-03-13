// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flow_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FlowDetailResponse _$FlowDetailResponseFromJson(Map<String, dynamic> json) =>
    _FlowDetailResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      labels: (json['labels'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      imageUploaded: json['imageUploaded'] as bool,
      steps: (json['steps'] as List<dynamic>)
          .map((e) => FlowStepResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$FlowDetailResponseToJson(_FlowDetailResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'labels': instance.labels,
      'imageUploaded': instance.imageUploaded,
      'steps': instance.steps,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
