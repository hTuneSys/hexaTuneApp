// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_balance_response.freezed.dart';
part 'wallet_balance_response.g.dart';

/// Response for GET /api/v1/wallet/balance.
@freezed
abstract class WalletBalanceResponse with _$WalletBalanceResponse {
  const factory WalletBalanceResponse({
    required String tenantId,
    required int balanceCoins,
    required int totalPurchased,
    required int totalSpent,
  }) = _WalletBalanceResponse;

  factory WalletBalanceResponse.fromJson(Map<String, dynamic> json) =>
      _$WalletBalanceResponseFromJson(json);
}
