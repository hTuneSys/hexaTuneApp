// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_category_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateCategoryRequest _$UpdateCategoryRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateCategoryRequest(
  name: json['name'] as String?,
  labels: (json['labels'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$UpdateCategoryRequestToJson(
  _UpdateCategoryRequest instance,
) => <String, dynamic>{'name': instance.name, 'labels': instance.labels};
