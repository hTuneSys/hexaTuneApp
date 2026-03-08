// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'formula_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FormulaDetailResponse _$FormulaDetailResponseFromJson(
  Map<String, dynamic> json,
) => _FormulaDetailResponse(
  id: json['id'] as String,
  name: json['name'] as String,
  labels: (json['labels'] as List<dynamic>).map((e) => e as String).toList(),
  items: (json['items'] as List<dynamic>)
      .map((e) => FormulaItemResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
);

Map<String, dynamic> _$FormulaDetailResponseToJson(
  _FormulaDetailResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'labels': instance.labels,
  'items': instance.items,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};
