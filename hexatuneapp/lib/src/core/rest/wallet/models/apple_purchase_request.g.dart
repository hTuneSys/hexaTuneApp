// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apple_purchase_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApplePurchaseRequest _$ApplePurchaseRequestFromJson(
  Map<String, dynamic> json,
) => _ApplePurchaseRequest(
  packageId: json['packageId'] as String,
  transactionId: json['transactionId'] as String,
);

Map<String, dynamic> _$ApplePurchaseRequestToJson(
  _ApplePurchaseRequest instance,
) => <String, dynamic>{
  'packageId': instance.packageId,
  'transactionId': instance.transactionId,
};
