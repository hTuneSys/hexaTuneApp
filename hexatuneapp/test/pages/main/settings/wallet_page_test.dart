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
import 'package:hexatuneapp/src/core/network/pagination_params.dart';
import 'package:hexatuneapp/src/core/payment/iap_service.dart';
import 'package:hexatuneapp/src/core/payment/models/iap_product.dart';
import 'package:hexatuneapp/src/core/payment/models/iap_status.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/transaction_response.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/wallet_balance_response.dart';
import 'package:hexatuneapp/src/core/rest/wallet/wallet_repository.dart';
import 'package:hexatuneapp/src/pages/main/settings/wallet_page.dart';

class MockWalletRepository extends Mock implements WalletRepository {}

class MockIapService extends Mock implements IapService {}

class MockLogService extends Mock implements LogService {}

const _testBalance = WalletBalanceResponse(
  tenantId: 'tenant-1',
  balanceCoins: 100,
  totalPurchased: 200,
  totalSpent: 100,
);

const _testTransaction = TransactionResponse(
  id: 'tx-1',
  tenantId: 'tenant-1',
  walletId: 'wallet-1',
  transactionType: 'purchase',
  amountCoins: 50,
  balanceAfter: 150,
  description: 'Bought coins',
  status: 'completed',
  createdAt: '2025-03-01',
);

const _emptyPagination = PaginationMeta(hasMore: false, limit: 20);

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const WalletPage(),
  );
}

void main() {
  late MockWalletRepository mockRepo;
  late MockIapService mockIap;
  late MockLogService mockLog;
  late StreamController<IapStatus> statusController;
  late StreamController<List<IapProduct>> productsController;

  setUpAll(() {
    registerFallbackValue(const PaginationParams());
  });

  setUp(() {
    mockRepo = MockWalletRepository();
    mockIap = MockIapService();
    mockLog = MockLogService();
    statusController = StreamController<IapStatus>.broadcast();
    productsController = StreamController<List<IapProduct>>.broadcast();

    // Stub IapService streams
    when(() => mockIap.statusStream).thenAnswer((_) => statusController.stream);
    when(
      () => mockIap.productsStream,
    ).thenAnswer((_) => productsController.stream);

    // Stub wallet repository
    when(() => mockRepo.getBalance()).thenAnswer((_) async => _testBalance);
    when(
      () => mockRepo.listTransactions(params: any(named: 'params')),
    ).thenAnswer(
      (_) async => PaginatedResponse<TransactionResponse>(
        data: [_testTransaction],
        pagination: _emptyPagination,
      ),
    );

    // Stub IapService methods used by the store section
    when(() => mockIap.loadProducts()).thenAnswer((_) async => <IapProduct>[]);

    // Stub log service
    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);
    when(
      () => mockLog.debug(any(), category: any(named: 'category')),
    ).thenReturn(null);
    when(
      () => mockLog.warning(any(), category: any(named: 'category')),
    ).thenReturn(null);

    // Register DI
    getIt.allowReassignment = true;
    getIt.registerSingleton<WalletRepository>(mockRepo);
    getIt.registerSingleton<IapService>(mockIap);
    getIt.registerSingleton<LogService>(mockLog);
  });

  tearDown(() async {
    statusController.close();
    productsController.close();
    await getIt.reset();
  });

  group('WalletPage', () {
    testWidgets('shows loading indicator initially', (tester) async {
      final completer = Completer<WalletBalanceResponse>();
      when(() => mockRepo.getBalance()).thenAnswer((_) => completer.future);

      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsWidgets);

      completer.complete(_testBalance);
      await tester.pumpAndSettle();
    });

    testWidgets('shows balance info after load', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Balance'), findsOneWidget);
      expect(find.text('100 coins'), findsOneWidget);
      expect(find.text('Purchased'), findsOneWidget);
      expect(find.text('200'), findsOneWidget);
      expect(find.text('Spent'), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
    });

    testWidgets('shows transaction list with type and amount', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Transactions'), findsOneWidget);
      expect(find.text('purchase'), findsOneWidget);
      expect(find.text('50'), findsOneWidget);
    });

    testWidgets('refresh button triggers reload', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Scroll to the store section's Load Products button (Icons.refresh)
      await tester.scrollUntilVisible(find.byIcon(Icons.refresh), 200);
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      verify(() => mockIap.loadProducts()).called(1);
    });

    testWidgets('error handling does not crash', (tester) async {
      when(
        () => mockRepo.getBalance(),
      ).thenAnswer((_) async => throw Exception('Network error'));

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Widget should not crash and no loading indicator should remain
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
