// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'formula_item_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FormulaItemResponse _$FormulaItemResponseFromJson(Map<String, dynamic> json) =>
    _FormulaItemResponse(
      id: json['id'] as String,
      inventoryId: json['inventoryId'] as String,
      sortOrder: (json['sortOrder'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$FormulaItemResponseToJson(
  _FormulaItemResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'inventoryId': instance.inventoryId,
  'sortOrder': instance.sortOrder,
  'quantity': instance.quantity,
};
