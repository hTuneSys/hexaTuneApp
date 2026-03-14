// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/wallet/models/wallet_balance_response.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/coin_package_response.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/initiate_purchase_request.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/mobile_purchase_request.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/checkout_response.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/transaction_response.dart';

void main() {
  group('WalletBalanceResponse', () {
    test('fromJson creates instance', () {
      final json = {
        'tenantId': 'tenant-001',
        'balanceCoins': 500,
        'totalPurchased': 1000,
        'totalSpent': 500,
      };
      final result = WalletBalanceResponse.fromJson(json);
      expect(result.tenantId, 'tenant-001');
      expect(result.balanceCoins, 500);
      expect(result.totalPurchased, 1000);
      expect(result.totalSpent, 500);
    });

    test('toJson produces correct keys', () {
      const result = WalletBalanceResponse(
        tenantId: 't',
        balanceCoins: 100,
        totalPurchased: 200,
        totalSpent: 100,
      );
      final json = result.toJson();
      expect(json['tenantId'], 't');
      expect(json['balanceCoins'], 100);
      expect(json['totalPurchased'], 200);
      expect(json['totalSpent'], 100);
    });

    test('round-trip preserves values', () {
      const original = WalletBalanceResponse(
        tenantId: 't',
        balanceCoins: 100,
        totalPurchased: 200,
        totalSpent: 100,
      );
      final restored = WalletBalanceResponse.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('CoinPackageResponse', () {
    test('fromJson with all fields', () {
      final json = {
        'id': 'pkg-001',
        'name': 'Starter Pack',
        'coins': 100,
        'priceCents': 999,
        'currency': 'USD',
        'sortOrder': 1,
        'appleProductId': 'com.hexatune.coins100',
        'googleProductId': 'coins_100',
        'stripePriceId': 'price_abc',
      };
      final result = CoinPackageResponse.fromJson(json);
      expect(result.id, 'pkg-001');
      expect(result.name, 'Starter Pack');
      expect(result.coins, 100);
      expect(result.priceCents, 999);
      expect(result.currency, 'USD');
      expect(result.sortOrder, 1);
      expect(result.appleProductId, 'com.hexatune.coins100');
      expect(result.googleProductId, 'coins_100');
      expect(result.stripePriceId, 'price_abc');
    });

    test('fromJson without optional fields', () {
      final json = {
        'id': 'pkg-002',
        'name': 'Basic',
        'coins': 50,
        'priceCents': 499,
        'currency': 'EUR',
        'sortOrder': 2,
      };
      final result = CoinPackageResponse.fromJson(json);
      expect(result.id, 'pkg-002');
      expect(result.appleProductId, isNull);
      expect(result.googleProductId, isNull);
      expect(result.stripePriceId, isNull);
    });

    test('round-trip preserves values', () {
      const original = CoinPackageResponse(
        id: 'p',
        name: 'n',
        coins: 10,
        priceCents: 100,
        currency: 'USD',
        sortOrder: 0,
        appleProductId: 'a',
      );
      final restored = CoinPackageResponse.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('InitiatePurchaseRequest', () {
    test('fromJson creates instance', () {
      final json = {'packageId': 'pkg-001'};
      final result = InitiatePurchaseRequest.fromJson(json);
      expect(result.packageId, 'pkg-001');
    });

    test('toJson produces correct keys', () {
      const result = InitiatePurchaseRequest(packageId: 'pkg-001');
      final json = result.toJson();
      expect(json['packageId'], 'pkg-001');
    });

    test('round-trip preserves values', () {
      const original = InitiatePurchaseRequest(packageId: 'p');
      final restored = InitiatePurchaseRequest.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('MobilePurchaseRequest', () {
    test('fromJson creates instance', () {
      final json = {'packageId': 'pkg-001', 'receiptData': 'receipt-abc'};
      final result = MobilePurchaseRequest.fromJson(json);
      expect(result.packageId, 'pkg-001');
      expect(result.receiptData, 'receipt-abc');
    });

    test('toJson produces correct keys', () {
      const result = MobilePurchaseRequest(
        packageId: 'pkg-001',
        receiptData: 'receipt-abc',
      );
      final json = result.toJson();
      expect(json['packageId'], 'pkg-001');
      expect(json['receiptData'], 'receipt-abc');
    });

    test('round-trip preserves values', () {
      const original = MobilePurchaseRequest(packageId: 'p', receiptData: 'r');
      final restored = MobilePurchaseRequest.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('CheckoutResponse', () {
    test('fromJson with all fields', () {
      final json = {
        'sessionId': 'cs_abc123',
        'checkoutUrl': 'https://checkout.stripe.com/c/pay/abc',
      };
      final result = CheckoutResponse.fromJson(json);
      expect(result.sessionId, 'cs_abc123');
      expect(result.checkoutUrl, 'https://checkout.stripe.com/c/pay/abc');
    });

    test('fromJson without optional checkoutUrl', () {
      final json = {'sessionId': 'cs_abc123'};
      final result = CheckoutResponse.fromJson(json);
      expect(result.sessionId, 'cs_abc123');
      expect(result.checkoutUrl, isNull);
    });

    test('round-trip preserves values', () {
      const original = CheckoutResponse(sessionId: 's', checkoutUrl: 'u');
      final restored = CheckoutResponse.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('TransactionResponse', () {
    test('fromJson with all fields', () {
      final json = {
        'id': 'tx-001',
        'tenantId': 'tenant-001',
        'walletId': 'wallet-001',
        'transactionType': 'credit',
        'amountCoins': 100,
        'balanceAfter': 600,
        'description': 'Package purchase',
        'status': 'completed',
        'createdAt': '2025-01-01T00:00:00Z',
        'provider': 'stripe',
      };
      final result = TransactionResponse.fromJson(json);
      expect(result.id, 'tx-001');
      expect(result.tenantId, 'tenant-001');
      expect(result.walletId, 'wallet-001');
      expect(result.transactionType, 'credit');
      expect(result.amountCoins, 100);
      expect(result.balanceAfter, 600);
      expect(result.description, 'Package purchase');
      expect(result.status, 'completed');
      expect(result.createdAt, '2025-01-01T00:00:00Z');
      expect(result.provider, 'stripe');
    });

    test('fromJson without optional provider', () {
      final json = {
        'id': 'tx-002',
        'tenantId': 'tenant-001',
        'walletId': 'wallet-001',
        'transactionType': 'debit',
        'amountCoins': -50,
        'balanceAfter': 550,
        'description': 'Usage',
        'status': 'completed',
        'createdAt': '2025-01-02T00:00:00Z',
      };
      final result = TransactionResponse.fromJson(json);
      expect(result.id, 'tx-002');
      expect(result.provider, isNull);
    });

    test('round-trip preserves values', () {
      const original = TransactionResponse(
        id: 'i',
        tenantId: 't',
        walletId: 'w',
        transactionType: 'credit',
        amountCoins: 10,
        balanceAfter: 20,
        description: 'd',
        status: 's',
        createdAt: 'c',
        provider: 'p',
      );
      final restored = TransactionResponse.fromJson(original.toJson());
      expect(restored, original);
    });
  });
}
