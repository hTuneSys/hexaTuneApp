// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_package_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoinPackageResponse _$CoinPackageResponseFromJson(Map<String, dynamic> json) =>
    _CoinPackageResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      coins: (json['coins'] as num).toInt(),
      priceCents: (json['priceCents'] as num).toInt(),
      currency: json['currency'] as String,
      sortOrder: (json['sortOrder'] as num).toInt(),
      appleProductId: json['appleProductId'] as String?,
      googleProductId: json['googleProductId'] as String?,
      stripePriceId: json['stripePriceId'] as String?,
    );

Map<String, dynamic> _$CoinPackageResponseToJson(
  _CoinPackageResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'coins': instance.coins,
  'priceCents': instance.priceCents,
  'currency': instance.currency,
  'sortOrder': instance.sortOrder,
  'appleProductId': instance.appleProductId,
  'googleProductId': instance.googleProductId,
  'stripePriceId': instance.stripePriceId,
};
