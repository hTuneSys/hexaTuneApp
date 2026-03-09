// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generate_harmonics_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GenerateHarmonicsRequest _$GenerateHarmonicsRequestFromJson(
  Map<String, dynamic> json,
) => _GenerateHarmonicsRequest(
  generationType: json['generationType'] as String,
  sourceType: json['sourceType'] as String,
  sourceId: json['sourceId'] as String,
);

Map<String, dynamic> _$GenerateHarmonicsRequestToJson(
  _GenerateHarmonicsRequest instance,
) => <String, dynamic>{
  'generationType': instance.generationType,
  'sourceType': instance.sourceType,
  'sourceId': instance.sourceId,
};
