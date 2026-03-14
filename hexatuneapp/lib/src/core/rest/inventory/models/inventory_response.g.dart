// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InventoryResponse _$InventoryResponseFromJson(Map<String, dynamic> json) =>
    _InventoryResponse(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String,
      name: json['name'] as String,
      labels: (json['labels'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      imageUploaded: json['imageUploaded'] as bool,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$InventoryResponseToJson(_InventoryResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categoryId': instance.categoryId,
      'name': instance.name,
      'labels': instance.labels,
      'imageUploaded': instance.imageUploaded,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'description': instance.description,
    };
