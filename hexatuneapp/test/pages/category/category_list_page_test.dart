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
import 'package:hexatuneapp/src/core/rest/category/category_repository.dart';
import 'package:hexatuneapp/src/core/rest/category/models/category_response.dart';
import 'package:hexatuneapp/src/core/rest/category/models/create_category_request.dart';
import 'package:hexatuneapp/src/core/rest/category/models/update_category_request.dart';
import 'package:hexatuneapp/src/pages/category/category_list_page.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

class MockLogService extends Mock implements LogService {}

const _emptyPagination = PaginationMeta(
  hasMore: false,
  limit: 20,
  nextCursor: null,
);

const _testCategories = [
  CategoryResponse(
    id: 'cat-00100',
    name: 'Alpha Category',
    labels: ['alpha', 'test'],
    createdAt: '2025-01-01T00:00:00Z',
    updatedAt: '2025-01-01T00:00:00Z',
  ),
  CategoryResponse(
    id: 'cat-00200',
    name: 'Beta Category',
    labels: ['beta'],
    createdAt: '2025-01-02T00:00:00Z',
    updatedAt: '2025-01-02T00:00:00Z',
  ),
];

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const CategoryListPage(),
  );
}

void main() {
  late MockCategoryRepository mockRepo;
  late MockLogService mockLog;

  setUpAll(() {
    registerFallbackValue(const CreateCategoryRequest(name: ''));
    registerFallbackValue(const UpdateCategoryRequest());
  });

  setUp(() {
    mockRepo = MockCategoryRepository();
    mockLog = MockLogService();

    when(() => mockRepo.list(params: any(named: 'params'))).thenAnswer(
      (_) async => PaginatedResponse(
        data: _testCategories,
        pagination: _emptyPagination,
      ),
    );
    when(
      () => mockRepo.listLabels(),
    ).thenAnswer((_) async => ['alpha', 'beta', 'test']);
    when(
      () => mockRepo.create(any()),
    ).thenAnswer((_) async => _testCategories[0]);
    when(
      () => mockRepo.getById('cat-00100'),
    ).thenAnswer((_) async => _testCategories[0]);
    when(
      () => mockRepo.getById('cat-00200'),
    ).thenAnswer((_) async => _testCategories[1]);
    when(
      () => mockRepo.update(any(), any()),
    ).thenAnswer((_) async => _testCategories[0]);
    when(() => mockRepo.delete(any())).thenAnswer((_) async {});
    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);

    getIt.allowReassignment = true;
    getIt.registerSingleton<CategoryRepository>(mockRepo);
    getIt.registerSingleton<LogService>(mockLog);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('CategoryListPage', () {
    testWidgets('renders appbar with "Category Management" title', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Category Management'), findsOneWidget);
    });

    testWidgets('shows loading indicator while fetching', (tester) async {
      final completer = Completer<PaginatedResponse<CategoryResponse>>();
      when(
        () => mockRepo.list(params: any(named: 'params')),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(
        PaginatedResponse(data: _testCategories, pagination: _emptyPagination),
      );
      await tester.pumpAndSettle();
    });

    testWidgets('displays category list items after loading', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Alpha Category'), findsOneWidget);
      expect(find.text('Beta Category'), findsOneWidget);
    });

    testWidgets('shows empty state when no categories', (tester) async {
      when(() => mockRepo.list(params: any(named: 'params'))).thenAnswer(
        (_) async =>
            PaginatedResponse(data: const [], pagination: _emptyPagination),
      );

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('No categories yet.'), findsOneWidget);
    });

    testWidgets('search icon toggles expanded search field', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Search field should not be visible initially
      expect(find.byIcon(Icons.search), findsOneWidget);

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // After tap the search text field should appear
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

      // Tap the first popup menu button
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
          data: _testCategories,
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

    testWidgets('shows "0 Inventory" subtitle for each item', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('0 Inventory'), findsNWidgets(2));
    });

    testWidgets('shows folder icon for each item', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.folder_outlined), findsNWidgets(2));
    });
  });
}
