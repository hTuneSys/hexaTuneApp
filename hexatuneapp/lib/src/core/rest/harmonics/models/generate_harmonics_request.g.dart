// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generate_harmonics_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GenerateHarmonicsRequest _$GenerateHarmonicsRequestFromJson(
  Map<String, dynamic> json,
) => _GenerateHarmonicsRequest(
  inventoryIds: (json['inventoryIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$GenerateHarmonicsRequestToJson(
  _GenerateHarmonicsRequest instance,
) => <String, dynamic>{'inventoryIds': instance.inventoryIds};
