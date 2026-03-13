// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_balance_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalletBalanceResponse _$WalletBalanceResponseFromJson(
  Map<String, dynamic> json,
) => _WalletBalanceResponse(
  tenantId: json['tenantId'] as String,
  balanceCoins: (json['balanceCoins'] as num).toInt(),
  totalPurchased: (json['totalPurchased'] as num).toInt(),
  totalSpent: (json['totalSpent'] as num).toInt(),
);

Map<String, dynamic> _$WalletBalanceResponseToJson(
  _WalletBalanceResponse instance,
) => <String, dynamic>{
  'tenantId': instance.tenantId,
  'balanceCoins': instance.balanceCoins,
  'totalPurchased': instance.totalPurchased,
  'totalSpent': instance.totalSpent,
};
