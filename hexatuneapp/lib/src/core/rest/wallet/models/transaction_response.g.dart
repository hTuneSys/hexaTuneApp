// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionResponse _$TransactionResponseFromJson(Map<String, dynamic> json) =>
    _TransactionResponse(
      id: json['id'] as String,
      tenantId: json['tenantId'] as String,
      walletId: json['walletId'] as String,
      transactionType: json['transactionType'] as String,
      amountCoins: (json['amountCoins'] as num).toInt(),
      balanceAfter: (json['balanceAfter'] as num).toInt(),
      description: json['description'] as String,
      status: json['status'] as String,
      createdAt: json['createdAt'] as String,
      provider: json['provider'] as String?,
    );

Map<String, dynamic> _$TransactionResponseToJson(
  _TransactionResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'tenantId': instance.tenantId,
  'walletId': instance.walletId,
  'transactionType': instance.transactionType,
  'amountCoins': instance.amountCoins,
  'balanceAfter': instance.balanceAfter,
  'description': instance.description,
  'status': instance.status,
  'createdAt': instance.createdAt,
  'provider': instance.provider,
};
