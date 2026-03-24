// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/rest/category/category_repository.dart';
import 'package:hexatuneapp/src/core/rest/category/models/category_response.dart';
import 'package:hexatuneapp/src/core/rest/inventory/inventory_repository.dart';
import 'package:hexatuneapp/src/core/rest/inventory/models/inventory_response.dart';
import 'package:hexatuneapp/src/pages/inventory/inventory_view_page.dart';

class MockInventoryRepository extends Mock implements InventoryRepository {}

class MockCategoryRepository extends Mock implements CategoryRepository {}

class MockLogService extends Mock implements LogService {}

const _testCategory = CategoryResponse(
  id: 'cat-001',
  name: 'Test Category',
  labels: ['test'],
  createdAt: '2025-01-01T00:00:00Z',
  updatedAt: '2025-01-01T00:00:00Z',
);

const _testInventoryWithLabels = InventoryResponse(
  id: 'inv-001',
  categoryId: 'cat-001',
  name: 'Test Inventory',
  labels: ['alpha', 'test'],
  imageUploaded: false,
  createdAt: '2025-01-01T00:00:00Z',
  updatedAt: '2025-01-01T00:00:00Z',
  description: 'Test description',
);

const _testInventoryNoLabels = InventoryResponse(
  id: 'inv-002',
  categoryId: 'cat-001',
  name: 'Empty Inventory',
  labels: [],
  imageUploaded: false,
  createdAt: '2025-01-02T00:00:00Z',
  updatedAt: '2025-01-02T00:00:00Z',
);

Widget _buildApp({String inventoryId = 'inv-001'}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: InventoryViewPage(inventoryId: inventoryId),
  );
}

void main() {
  late MockInventoryRepository mockRepo;
  late MockCategoryRepository mockCatRepo;
  late MockLogService mockLog;

  setUp(() {
    mockRepo = MockInventoryRepository();
    mockCatRepo = MockCategoryRepository();
    mockLog = MockLogService();

    when(
      () => mockRepo.getById('inv-001'),
    ).thenAnswer((_) async => _testInventoryWithLabels);
    when(
      () => mockRepo.getById('inv-002'),
    ).thenAnswer((_) async => _testInventoryNoLabels);
    when(
      () => mockCatRepo.getById('cat-001'),
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

  group('InventoryViewPage', () {
    testWidgets('renders appbar with "View Inventory" title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('View Inventory'), findsOneWidget);
    });

    testWidgets('shows loading indicator while fetching', (tester) async {
      final completer = Completer<InventoryResponse>();
      when(
        () => mockRepo.getById('inv-001'),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(_testInventoryWithLabels);
      await tester.pumpAndSettle();
    });

    testWidgets('displays inventory name', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Test Inventory'), findsOneWidget);
    });

    testWidgets('displays inventory description', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Test description'), findsOneWidget);
    });

    testWidgets('displays category name', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Test Category'), findsOneWidget);
    });

    testWidgets('displays labels as chips', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(Chip, 'alpha'), findsOneWidget);
      expect(find.widgetWithText(Chip, 'test'), findsOneWidget);
    });

    testWidgets('shows "No labels" when labels are empty', (tester) async {
      await tester.pumpWidget(_buildApp(inventoryId: 'inv-002'));
      await tester.pumpAndSettle();

      expect(find.text('No labels'), findsOneWidget);
    });

    testWidgets('shows image area', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
    });
  });
}
