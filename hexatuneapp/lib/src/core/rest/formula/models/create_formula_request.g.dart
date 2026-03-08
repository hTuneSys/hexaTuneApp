// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_formula_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateFormulaRequest _$CreateFormulaRequestFromJson(
  Map<String, dynamic> json,
) => _CreateFormulaRequest(
  name: json['name'] as String,
  labels: (json['labels'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$CreateFormulaRequestToJson(
  _CreateFormulaRequest instance,
) => <String, dynamic>{'name': instance.name, 'labels': instance.labels};
