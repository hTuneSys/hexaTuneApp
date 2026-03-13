// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_response.freezed.dart';
part 'transaction_response.g.dart';

/// Response item for GET /api/v1/wallet/transactions.
@freezed
abstract class TransactionResponse with _$TransactionResponse {
  const factory TransactionResponse({
    required String id,
    required String tenantId,
    required String walletId,
    required String transactionType,
    required int amountCoins,
    required int balanceAfter,
    required String description,
    required String status,
    required String createdAt,
    String? provider,
  }) = _TransactionResponse;

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseFromJson(json);
}
