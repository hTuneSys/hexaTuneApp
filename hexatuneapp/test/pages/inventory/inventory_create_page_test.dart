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
import 'package:hexatuneapp/src/core/rest/category/category_repository.dart';
import 'package:hexatuneapp/src/core/rest/category/models/category_response.dart';
import 'package:hexatuneapp/src/core/rest/category/models/create_category_request.dart';
import 'package:hexatuneapp/src/core/rest/inventory/inventory_repository.dart';
import 'package:hexatuneapp/src/core/rest/inventory/models/inventory_response.dart';
import 'package:hexatuneapp/src/pages/inventory/inventory_create_page.dart';

class MockInventoryRepository extends Mock implements InventoryRepository {}

class MockCategoryRepository extends Mock implements CategoryRepository {}

class MockLogService extends Mock implements LogService {}

const _emptyPagination = PaginationMeta(
  hasMore: false,
  limit: 20,
  nextCursor: null,
);

const _testCategories = [
  CategoryResponse(
    id: 'cat-001',
    name: 'Test Category',
    labels: ['test'],
    createdAt: '2025-01-01T00:00:00Z',
    updatedAt: '2025-01-01T00:00:00Z',
  ),
];

const _testInventory = InventoryResponse(
  id: 'inv-001',
  categoryId: 'cat-001',
  name: 'Test Inventory',
  labels: ['label1'],
  imageUploaded: false,
  createdAt: '2025-01-01T00:00:00Z',
  updatedAt: '2025-01-01T00:00:00Z',
  description: 'Test description',
);

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const InventoryCreatePage(),
  );
}

void main() {
  late MockInventoryRepository mockRepo;
  late MockCategoryRepository mockCatRepo;
  late MockLogService mockLog;

  setUpAll(() {
    registerFallbackValue(const PaginationParams());
    registerFallbackValue(const CreateCategoryRequest(name: ''));
  });

  setUp(() {
    mockRepo = MockInventoryRepository();
    mockCatRepo = MockCategoryRepository();
    mockLog = MockLogService();

    when(() => mockCatRepo.list(params: any(named: 'params'))).thenAnswer(
      (_) async => PaginatedResponse(
        data: _testCategories,
        pagination: _emptyPagination,
      ),
    );
    when(
      () => mockCatRepo.create(any()),
    ).thenAnswer((_) async => _testCategories[0]);
    when(
      () => mockRepo.create(
        categoryId: any(named: 'categoryId'),
        name: any(named: 'name'),
        description: any(named: 'description'),
        labels: any(named: 'labels'),
        imageBytes: any(named: 'imageBytes'),
      ),
    ).thenAnswer((_) async => _testInventory);
    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);

    getIt.allowReassignment = true;
    getIt.registerSingleton<InventoryRepository>(mockRepo);
    getIt.registerSingleton<CategoryRepository>(mockCatRepo);
    getIt.registerSingleton<LogService>(mockLog);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('InventoryCreatePage', () {
    testWidgets('renders appbar with "Create Inventory" title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Create Inventory'), findsOneWidget);
    });

    testWidgets('shows image placeholder area', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Add Image'), findsOneWidget);
    });

    testWidgets('shows name, description, category, labels fields', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Category'), findsOneWidget);
      expect(find.text('Labels'), findsOneWidget);
    });

    testWidgets('category field shows "Select category" hint', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Select category'), findsOneWidget);
    });

    testWidgets(
      'tapping category field opens bottom sheet with category list',
      (tester) async {
        await tester.pumpWidget(_buildApp());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Select category'));
        await tester.pumpAndSettle();

        expect(find.text('Test Category'), findsAtLeast(1));
      },
    );

    testWidgets('shows Add New field in category picker', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select category'));
      await tester.pumpAndSettle();

      expect(find.text('Add New'), findsOneWidget);
    });

    testWidgets('label add button adds chip', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final labelField = find.widgetWithText(TextField, 'Add labels');
      await tester.enterText(labelField, 'new-label');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(find.widgetWithText(Chip, 'new-label'), findsOneWidget);
    });

    testWidgets('create button exists', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(FilledButton, 'Create'), findsOneWidget);
    });

    testWidgets('validates empty name field', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Scroll down to make the create button visible
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
  });
}
