// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/rest/wallet/wallet_repository.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/checkout_response.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/coin_package_response.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/initiate_purchase_request.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/mobile_purchase_request.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/wallet_balance_response.dart';
import 'package:hexatuneapp/src/core/config/api_endpoints.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_client.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockLogService extends Mock implements LogService {}

void main() {
  group('WalletRepository', () {
    late Dio dio;
    late DioAdapter dioAdapter;
    late MockApiClient mockApiClient;
    late MockLogService mockLogService;
    late WalletRepository repository;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://test.api'));
      dioAdapter = DioAdapter(dio: dio);
      mockApiClient = MockApiClient();
      mockLogService = MockLogService();

      when(() => mockApiClient.dio).thenReturn(dio);
      when(
        () => mockLogService.debug(any(), category: any(named: 'category')),
      ).thenReturn(null);

      repository = WalletRepository(mockApiClient, mockLogService);
    });

    group('getBalance', () {
      test('sends GET and returns wallet balance', () async {
        dioAdapter.onGet(
          ApiEndpoints.walletBalance,
          (server) => server.reply(200, {
            'tenantId': 'tenant-001',
            'balanceCoins': 500,
            'totalPurchased': 1000,
            'totalSpent': 500,
          }),
        );

        final result = await repository.getBalance();

        expect(result, isA<WalletBalanceResponse>());
        expect(result.tenantId, 'tenant-001');
        expect(result.balanceCoins, 500);
        expect(result.totalPurchased, 1000);
        expect(result.totalSpent, 500);
      });
    });

    group('listPackages', () {
      test('sends GET and returns package list', () async {
        dioAdapter.onGet(
          ApiEndpoints.walletPackages,
          (server) => server.reply(200, [
            {
              'id': 'pkg-001',
              'name': 'Starter',
              'coins': 100,
              'priceCents': 999,
              'currency': 'USD',
              'sortOrder': 1,
            },
          ]),
        );

        final result = await repository.listPackages();

        expect(result, hasLength(1));
        expect(result.first, isA<CoinPackageResponse>());
        expect(result.first.id, 'pkg-001');
        expect(result.first.coins, 100);
      });

      test('returns empty list when no packages', () async {
        dioAdapter.onGet(
          ApiEndpoints.walletPackages,
          (server) => server.reply(200, []),
        );

        final result = await repository.listPackages();

        expect(result, isEmpty);
      });
    });

    group('listTransactions', () {
      test('sends GET and returns paginated transactions', () async {
        dioAdapter.onGet(
          ApiEndpoints.walletTransactions,
          (server) => server.reply(200, {
            'data': [
              {
                'id': 'tx-001',
                'tenantId': 'tenant-001',
                'walletId': 'wallet-001',
                'transactionType': 'credit',
                'amountCoins': 100,
                'balanceAfter': 600,
                'description': 'Purchase',
                'status': 'completed',
                'createdAt': '2025-01-01T00:00:00Z',
              },
            ],
            'pagination': {'has_more': false, 'limit': 20, 'next_cursor': null},
          }),
        );

        final result = await repository.listTransactions();

        expect(result.data, hasLength(1));
        expect(result.data.first.id, 'tx-001');
        expect(result.data.first.amountCoins, 100);
        expect(result.hasMore, false);
      });
    });

    group('purchaseApple', () {
      test('sends POST to apple purchase endpoint', () async {
        const request = MobilePurchaseRequest(
          packageId: 'pkg-001',
          receiptData: 'receipt-abc',
        );

        dioAdapter.onPost(
          ApiEndpoints.walletPurchaseApple,
          (server) => server.reply(204, null),
          data: request.toJson(),
        );

        await expectLater(repository.purchaseApple(request), completes);
      });
    });

    group('purchaseGoogle', () {
      test('sends POST to google purchase endpoint', () async {
        const request = MobilePurchaseRequest(
          packageId: 'pkg-001',
          receiptData: 'receipt-xyz',
        );

        dioAdapter.onPost(
          ApiEndpoints.walletPurchaseGoogle,
          (server) => server.reply(204, null),
          data: request.toJson(),
        );

        await expectLater(repository.purchaseGoogle(request), completes);
      });
    });

    group('purchaseStripe', () {
      test('sends POST and returns checkout response', () async {
        const request = InitiatePurchaseRequest(packageId: 'pkg-001');

        dioAdapter.onPost(
          ApiEndpoints.walletPurchaseStripe,
          (server) => server.reply(200, {
            'sessionId': 'cs_abc123',
            'checkoutUrl': 'https://checkout.stripe.com/pay/abc',
          }),
          data: request.toJson(),
        );

        final result = await repository.purchaseStripe(request);

        expect(result, isA<CheckoutResponse>());
        expect(result.sessionId, 'cs_abc123');
        expect(result.checkoutUrl, 'https://checkout.stripe.com/pay/abc');
      });
    });
  });
}
