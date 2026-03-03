// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_category_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateCategoryRequest _$CreateCategoryRequestFromJson(
  Map<String, dynamic> json,
) => _CreateCategoryRequest(
  name: json['name'] as String,
  labels: (json['labels'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$CreateCategoryRequestToJson(
  _CreateCategoryRequest instance,
) => <String, dynamic>{'name': instance.name, 'labels': instance.labels};
