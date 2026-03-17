// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iap_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IapProduct _$IapProductFromJson(Map<String, dynamic> json) => _IapProduct(
  packageId: json['packageId'] as String,
  name: json['name'] as String,
  coins: (json['coins'] as num).toInt(),
  storeProductId: json['storeProductId'] as String,
  price: json['price'] as String,
  rawPrice: (json['rawPrice'] as num).toDouble(),
  currencyCode: json['currencyCode'] as String,
);

Map<String, dynamic> _$IapProductToJson(_IapProduct instance) =>
    <String, dynamic>{
      'packageId': instance.packageId,
      'name': instance.name,
      'coins': instance.coins,
      'storeProductId': instance.storeProductId,
      'price': instance.price,
      'rawPrice': instance.rawPrice,
      'currencyCode': instance.currencyCode,
    };
