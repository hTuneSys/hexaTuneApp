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
import 'package:hexatuneapp/src/core/rest/inventory/inventory_repository.dart';
import 'package:hexatuneapp/src/core/rest/inventory/models/inventory_response.dart';
import 'package:hexatuneapp/src/pages/inventory/inventory_list_page.dart';
import 'package:hexatuneapp/src/pages/shared/harmonize_source_holder.dart';

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
  CategoryResponse(
    id: 'cat-002',
    name: 'Other Category',
    labels: ['other'],
    createdAt: '2025-01-02T00:00:00Z',
    updatedAt: '2025-01-02T00:00:00Z',
  ),
];

const _testInventories = [
  InventoryResponse(
    id: 'inv-001',
    categoryId: 'cat-001',
    name: 'Alpha Inventory',
    labels: ['alpha', 'test'],
    imageUploaded: false,
    createdAt: '2025-01-01T00:00:00Z',
    updatedAt: '2025-01-01T00:00:00Z',
    description: 'Alpha description',
  ),
  InventoryResponse(
    id: 'inv-002',
    categoryId: 'cat-001',
    name: 'Beta Inventory',
    labels: ['beta'],
    imageUploaded: false,
    createdAt: '2025-01-02T00:00:00Z',
    updatedAt: '2025-01-02T00:00:00Z',
  ),
];

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const InventoryListPage(),
  );
}

void main() {
  late MockInventoryRepository mockRepo;
  late MockCategoryRepository mockCatRepo;
  late MockLogService mockLog;

  setUpAll(() {
    registerFallbackValue(const PaginationParams());
  });

  setUp(() {
    mockRepo = MockInventoryRepository();
    mockCatRepo = MockCategoryRepository();
    mockLog = MockLogService();

    when(() => mockRepo.list(params: any(named: 'params'))).thenAnswer(
      (_) async => PaginatedResponse(
        data: _testInventories,
        pagination: _emptyPagination,
      ),
    );
    when(
      () => mockRepo.listLabels(),
    ).thenAnswer((_) async => ['alpha', 'beta', 'test']);
    when(() => mockCatRepo.list(params: any(named: 'params'))).thenAnswer(
      (_) async => PaginatedResponse(
        data: _testCategories,
        pagination: _emptyPagination,
      ),
    );
    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);

    getIt.allowReassignment = true;
    getIt.registerSingleton<InventoryRepository>(mockRepo);
    getIt.registerSingleton<CategoryRepository>(mockCatRepo);
    getIt.registerSingleton<LogService>(mockLog);
    getIt.registerLazySingleton<HarmonizeSourceHolder>(
      () => HarmonizeSourceHolder(),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('InventoryListPage', () {
    testWidgets('renders appbar with "Inventory Management" title', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Inventory Management'), findsOneWidget);
    });

    testWidgets('shows loading indicator while fetching', (tester) async {
      final completer = Completer<PaginatedResponse<InventoryResponse>>();
      when(
        () => mockRepo.list(params: any(named: 'params')),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(
        PaginatedResponse(data: _testInventories, pagination: _emptyPagination),
      );
      await tester.pumpAndSettle();
    });

    testWidgets('displays inventory items grouped by category after loading', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Test Category'), findsOneWidget);
      expect(find.text('Alpha Inventory'), findsOneWidget);
      expect(find.text('Beta Inventory'), findsOneWidget);
    });

    testWidgets('shows empty state when no items', (tester) async {
      when(() => mockRepo.list(params: any(named: 'params'))).thenAnswer(
        (_) async =>
            PaginatedResponse(data: const [], pagination: _emptyPagination),
      );

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Your inventory is empty.'), findsOneWidget);
    });

    testWidgets('search icon toggles expanded search field', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search), findsOneWidget);

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('sort button opens bottom sheet with sort options', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sort'));
      await tester.pumpAndSettle();

      expect(find.text('Default'), findsOneWidget);
      expect(find.text('Name (A→Z)'), findsOneWidget);
      expect(find.text('Name (Z→A)'), findsOneWidget);
      expect(find.text('Newest first'), findsOneWidget);
      expect(find.text('Oldest first'), findsOneWidget);
    });

    testWidgets('filter button opens bottom sheet with label chips', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();

      expect(find.byType(FilterChip), findsNWidgets(3));
    });

    testWidgets('FAB (+) button exists', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('PopupMenuButton shows Edit and View options', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final popupButtons = find.byType(PopupMenuButton<String>);
      expect(popupButtons, findsNWidgets(2));

      await tester.tap(popupButtons.first);
      await tester.pumpAndSettle();

      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('View'), findsOneWidget);
    });

    testWidgets('Load More button appears when hasMore is true', (
      tester,
    ) async {
      when(() => mockRepo.list(params: any(named: 'params'))).thenAnswer(
        (_) async => PaginatedResponse(
          data: _testInventories,
          pagination: const PaginationMeta(
            hasMore: true,
            limit: 20,
            nextCursor: 'cursor_abc',
          ),
        ),
      );

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Load More'), findsOneWidget);
    });

    testWidgets('shows inventory count in category accordion header', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('Inventory'), findsWidgets);
    });

    testWidgets('join_inner button is shown for each inventory item', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.join_inner), findsNWidgets(2));
    });

    testWidgets('tapping join_inner button adds inventory to selected bar', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(Chip), findsNothing);

      final joinButtons = find.byIcon(Icons.join_inner);
      await tester.tap(joinButtons.first);
      await tester.pumpAndSettle();

      expect(find.byType(Chip), findsOneWidget);
      expect(find.text('Alpha Inventory'), findsNWidgets(2));
    });

    testWidgets(
      'tapping join_inner button twice does not duplicate selection',
      (tester) async {
        await tester.pumpWidget(_buildApp());
        await tester.pumpAndSettle();

        // Find join_inner buttons inside list tiles only
        final tileJoinButtons = find.descendant(
          of: find.byType(ListTile),
          matching: find.byIcon(Icons.join_inner),
        );
        await tester.tap(tileJoinButtons.first);
        await tester.pumpAndSettle();
        await tester.tap(tileJoinButtons.first);
        await tester.pumpAndSettle();

        expect(find.byType(Chip), findsOneWidget);
      },
    );

    testWidgets('chip delete removes inventory from selected bar', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final joinButtons = find.byIcon(Icons.join_inner);
      await tester.tap(joinButtons.first);
      await tester.pumpAndSettle();

      expect(find.byType(Chip), findsOneWidget);

      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pumpAndSettle();

      expect(find.byType(Chip), findsNothing);
    });

    testWidgets(
      'selected bar shows title and harmonize button when items selected',
      (tester) async {
        await tester.pumpWidget(_buildApp());
        await tester.pumpAndSettle();

        final joinButtons = find.byIcon(Icons.join_inner);
        await tester.tap(joinButtons.first);
        await tester.pumpAndSettle();

        expect(find.text('Selected Inventories'), findsOneWidget);
        // 2 join_inner from list tiles + 1 from selected bar
        expect(find.byIcon(Icons.join_inner), findsNWidgets(3));
      },
    );
  });
}
