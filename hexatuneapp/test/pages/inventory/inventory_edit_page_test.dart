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
import 'package:hexatuneapp/src/core/rest/category/category_repository.dart';
import 'package:hexatuneapp/src/core/rest/category/models/category_response.dart';
import 'package:hexatuneapp/src/core/rest/category/models/create_category_request.dart';
import 'package:hexatuneapp/src/core/rest/inventory/inventory_repository.dart';
import 'package:hexatuneapp/src/core/rest/inventory/models/inventory_response.dart';
import 'package:hexatuneapp/src/pages/inventory/inventory_edit_page.dart';

class MockInventoryRepository extends Mock implements InventoryRepository {}

class MockCategoryRepository extends Mock implements CategoryRepository {}

class MockLogService extends Mock implements LogService {}

const _emptyPagination = PaginationMeta(
  hasMore: false,
  limit: 20,
  nextCursor: null,
);

const _testCategory = CategoryResponse(
  id: 'cat-001',
  name: 'Test Category',
  labels: ['test'],
  createdAt: '2025-01-01T00:00:00Z',
  updatedAt: '2025-01-01T00:00:00Z',
);

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
    home: const InventoryEditPage(inventoryId: 'inv-001'),
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

    when(
      () => mockRepo.getById('inv-001'),
    ).thenAnswer((_) async => _testInventory);
    when(() => mockCatRepo.list(params: any(named: 'params'))).thenAnswer(
      (_) async => PaginatedResponse(
        data: [_testCategory],
        pagination: _emptyPagination,
      ),
    );
    when(
      () => mockRepo.update(
        any(),
        categoryId: any(named: 'categoryId'),
        name: any(named: 'name'),
        description: any(named: 'description'),
        labels: any(named: 'labels'),
        imageBytes: any(named: 'imageBytes'),
      ),
    ).thenAnswer((_) async => _testInventory);
    when(() => mockRepo.delete(any())).thenAnswer((_) async {});
    when(
      () => mockCatRepo.create(any()),
    ).thenAnswer((_) async => _testCategory);
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

  group('InventoryEditPage', () {
    testWidgets('renders appbar with "Edit Inventory" title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Edit Inventory'), findsOneWidget);
    });

    testWidgets('shows loading indicator while fetching', (tester) async {
      final completer = Completer<InventoryResponse>();
      when(
        () => mockRepo.getById('inv-001'),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(_testInventory);
      await tester.pumpAndSettle();
    });

    testWidgets('pre-fills name field with inventory data', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final nameField = find.widgetWithText(
        TextFormField,
        'Enter inventory name',
      );
      expect(nameField, findsOneWidget);

      final field = tester.widget<TextFormField>(nameField);
      expect(field.controller?.text, equals('Test Inventory'));
    });

    testWidgets('shows labels as chips', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(Chip, 'label1'), findsOneWidget);
    });

    testWidgets('delete and save buttons exist', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(FilledButton, 'Delete'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Save'), findsOneWidget);
    });

    testWidgets('shows category field with selected category', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Test Category'), findsOneWidget);
    });
  });
}
