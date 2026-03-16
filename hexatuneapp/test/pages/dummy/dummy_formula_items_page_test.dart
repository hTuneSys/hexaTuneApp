// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/models/paginated_response.dart';
import 'package:hexatuneapp/src/core/network/models/pagination_meta.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';
import 'package:hexatuneapp/src/core/rest/formula/formula_repository.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/add_formula_item_entry.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/add_formula_items_request.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/formula_detail_response.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/formula_item_response.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/reorder_entry.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/reorder_formula_items_request.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/update_formula_item_quantity_request.dart';
import 'package:hexatuneapp/src/core/rest/inventory/inventory_repository.dart';
import 'package:hexatuneapp/src/core/rest/inventory/models/inventory_response.dart';
import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_formula_items_page.dart';

class MockFormulaRepository extends Mock implements FormulaRepository {}

class MockInventoryRepository extends Mock implements InventoryRepository {}

class MockLogService extends Mock implements LogService {}

// inventoryId must be >= 12 chars for substring(0, 12) in the page
const _testDetail = FormulaDetailResponse(
  id: 'frm-001',
  name: 'Test Formula',
  labels: ['test'],
  items: [
    FormulaItemResponse(
      id: 'item-001',
      inventoryId: 'inv-001-abcdef',
      sortOrder: 0,
      quantity: 2,
      timeMs: 1000,
    ),
    FormulaItemResponse(
      id: 'item-002',
      inventoryId: 'inv-002-abcdef',
      sortOrder: 1,
      quantity: 3,
      timeMs: 2000,
    ),
  ],
  createdAt: '2025-01-01T00:00:00Z',
  updatedAt: '2025-01-01T00:00:00Z',
);

const _emptyPagination = PaginationMeta(
  hasMore: false,
  limit: 100,
  nextCursor: null,
);

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const DummyFormulaItemsPage(formulaId: 'frm-001'),
  );
}

void main() {
  late MockFormulaRepository mockRepo;
  late MockInventoryRepository mockInvRepo;
  late MockLogService mockLog;

  setUpAll(() {
    registerFallbackValue(
      const AddFormulaItemsRequest(
        items: [
          AddFormulaItemEntry(inventoryId: '', quantity: 1, timeMs: 1000),
        ],
      ),
    );
    registerFallbackValue(const UpdateFormulaItemQuantityRequest(quantity: 1));
    registerFallbackValue(
      const ReorderFormulaItemsRequest(
        items: [ReorderEntry(itemId: '', sortOrder: 0)],
      ),
    );
    registerFallbackValue(const PaginationParams(limit: 10));
  });

  setUp(() {
    mockRepo = MockFormulaRepository();
    mockInvRepo = MockInventoryRepository();
    mockLog = MockLogService();

    when(
      () => mockRepo.getById('frm-001'),
    ).thenAnswer((_) async => _testDetail);
    when(
      () => mockRepo.addItems(any(), any()),
    ).thenAnswer((_) async => _testDetail.items);
    when(() => mockRepo.removeItem(any(), any())).thenAnswer((_) async {});
    when(
      () => mockRepo.updateItemQuantity(any(), any(), any()),
    ).thenAnswer((_) async => _testDetail.items[0]);
    when(() => mockRepo.reorderItems(any(), any())).thenAnswer((_) async {});
    when(() => mockInvRepo.list(params: any(named: 'params'))).thenAnswer(
      (_) async => PaginatedResponse(
        data: const [
          InventoryResponse(
            id: 'inv-003',
            categoryId: 'cat-001',
            name: 'Available Item',
            labels: [],
            imageUploaded: false,
            createdAt: '2025-01-01T00:00:00Z',
            updatedAt: '2025-01-01T00:00:00Z',
          ),
        ],
        pagination: _emptyPagination,
      ),
    );
    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);

    getIt.allowReassignment = true;
    getIt.registerSingleton<FormulaRepository>(mockRepo);
    getIt.registerSingleton<InventoryRepository>(mockInvRepo);
    getIt.registerSingleton<LogService>(mockLog);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('DummyFormulaItemsPage', () {
    testWidgets('shows loading indicator while data loads', (tester) async {
      final completer = Completer<FormulaDetailResponse>();
      when(
        () => mockRepo.getById('frm-001'),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(_testDetail);
      await tester.pumpAndSettle();
    });

    testWidgets('renders formula name in app bar after load', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Test Formula'), findsOneWidget);
    });

    testWidgets('renders formula items list', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('inv-001'), findsOneWidget);
      expect(find.textContaining('inv-002'), findsOneWidget);
      expect(find.textContaining('Qty: 2'), findsOneWidget);
      expect(find.textContaining('Qty: 3'), findsOneWidget);
    });

    testWidgets('shows FAB for adding items', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('refresh button reloads data', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      verify(() => mockRepo.getById('frm-001')).called(greaterThan(1));
    });

    testWidgets('shows item count text', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('2 items'), findsOneWidget);
    });

    testWidgets('handles load error gracefully', (tester) async {
      when(
        () => mockRepo.getById('frm-001'),
      ).thenAnswer((_) async => throw Exception('Network error'));

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
