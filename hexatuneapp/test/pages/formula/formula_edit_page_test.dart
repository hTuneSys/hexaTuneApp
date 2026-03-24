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
import 'package:hexatuneapp/src/pages/formula/formula_edit_page.dart';

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

const _testFormulaDetail = FormulaDetailResponse(
  id: 'frm-001',
  name: 'Test Formula',
  labels: ['herbal', 'blend'],
  items: [
    FormulaItemResponse(
      id: 'item-001',
      inventoryId: 'inv-001',
      sortOrder: 0,
      quantity: 5,
      timeMs: 1000,
    ),
  ],
  createdAt: '2025-01-01T00:00:00Z',
  updatedAt: '2025-01-01T00:00:00Z',
);

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const FormulaEditPage(formulaId: 'frm-001'),
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
    ).thenAnswer((_) async => _testFormulaDetail);
    when(() => mockInvRepo.list(params: any(named: 'params'))).thenAnswer(
      (_) async => PaginatedResponse(
        data: [_testInventory],
        pagination: _emptyPagination,
      ),
    );
    when(() => mockFormulaRepo.delete(any())).thenAnswer((_) async {});
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

  group('FormulaEditPage', () {
    testWidgets('renders appbar with "Edit Formula" title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Edit Formula'), findsOneWidget);
    });

    testWidgets('shows loading indicator while fetching', (tester) async {
      final completer = Completer<FormulaDetailResponse>();
      when(
        () => mockFormulaRepo.getById('frm-001'),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(_testFormulaDetail);
      await tester.pumpAndSettle();
    });

    testWidgets('pre-fills name field with formula data', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final nameField = find.widgetWithText(
        TextFormField,
        'Enter formula name',
      );
      expect(nameField, findsOneWidget);

      final field = tester.widget<TextFormField>(nameField);
      expect(field.controller?.text, equals('Test Formula'));
    });

    testWidgets('shows existing labels as chips', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(Chip, 'herbal'), findsOneWidget);
      expect(find.widgetWithText(Chip, 'blend'), findsOneWidget);
    });

    testWidgets('shows existing items with inventory name', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Lavender Oil'), findsOneWidget);
    });

    testWidgets('delete and save buttons exist', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.dragUntilVisible(
        find.widgetWithText(FilledButton, 'Save'),
        find.byType(SingleChildScrollView),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      expect(find.widgetWithText(FilledButton, 'Delete'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Save'), findsOneWidget);
    });

    testWidgets('delete button shows confirmation dialog', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.dragUntilVisible(
        find.widgetWithText(FilledButton, 'Delete'),
        find.byType(SingleChildScrollView),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
        find.text('Are you sure you want to delete Test Formula?'),
        findsOneWidget,
      );
    });

    testWidgets('shows form field section labels', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Labels'), findsOneWidget);
      expect(find.text('Add Inventory'), findsOneWidget);
    });

    testWidgets('shows inventory search field', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(TextField, 'Search inventory to add'),
        findsOneWidget,
      );
    });
  });
}
