// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_purchase_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GooglePurchaseRequest _$GooglePurchaseRequestFromJson(
  Map<String, dynamic> json,
) => _GooglePurchaseRequest(
  packageId: json['packageId'] as String,
  productId: json['productId'] as String,
  purchaseToken: json['purchaseToken'] as String,
);

Map<String, dynamic> _$GooglePurchaseRequestToJson(
  _GooglePurchaseRequest instance,
) => <String, dynamic>{
  'packageId': instance.packageId,
  'productId': instance.productId,
  'purchaseToken': instance.purchaseToken,
};
