// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_account_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateAccountRequest _$CreateAccountRequestFromJson(
  Map<String, dynamic> json,
) => _CreateAccountRequest(
  email: json['email'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$CreateAccountRequestToJson(
  _CreateAccountRequest instance,
) => <String, dynamic>{'email': instance.email, 'password': instance.password};
