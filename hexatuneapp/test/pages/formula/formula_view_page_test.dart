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
import 'package:hexatuneapp/src/core/rest/formula/formula_repository.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/formula_detail_response.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/formula_item_response.dart';
import 'package:hexatuneapp/src/core/rest/inventory/inventory_repository.dart';
import 'package:hexatuneapp/src/core/rest/inventory/models/inventory_response.dart';
import 'package:hexatuneapp/src/pages/formula/formula_view_page.dart';

class MockFormulaRepository extends Mock implements FormulaRepository {}

class MockInventoryRepository extends Mock implements InventoryRepository {}

class MockLogService extends Mock implements LogService {}

const _emptyPagination = PaginationMeta(
  hasMore: false,
  limit: 20,
  nextCursor: null,
);

const _testInventory = InventoryResponse(
  id: 'inv-001',
  categoryId: 'cat-001',
  name: 'Lavender Oil',
  labels: ['essential'],
  imageUploaded: false,
  createdAt: '2025-01-01T00:00:00Z',
  updatedAt: '2025-01-01T00:00:00Z',
);

const _testFormulaWithLabels = FormulaDetailResponse(
  id: 'frm-001',
  name: 'Herbal Blend',
  labels: ['herbal', 'relaxing'],
  items: [
    FormulaItemResponse(
      id: 'item-001',
      inventoryId: 'inv-001',
      sortOrder: 0,
      quantity: 3,
      timeMs: 500,
      createdAt: '2025-01-01T00:00:00Z',
    ),
  ],
  createdAt: '2025-01-01T00:00:00Z',
  updatedAt: '2025-01-01T00:00:00Z',
);

const _testFormulaNoLabels = FormulaDetailResponse(
  id: 'frm-002',
  name: 'Empty Labels Formula',
  labels: [],
  items: [
    FormulaItemResponse(
      id: 'item-002',
      inventoryId: 'inv-001',
      sortOrder: 0,
      quantity: 1,
      timeMs: 200,
      createdAt: '2025-01-02T00:00:00Z',
    ),
  ],
  createdAt: '2025-01-02T00:00:00Z',
  updatedAt: '2025-01-02T00:00:00Z',
);

const _testFormulaNoItems = FormulaDetailResponse(
  id: 'frm-003',
  name: 'No Items Formula',
  labels: ['empty'],
  items: [],
  createdAt: '2025-01-03T00:00:00Z',
  updatedAt: '2025-01-03T00:00:00Z',
);

Widget _buildApp({String formulaId = 'frm-001'}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: FormulaViewPage(formulaId: formulaId),
  );
}

void main() {
  late MockFormulaRepository mockFormulaRepo;
  late MockInventoryRepository mockInvRepo;
  late MockLogService mockLog;

  setUpAll(() {
    registerFallbackValue(const PaginationParams());
  });

  setUp(() {
    mockFormulaRepo = MockFormulaRepository();
    mockInvRepo = MockInventoryRepository();
    mockLog = MockLogService();

    when(
      () => mockFormulaRepo.getById('frm-001'),
    ).thenAnswer((_) async => _testFormulaWithLabels);
    when(
      () => mockFormulaRepo.getById('frm-002'),
    ).thenAnswer((_) async => _testFormulaNoLabels);
    when(
      () => mockFormulaRepo.getById('frm-003'),
    ).thenAnswer((_) async => _testFormulaNoItems);
    when(() => mockInvRepo.list(params: any(named: 'params'))).thenAnswer(
      (_) async => PaginatedResponse(
        data: [_testInventory],
        pagination: _emptyPagination,
      ),
    );
    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);

    getIt.allowReassignment = true;
    getIt.registerSingleton<FormulaRepository>(mockFormulaRepo);
    getIt.registerSingleton<InventoryRepository>(mockInvRepo);
    getIt.registerSingleton<LogService>(mockLog);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('FormulaViewPage', () {
    testWidgets('renders appbar with "View Formula" title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('View Formula'), findsOneWidget);
    });

    testWidgets('shows loading indicator while fetching', (tester) async {
      final completer = Completer<FormulaDetailResponse>();
      when(
        () => mockFormulaRepo.getById('frm-001'),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(_testFormulaWithLabels);
      await tester.pumpAndSettle();
    });

    testWidgets('displays formula name', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Herbal Blend'), findsOneWidget);
    });

    testWidgets('displays labels as chips', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(Chip, 'herbal'), findsOneWidget);
      expect(find.widgetWithText(Chip, 'relaxing'), findsOneWidget);
    });

    testWidgets('displays inventory item name', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Lavender Oil'), findsOneWidget);
    });

    testWidgets('displays item quantity', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('shows "No labels" when labels are empty', (tester) async {
      await tester.pumpWidget(_buildApp(formulaId: 'frm-002'));
      await tester.pumpAndSettle();

      expect(find.text('No labels'), findsOneWidget);
    });

    testWidgets('shows placeholder when no items', (tester) async {
      await tester.pumpWidget(_buildApp(formulaId: 'frm-003'));
      await tester.pumpAndSettle();

      // The page shows a dash when no items are present
      expect(find.text('—'), findsWidgets);
    });

    testWidgets('shows section labels for name, description, labels', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Labels'), findsOneWidget);
      expect(find.text('Added inventory'), findsOneWidget);
    });

    testWidgets('shows inventory icon for items', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.inventory_2_outlined), findsOneWidget);
    });

    testWidgets('shows harmonize button at bottom', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.join_inner), findsOneWidget);
      expect(find.text('Harmonize'), findsOneWidget);
    });
  });
}
