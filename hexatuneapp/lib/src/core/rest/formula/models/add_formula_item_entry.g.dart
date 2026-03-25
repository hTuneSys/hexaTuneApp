// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_formula_item_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AddFormulaItemEntry _$AddFormulaItemEntryFromJson(Map<String, dynamic> json) =>
    _AddFormulaItemEntry(
      inventoryId: json['inventoryId'] as String,
      quantity: (json['quantity'] as num?)?.toInt(),
      sortOrder: (json['sortOrder'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AddFormulaItemEntryToJson(
  _AddFormulaItemEntry instance,
) => <String, dynamic>{
  'inventoryId': instance.inventoryId,
  'quantity': instance.quantity,
  'sortOrder': instance.sortOrder,
};
