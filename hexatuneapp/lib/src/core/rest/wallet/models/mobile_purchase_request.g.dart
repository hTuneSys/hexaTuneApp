// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_purchase_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MobilePurchaseRequest _$MobilePurchaseRequestFromJson(
  Map<String, dynamic> json,
) => _MobilePurchaseRequest(
  packageId: json['packageId'] as String,
  receiptData: json['receiptData'] as String,
);

Map<String, dynamic> _$MobilePurchaseRequestToJson(
  _MobilePurchaseRequest instance,
) => <String, dynamic>{
  'packageId': instance.packageId,
  'receiptData': instance.receiptData,
};
