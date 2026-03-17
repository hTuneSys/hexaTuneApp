// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/models/paginated_response.dart';
import 'package:hexatuneapp/src/core/network/models/pagination_meta.dart';
import 'package:hexatuneapp/src/core/payment/iap_service.dart';
import 'package:hexatuneapp/src/core/payment/models/iap_product.dart';
import 'package:hexatuneapp/src/core/payment/models/iap_status.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/transaction_response.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/wallet_balance_response.dart';
import 'package:hexatuneapp/src/core/rest/wallet/wallet_repository.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_wallet_page.dart';

class MockWalletRepository extends Mock implements WalletRepository {}

class MockLogService extends Mock implements LogService {}

class MockIapService extends Mock implements IapService {}

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const DummyWalletPage(),
  );
}

void main() {
  late MockWalletRepository mockRepo;
  late MockLogService mockLog;
  late MockIapService mockIap;
  late StreamController<IapStatus> statusController;
  late StreamController<List<IapProduct>> productsController;

  setUp(() {
    mockRepo = MockWalletRepository();
    mockLog = MockLogService();
    mockIap = MockIapService();
    statusController = StreamController<IapStatus>.broadcast();
    productsController = StreamController<List<IapProduct>>.broadcast();

    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);
    when(() => mockIap.statusStream).thenAnswer((_) => statusController.stream);
    when(
      () => mockIap.productsStream,
    ).thenAnswer((_) => productsController.stream);

    getIt.allowReassignment = true;
    getIt.registerSingleton<WalletRepository>(mockRepo);
    getIt.registerSingleton<LogService>(mockLog);
    getIt.registerSingleton<IapService>(mockIap);
  });

  tearDown(() async {
    await statusController.close();
    await productsController.close();
    await getIt.reset();
  });

  group('DummyWalletPage', () {
    testWidgets('shows appbar title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Wallet'), findsOneWidget);
    });

    testWidgets('shows section titles', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Balance'), findsOneWidget);
      expect(find.text('Transactions'), findsOneWidget);
      expect(find.text('Store Products'), findsOneWidget);
    });

    testWidgets('shows action buttons', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Get Balance'), findsOneWidget);
      expect(find.text('List Transactions'), findsOneWidget);
      expect(find.text('Load Products'), findsOneWidget);
    });

    testWidgets('shows IAP status', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Status: idle', skipOffstage: false), findsOneWidget);
    });

    testWidgets('Get Balance calls repo and shows result', (tester) async {
      when(() => mockRepo.getBalance()).thenAnswer(
        (_) async => const WalletBalanceResponse(
          tenantId: 'tenant-001',
          balanceCoins: 500,
          totalPurchased: 1000,
          totalSpent: 500,
        ),
      );

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Get Balance'));
      await tester.pump();

      verify(() => mockRepo.getBalance()).called(1);
      expect(
        find.textContaining('500 coins', skipOffstage: false),
        findsOneWidget,
      );
    });

    testWidgets('List Transactions calls repo and shows result', (
      tester,
    ) async {
      when(
        () => mockRepo.listTransactions(params: any(named: 'params')),
      ).thenAnswer(
        (_) async => PaginatedResponse(
          data: const [
            TransactionResponse(
              id: 'tx-001',
              tenantId: 'tenant-001',
              walletId: 'wallet-001',
              transactionType: 'credit',
              amountCoins: 100,
              balanceAfter: 600,
              description: 'Purchase',
              status: 'completed',
              createdAt: '2025-01-01T00:00:00Z',
            ),
          ],
          pagination: const PaginationMeta(
            hasMore: false,
            limit: 20,
            nextCursor: null,
          ),
        ),
      );

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('List Transactions'));
      await tester.pump();

      verify(() => mockRepo.listTransactions()).called(1);
      expect(
        find.textContaining('1 transactions', skipOffstage: false),
        findsOneWidget,
      );
    });

    testWidgets('Load Products calls IapService and shows result', (
      tester,
    ) async {
      when(() => mockIap.loadProducts()).thenAnswer(
        (_) async => const [
          IapProduct(
            packageId: 'pkg-001',
            name: 'Starter',
            coins: 100,
            storeProductId: 'com.hexatune.coins100',
            price: r'$0.99',
            rawPrice: 0.99,
            currencyCode: 'USD',
          ),
        ],
      );
      when(() => mockIap.isAvailable).thenReturn(true);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Load Products'));
      await tester.pump();

      verify(() => mockIap.loadProducts()).called(1);
      expect(
        find.textContaining('Starter', skipOffstage: false),
        findsOneWidget,
      );
    });

    testWidgets('product cards appear when products stream emits', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsNothing);

      productsController.add(const [
        IapProduct(
          packageId: 'pkg-001',
          name: 'Starter Pack',
          coins: 100,
          storeProductId: 'com.hexatune.coins100',
          price: r'$0.99',
          rawPrice: 0.99,
          currencyCode: 'USD',
        ),
      ]);
      await tester.pumpAndSettle();

      expect(find.text('Starter Pack', skipOffstage: false), findsOneWidget);
      expect(find.text('100 coins', skipOffstage: false), findsOneWidget);
      expect(find.text(r'$0.99', skipOffstage: false), findsOneWidget);
    });

    testWidgets('shows loading indicator during operation', (tester) async {
      final completer = Completer<WalletBalanceResponse>();
      when(() => mockRepo.getBalance()).thenAnswer((_) => completer.future);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Get Balance'));
      await tester.pump();

      expect(
        find.byType(CircularProgressIndicator, skipOffstage: false),
        findsOneWidget,
      );

      completer.complete(
        const WalletBalanceResponse(
          tenantId: 't',
          balanceCoins: 0,
          totalPurchased: 0,
          totalSpent: 0,
        ),
      );
      await tester.pumpAndSettle();
    });

    testWidgets('shows error message on failure', (tester) async {
      when(
        () => mockRepo.getBalance(),
      ).thenAnswer((_) async => throw Exception('Network error'));

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Get Balance'));
      await tester.pump();

      expect(
        find.textContaining('Network error', skipOffstage: false),
        findsOneWidget,
      );
    });
  });
}
