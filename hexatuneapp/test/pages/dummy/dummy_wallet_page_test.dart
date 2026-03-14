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
import 'package:hexatuneapp/src/core/rest/wallet/models/checkout_response.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/coin_package_response.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/initiate_purchase_request.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/mobile_purchase_request.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/transaction_response.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/wallet_balance_response.dart';
import 'package:hexatuneapp/src/core/rest/wallet/wallet_repository.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_wallet_page.dart';

class MockWalletRepository extends Mock implements WalletRepository {}

class MockLogService extends Mock implements LogService {}

class FakeInitiatePurchaseRequest extends Fake
    implements InitiatePurchaseRequest {}

class FakeMobilePurchaseRequest extends Fake implements MobilePurchaseRequest {}

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

  setUpAll(() {
    registerFallbackValue(FakeInitiatePurchaseRequest());
    registerFallbackValue(FakeMobilePurchaseRequest());
  });

  setUp(() {
    mockRepo = MockWalletRepository();
    mockLog = MockLogService();

    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);

    getIt.allowReassignment = true;
    getIt.registerSingleton<WalletRepository>(mockRepo);
    getIt.registerSingleton<LogService>(mockLog);
  });

  tearDown(() async {
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
      expect(find.text('Coin Packages'), findsOneWidget);
      expect(find.text('Transactions'), findsOneWidget);
      expect(find.text('Purchase'), findsOneWidget);
    });

    testWidgets('shows action buttons', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Get Balance'), findsOneWidget);
      expect(find.text('List Packages'), findsOneWidget);
      expect(find.text('List Transactions'), findsOneWidget);
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Google'), findsOneWidget);
      expect(find.text('Stripe'), findsOneWidget);
    });

    testWidgets('shows text fields for purchase', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Package ID'), findsOneWidget);
      expect(find.text('Receipt Data (Apple/Google)'), findsOneWidget);
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

    testWidgets('List Packages calls repo and shows result', (tester) async {
      when(() => mockRepo.listPackages()).thenAnswer(
        (_) async => const [
          CoinPackageResponse(
            id: 'pkg-001',
            name: 'Starter',
            coins: 100,
            priceCents: 999,
            currency: 'USD',
            sortOrder: 1,
          ),
        ],
      );

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('List Packages'));
      await tester.pump();

      verify(() => mockRepo.listPackages()).called(1);
      expect(
        find.textContaining('Starter', skipOffstage: false),
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

    testWidgets('Stripe purchase calls repo and shows result', (tester) async {
      when(() => mockRepo.purchaseStripe(any())).thenAnswer(
        (_) async => const CheckoutResponse(
          sessionId: 'cs_abc',
          checkoutUrl: 'https://checkout.stripe.com/pay/abc',
        ),
      );

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Stripe'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(find.byType(TextField).first, 'pkg-001');
      await tester.tap(find.text('Stripe'));
      await tester.pump();

      verify(() => mockRepo.purchaseStripe(any())).called(1);
      expect(
        find.textContaining('cs_abc', skipOffstage: false),
        findsOneWidget,
      );
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
