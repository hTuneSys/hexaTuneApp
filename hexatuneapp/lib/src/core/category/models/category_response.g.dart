// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoryResponse _$CategoryResponseFromJson(Map<String, dynamic> json) =>
    _CategoryResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      labels: (json['labels'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$CategoryResponseToJson(_CategoryResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'labels': instance.labels,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
