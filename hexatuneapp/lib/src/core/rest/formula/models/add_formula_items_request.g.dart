// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_formula_items_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AddFormulaItemsRequest _$AddFormulaItemsRequestFromJson(
  Map<String, dynamic> json,
) => _AddFormulaItemsRequest(
  items: (json['items'] as List<dynamic>)
      .map((e) => AddFormulaItemEntry.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AddFormulaItemsRequestToJson(
  _AddFormulaItemsRequest instance,
) => <String, dynamic>{'items': instance.items};
