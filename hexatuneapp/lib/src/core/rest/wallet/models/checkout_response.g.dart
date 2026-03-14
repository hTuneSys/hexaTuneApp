// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CheckoutResponse _$CheckoutResponseFromJson(Map<String, dynamic> json) =>
    _CheckoutResponse(
      sessionId: json['sessionId'] as String,
      checkoutUrl: json['checkoutUrl'] as String?,
    );

Map<String, dynamic> _$CheckoutResponseToJson(_CheckoutResponse instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'checkoutUrl': instance.checkoutUrl,
    };
