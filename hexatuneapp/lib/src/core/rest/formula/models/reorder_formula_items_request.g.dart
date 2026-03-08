// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reorder_formula_items_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReorderFormulaItemsRequest _$ReorderFormulaItemsRequestFromJson(
  Map<String, dynamic> json,
) => _ReorderFormulaItemsRequest(
  items: (json['items'] as List<dynamic>)
      .map((e) => ReorderEntry.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ReorderFormulaItemsRequestToJson(
  _ReorderFormulaItemsRequest instance,
) => <String, dynamic>{'items': instance.items};
