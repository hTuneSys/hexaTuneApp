// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'formula_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FormulaResponse _$FormulaResponseFromJson(Map<String, dynamic> json) =>
    _FormulaResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      labels: (json['labels'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$FormulaResponseToJson(_FormulaResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'labels': instance.labels,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
