// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/wallet/models/transaction_response.dart';

void main() {
  group('TransactionResponse', () {
    final fullJson = <String, dynamic>{
      'id': 'tx-001',
      'tenantId': 'tenant-001',
      'walletId': 'wallet-001',
      'transactionType': 'credit',
      'amountCoins': 100,
      'balanceAfter': 600,
      'description': 'Coin purchase',
      'status': 'completed',
      'createdAt': '2025-01-01T00:00:00Z',
      'provider': 'stripe',
    };

    test('can be created with required fields only', () {
      const result = TransactionResponse(
        id: 'tx-001',
        tenantId: 'tenant-001',
        walletId: 'wallet-001',
        transactionType: 'credit',
        amountCoins: 100,
        balanceAfter: 600,
        description: 'Coin purchase',
        status: 'completed',
        createdAt: '2025-01-01T00:00:00Z',
      );
      expect(result.id, 'tx-001');
      expect(result.tenantId, 'tenant-001');
      expect(result.walletId, 'wallet-001');
      expect(result.transactionType, 'credit');
      expect(result.amountCoins, 100);
      expect(result.balanceAfter, 600);
      expect(result.description, 'Coin purchase');
      expect(result.status, 'completed');
      expect(result.createdAt, '2025-01-01T00:00:00Z');
      expect(result.provider, isNull);
    });

    test('can be created with all fields', () {
      const result = TransactionResponse(
        id: 'tx-001',
        tenantId: 'tenant-001',
        walletId: 'wallet-001',
        transactionType: 'credit',
        amountCoins: 100,
        balanceAfter: 600,
        description: 'Coin purchase',
        status: 'completed',
        createdAt: '2025-01-01T00:00:00Z',
        provider: 'stripe',
      );
      expect(result.provider, 'stripe');
    });

    test('serializes to JSON correctly', () {
      const result = TransactionResponse(
        id: 'tx-001',
        tenantId: 'tenant-001',
        walletId: 'wallet-001',
        transactionType: 'debit',
        amountCoins: 50,
        balanceAfter: 450,
        description: 'Formula unlock',
        status: 'completed',
        createdAt: '2025-02-01T00:00:00Z',
        provider: 'apple',
      );
      final json = result.toJson();
      expect(json['id'], 'tx-001');
      expect(json['tenantId'], 'tenant-001');
      expect(json['walletId'], 'wallet-001');
      expect(json['transactionType'], 'debit');
      expect(json['amountCoins'], 50);
      expect(json['balanceAfter'], 450);
      expect(json['description'], 'Formula unlock');
      expect(json['status'], 'completed');
      expect(json['createdAt'], '2025-02-01T00:00:00Z');
      expect(json['provider'], 'apple');
    });

    test('serializes to JSON with null optional field', () {
      const result = TransactionResponse(
        id: 'tx-002',
        tenantId: 'tenant-001',
        walletId: 'wallet-001',
        transactionType: 'credit',
        amountCoins: 200,
        balanceAfter: 700,
        description: 'Refund',
        status: 'completed',
        createdAt: '2025-03-01T00:00:00Z',
      );
      final json = result.toJson();
      expect(json['provider'], isNull);
    });

    test('deserializes from JSON correctly', () {
      final result = TransactionResponse.fromJson(fullJson);
      expect(result.id, 'tx-001');
      expect(result.tenantId, 'tenant-001');
      expect(result.walletId, 'wallet-001');
      expect(result.transactionType, 'credit');
      expect(result.amountCoins, 100);
      expect(result.balanceAfter, 600);
      expect(result.description, 'Coin purchase');
      expect(result.status, 'completed');
      expect(result.createdAt, '2025-01-01T00:00:00Z');
      expect(result.provider, 'stripe');
    });

    test('deserializes from JSON with missing optional field', () {
      final json = <String, dynamic>{
        'id': 'tx-002',
        'tenantId': 'tenant-001',
        'walletId': 'wallet-001',
        'transactionType': 'credit',
        'amountCoins': 200,
        'balanceAfter': 700,
        'description': 'Refund',
        'status': 'completed',
        'createdAt': '2025-03-01T00:00:00Z',
      };
      final result = TransactionResponse.fromJson(json);
      expect(result.id, 'tx-002');
      expect(result.provider, isNull);
    });

    test('equality works correctly', () {
      const a = TransactionResponse(
        id: 'tx-001',
        tenantId: 'tenant-001',
        walletId: 'wallet-001',
        transactionType: 'credit',
        amountCoins: 100,
        balanceAfter: 600,
        description: 'Purchase',
        status: 'completed',
        createdAt: '2025-01-01T00:00:00Z',
      );
      const b = TransactionResponse(
        id: 'tx-001',
        tenantId: 'tenant-001',
        walletId: 'wallet-001',
        transactionType: 'credit',
        amountCoins: 100,
        balanceAfter: 600,
        description: 'Purchase',
        status: 'completed',
        createdAt: '2025-01-01T00:00:00Z',
      );
      const c = TransactionResponse(
        id: 'tx-999',
        tenantId: 'tenant-001',
        walletId: 'wallet-001',
        transactionType: 'credit',
        amountCoins: 100,
        balanceAfter: 600,
        description: 'Purchase',
        status: 'completed',
        createdAt: '2025-01-01T00:00:00Z',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      const original = TransactionResponse(
        id: 'tx-001',
        tenantId: 'tenant-001',
        walletId: 'wallet-001',
        transactionType: 'credit',
        amountCoins: 100,
        balanceAfter: 600,
        description: 'Coin purchase',
        status: 'completed',
        createdAt: '2025-01-01T00:00:00Z',
        provider: 'stripe',
      );
      final roundTripped = TransactionResponse.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
