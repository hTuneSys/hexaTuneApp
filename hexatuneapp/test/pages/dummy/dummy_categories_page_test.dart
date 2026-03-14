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
import 'package:hexatuneapp/src/core/rest/category/category_repository.dart';
import 'package:hexatuneapp/src/core/rest/category/models/category_response.dart';
import 'package:hexatuneapp/src/core/rest/category/models/create_category_request.dart';
import 'package:hexatuneapp/src/core/rest/category/models/update_category_request.dart';
import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_categories_page.dart';

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
    home: const DummyCategoriesPage(),
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

  group('DummyCategoriesPage', () {
    testWidgets('shows appbar title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Categories'), findsOneWidget);
    });

    testWidgets('shows loading indicator while data loads', (tester) async {
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

    testWidgets('renders category list items', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Alpha Category'), findsOneWidget);
      expect(find.text('Beta Category'), findsOneWidget);
      expect(find.text('alpha, test'), findsOneWidget);
      expect(find.text('beta'), findsWidgets);
    });

    testWidgets('shows empty list when no categories', (tester) async {
      when(() => mockRepo.list(params: any(named: 'params'))).thenAnswer(
        (_) async =>
            PaginatedResponse(data: const [], pagination: _emptyPagination),
      );

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Alpha Category'), findsNothing);
      expect(find.text('Beta Category'), findsNothing);
    });

    testWidgets('shows label filter chips', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(FilterChip), findsNWidgets(3));
      expect(find.text('alpha'), findsWidgets);
      expect(find.text('beta'), findsWidgets);
      expect(find.text('test'), findsOneWidget);
    });

    testWidgets('search field exists and is functional', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'Alpha');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      verify(
        () => mockRepo.list(params: any(named: 'params')),
      ).called(greaterThan(1));
    });

    testWidgets('tapping label chip reloads data', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final chip = find.widgetWithText(FilterChip, 'alpha');
      expect(chip, findsOneWidget);

      await tester.tap(chip);
      await tester.pumpAndSettle();

      verify(
        () => mockRepo.list(params: any(named: 'params')),
      ).called(greaterThan(1));
    });

    testWidgets('sort dropdown exists', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Default sort'), findsOneWidget);
    });

    testWidgets('selecting sort triggers reload', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Default sort'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Name (A→Z)').last);
      await tester.pumpAndSettle();

      verify(
        () => mockRepo.list(params: any(named: 'params')),
      ).called(greaterThan(1));
    });

    testWidgets('shows FAB for create', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('create dialog opens on FAB tap', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Create Category'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
    });

    testWidgets('shows detail dialog on item tap', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Alpha Category'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('ID: cat-00100'), findsOneWidget);
      expect(find.text('Labels: alpha, test'), findsOneWidget);

      verify(() => mockRepo.getById('cat-00100')).called(1);
    });

    testWidgets('detail dialog shows delete and update buttons', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Alpha Category'));
      await tester.pumpAndSettle();

      expect(find.text('Delete'), findsOneWidget);
      expect(find.text('Update'), findsOneWidget);
    });

    testWidgets('shows Load More when hasMore is true', (tester) async {
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

    testWidgets('refresh button reloads data', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      verify(
        () => mockRepo.list(params: any(named: 'params')),
      ).called(greaterThan(1));
    });

    testWidgets('handles error gracefully', (tester) async {
      when(
        () => mockRepo.list(params: any(named: 'params')),
      ).thenAnswer((_) async => throw Exception('Network error'));
      when(
        () => mockRepo.listLabels(),
      ).thenAnswer((_) async => throw Exception('Network error'));

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('handles create error gracefully', (tester) async {
      when(
        () => mockRepo.create(any()),
      ).thenAnswer((_) async => throw Exception('Create failed'));

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Tap Create to submit the dialog
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      // Dialog should be dismissed and error handled without crash
      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
