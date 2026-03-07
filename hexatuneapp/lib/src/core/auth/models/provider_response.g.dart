// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProviderResponse _$ProviderResponseFromJson(Map<String, dynamic> json) =>
    _ProviderResponse(
      providerType: json['providerType'] as String,
      linkedAt: json['linkedAt'] as String,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$ProviderResponseToJson(_ProviderResponse instance) =>
    <String, dynamic>{
      'providerType': instance.providerType,
      'linkedAt': instance.linkedAt,
      'email': instance.email,
    };
