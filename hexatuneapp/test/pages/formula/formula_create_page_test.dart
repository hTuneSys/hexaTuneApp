// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

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
import 'package:hexatuneapp/src/core/rest/formula/models/create_formula_request.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/formula_response.dart';
import 'package:hexatuneapp/src/core/rest/inventory/inventory_repository.dart';
import 'package:hexatuneapp/src/core/rest/inventory/models/inventory_response.dart';
import 'package:hexatuneapp/src/pages/formula/formula_create_page.dart';

class MockFormulaRepository extends Mock implements FormulaRepository {}

class MockInventoryRepository extends Mock implements InventoryRepository {}

class MockLogService extends Mock implements LogService {}

const _emptyPagination = PaginationMeta(
  hasMore: false,
  limit: 20,
  nextCursor: null,
);

const _testInventories = [
  InventoryResponse(
    id: 'inv-001',
    categoryId: 'cat-001',
    name: 'Lavender Oil',
    labels: ['essential'],
    imageUploaded: false,
    createdAt: '2025-01-01T00:00:00Z',
    updatedAt: '2025-01-01T00:00:00Z',
    description: 'Pure lavender',
  ),
  InventoryResponse(
    id: 'inv-002',
    categoryId: 'cat-001',
    name: 'Rose Oil',
    labels: ['floral'],
    imageUploaded: false,
    createdAt: '2025-01-02T00:00:00Z',
    updatedAt: '2025-01-02T00:00:00Z',
  ),
];

const _testFormula = FormulaResponse(
  id: 'frm-001',
  name: 'Test Formula',
  labels: ['test'],
  createdAt: '2025-01-01T00:00:00Z',
  updatedAt: '2025-01-01T00:00:00Z',
);

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const FormulaCreatePage(),
  );
}

void main() {
  late MockFormulaRepository mockFormulaRepo;
  late MockInventoryRepository mockInvRepo;
  late MockLogService mockLog;

  setUpAll(() {
    registerFallbackValue(const PaginationParams());
    registerFallbackValue(const CreateFormulaRequest(name: ''));
  });

  setUp(() {
    mockFormulaRepo = MockFormulaRepository();
    mockInvRepo = MockInventoryRepository();
    mockLog = MockLogService();

    when(() => mockInvRepo.list(params: any(named: 'params'))).thenAnswer(
      (_) async => PaginatedResponse(
        data: _testInventories,
        pagination: _emptyPagination,
      ),
    );
    when(
      () => mockFormulaRepo.create(any()),
    ).thenAnswer((_) async => _testFormula);
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

  group('FormulaCreatePage', () {
    testWidgets('renders appbar with "Create Formula" title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Create Formula'), findsOneWidget);
    });

    testWidgets('shows name, description, labels, and inventory fields', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Labels'), findsOneWidget);
      expect(find.text('Add Inventory'), findsOneWidget);
    });

    testWidgets('shows name hint text', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Enter formula name'), findsOneWidget);
    });

    testWidgets('shows description hint text', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Enter a short description'), findsOneWidget);
    });

    testWidgets('validates empty name field on submit', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.dragUntilVisible(
        find.widgetWithText(FilledButton, 'Create'),
        find.byType(SingleChildScrollView),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(FilledButton, 'Create'));
      await tester.pumpAndSettle();

      expect(find.text('Name is required'), findsOneWidget);
    });

    testWidgets('create button exists', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(FilledButton, 'Create'), findsOneWidget);
    });

    testWidgets('label add button adds chip', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final labelField = find.widgetWithText(TextField, 'Add labels');
      await tester.enterText(labelField, 'my-label');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(find.widgetWithText(Chip, 'my-label'), findsOneWidget);
    });

    testWidgets('label chip can be removed', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final labelField = find.widgetWithText(TextField, 'Add labels');
      await tester.enterText(labelField, 'removable');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(find.widgetWithText(Chip, 'removable'), findsOneWidget);

      final deleteIcon = find.descendant(
        of: find.widgetWithText(Chip, 'removable'),
        matching: find.byIcon(Icons.cancel),
      );
      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();

      expect(find.widgetWithText(Chip, 'removable'), findsNothing);
    });

    testWidgets('inventory search field shows suggestions', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final searchField = find.widgetWithText(
        TextField,
        'Search inventory to add',
      );
      await tester.enterText(searchField, 'Lav');
      await tester.pumpAndSettle();

      expect(find.text('Lavender Oil'), findsOneWidget);
    });

    testWidgets('duplicate labels are not added', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final labelField = find.widgetWithText(TextField, 'Add labels');

      await tester.enterText(labelField, 'unique');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      await tester.enterText(labelField, 'unique');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(find.widgetWithText(Chip, 'unique'), findsOneWidget);
    });
  });
}
