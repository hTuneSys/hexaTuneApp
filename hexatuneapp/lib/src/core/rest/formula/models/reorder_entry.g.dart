// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reorder_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReorderEntry _$ReorderEntryFromJson(Map<String, dynamic> json) =>
    _ReorderEntry(
      itemId: json['itemId'] as String,
      sortOrder: (json['sortOrder'] as num).toInt(),
    );

Map<String, dynamic> _$ReorderEntryToJson(_ReorderEntry instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'sortOrder': instance.sortOrder,
    };
