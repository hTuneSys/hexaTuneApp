// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'harmonize_history_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HistoryInventoryItem _$HistoryInventoryItemFromJson(
  Map<String, dynamic> json,
) => _HistoryInventoryItem(
  id: json['id'] as String,
  name: json['name'] as String,
);

Map<String, dynamic> _$HistoryInventoryItemToJson(
  _HistoryInventoryItem instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};

_HarmonizeHistoryEntry _$HarmonizeHistoryEntryFromJson(
  Map<String, dynamic> json,
) => _HarmonizeHistoryEntry(
  sourceType: json['sourceType'] as String,
  formulaId: json['formulaId'] as String?,
  formulaName: json['formulaName'] as String?,
  inventories:
      (json['inventories'] as List<dynamic>?)
          ?.map((e) => HistoryInventoryItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  flowId: json['flowId'] as String?,
  generationType: json['generationType'] as String,
  ambienceId: json['ambienceId'] as String?,
  ambienceName: json['ambienceName'] as String?,
  repeatCount: (json['repeatCount'] as num?)?.toInt(),
  harmonizedAt: json['harmonizedAt'] as String,
);

Map<String, dynamic> _$HarmonizeHistoryEntryToJson(
  _HarmonizeHistoryEntry instance,
) => <String, dynamic>{
  'sourceType': instance.sourceType,
  'formulaId': instance.formulaId,
  'formulaName': instance.formulaName,
  'inventories': instance.inventories,
  'flowId': instance.flowId,
  'generationType': instance.generationType,
  'ambienceId': instance.ambienceId,
  'ambienceName': instance.ambienceName,
  'repeatCount': instance.repeatCount,
  'harmonizedAt': instance.harmonizedAt,
};
