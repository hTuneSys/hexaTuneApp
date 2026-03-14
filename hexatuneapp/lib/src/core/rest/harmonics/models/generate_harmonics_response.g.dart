// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generate_harmonics_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GenerateHarmonicsResponse _$GenerateHarmonicsResponseFromJson(
  Map<String, dynamic> json,
) => _GenerateHarmonicsResponse(
  requestId: json['requestId'] as String,
  generationType: json['generationType'] as String,
  sourceType: json['sourceType'] as String,
  sourceId: json['sourceId'] as String,
  sequence: (json['sequence'] as List<dynamic>)
      .map((e) => HarmonicPacketDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalItems: (json['totalItems'] as num).toInt(),
);

Map<String, dynamic> _$GenerateHarmonicsResponseToJson(
  _GenerateHarmonicsResponse instance,
) => <String, dynamic>{
  'requestId': instance.requestId,
  'generationType': instance.generationType,
  'sourceType': instance.sourceType,
  'sourceId': instance.sourceId,
  'sequence': instance.sequence,
  'totalItems': instance.totalItems,
};
