// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountResponse _$AccountResponseFromJson(Map<String, dynamic> json) =>
    _AccountResponse(
      id: json['id'] as String,
      email: json['email'] as String,
      status: json['status'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$AccountResponseToJson(_AccountResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'status': instance.status,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
