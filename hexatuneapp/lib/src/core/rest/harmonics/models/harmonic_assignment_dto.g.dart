// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'harmonic_assignment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HarmonicAssignmentDto _$HarmonicAssignmentDtoFromJson(
  Map<String, dynamic> json,
) => _HarmonicAssignmentDto(
  inventoryId: json['inventoryId'] as String,
  harmonicNumber: (json['harmonicNumber'] as num).toInt(),
  assignedAt: json['assignedAt'] as String,
);

Map<String, dynamic> _$HarmonicAssignmentDtoToJson(
  _HarmonicAssignmentDto instance,
) => <String, dynamic>{
  'inventoryId': instance.inventoryId,
  'harmonicNumber': instance.harmonicNumber,
  'assignedAt': instance.assignedAt,
};
