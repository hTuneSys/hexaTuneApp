// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generate_harmonics_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GenerateHarmonicsResponse _$GenerateHarmonicsResponseFromJson(
  Map<String, dynamic> json,
) => _GenerateHarmonicsResponse(
  requestId: json['requestId'] as String,
  assignments: (json['assignments'] as List<dynamic>)
      .map((e) => HarmonicAssignmentDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalAssigned: (json['totalAssigned'] as num).toInt(),
);

Map<String, dynamic> _$GenerateHarmonicsResponseToJson(
  _GenerateHarmonicsResponse instance,
) => <String, dynamic>{
  'requestId': instance.requestId,
  'assignments': instance.assignments,
  'totalAssigned': instance.totalAssigned,
};
