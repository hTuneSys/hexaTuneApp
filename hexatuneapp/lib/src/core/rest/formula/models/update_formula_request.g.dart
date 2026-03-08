// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_formula_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateFormulaRequest _$UpdateFormulaRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateFormulaRequest(
  name: json['name'] as String?,
  labels: (json['labels'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$UpdateFormulaRequestToJson(
  _UpdateFormulaRequest instance,
) => <String, dynamic>{'name': instance.name, 'labels': instance.labels};
