// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flow_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FlowResponse _$FlowResponseFromJson(Map<String, dynamic> json) =>
    _FlowResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      labels: (json['labels'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      imageUploaded: json['imageUploaded'] as bool,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$FlowResponseToJson(_FlowResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'labels': instance.labels,
      'imageUploaded': instance.imageUploaded,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
