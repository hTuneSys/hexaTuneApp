// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/wallet/models/wallet_balance_response.dart';

void main() {
  group('WalletBalanceResponse', () {
    final fullJson = <String, dynamic>{
      'tenantId': 'tenant-001',
      'balanceCoins': 500,
      'totalPurchased': 1000,
      'totalSpent': 500,
    };

    test('can be created with required fields', () {
      const result = WalletBalanceResponse(
        tenantId: 'tenant-001',
        balanceCoins: 500,
        totalPurchased: 1000,
        totalSpent: 500,
      );
      expect(result.tenantId, 'tenant-001');
      expect(result.balanceCoins, 500);
      expect(result.totalPurchased, 1000);
      expect(result.totalSpent, 500);
    });

    test('serializes to JSON correctly', () {
      const result = WalletBalanceResponse(
        tenantId: 'tenant-001',
        balanceCoins: 250,
        totalPurchased: 750,
        totalSpent: 500,
      );
      final json = result.toJson();
      expect(json['tenantId'], 'tenant-001');
      expect(json['balanceCoins'], 250);
      expect(json['totalPurchased'], 750);
      expect(json['totalSpent'], 500);
    });

    test('deserializes from JSON correctly', () {
      final result = WalletBalanceResponse.fromJson(fullJson);
      expect(result.tenantId, 'tenant-001');
      expect(result.balanceCoins, 500);
      expect(result.totalPurchased, 1000);
      expect(result.totalSpent, 500);
    });

    test('handles zero balances', () {
      const result = WalletBalanceResponse(
        tenantId: 'tenant-new',
        balanceCoins: 0,
        totalPurchased: 0,
        totalSpent: 0,
      );
      expect(result.balanceCoins, 0);
      expect(result.totalPurchased, 0);
      expect(result.totalSpent, 0);
    });

    test('equality works correctly', () {
      const a = WalletBalanceResponse(
        tenantId: 'tenant-001',
        balanceCoins: 500,
        totalPurchased: 1000,
        totalSpent: 500,
      );
      const b = WalletBalanceResponse(
        tenantId: 'tenant-001',
        balanceCoins: 500,
        totalPurchased: 1000,
        totalSpent: 500,
      );
      const c = WalletBalanceResponse(
        tenantId: 'tenant-002',
        balanceCoins: 0,
        totalPurchased: 0,
        totalSpent: 0,
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      const original = WalletBalanceResponse(
        tenantId: 'tenant-001',
        balanceCoins: 500,
        totalPurchased: 1000,
        totalSpent: 500,
      );
      final roundTripped = WalletBalanceResponse.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
