// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/media/image_service.dart';
import 'package:hexatuneapp/src/core/network/models/paginated_response.dart';
import 'package:hexatuneapp/src/core/network/models/pagination_meta.dart';
import 'package:hexatuneapp/src/core/rest/category/category_repository.dart';
import 'package:hexatuneapp/src/core/rest/category/models/category_response.dart';
import 'package:hexatuneapp/src/core/rest/inventory/inventory_repository.dart';
import 'package:hexatuneapp/src/core/rest/inventory/models/image_url_response.dart';
import 'package:hexatuneapp/src/core/rest/inventory/models/inventory_response.dart';
import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_inventories_page.dart';

class MockInventoryRepository extends Mock implements InventoryRepository {}

class MockCategoryRepository extends Mock implements CategoryRepository {}

class MockLogService extends Mock implements LogService {}

class MockImageService extends Mock implements ImageService {}

const _emptyPagination = PaginationMeta(
  hasMore: false,
  limit: 20,
  nextCursor: null,
);

const _testInventories = [
  InventoryResponse(
    id: 'inv-00100',
    categoryId: 'cat-00100',
    name: 'Alpha Item',
    labels: ['alpha', 'test'],
    imageUploaded: true,
    createdAt: '2025-01-01T00:00:00Z',
    updatedAt: '2025-01-01T00:00:00Z',
    description: 'An alpha item',
  ),
  InventoryResponse(
    id: 'inv-00200',
    categoryId: 'cat-00100',
    name: 'Beta Item',
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
    home: const DummyInventoriesPage(),
  );
}

void main() {
  late MockInventoryRepository mockRepo;
  late MockCategoryRepository mockCatRepo;
  late MockLogService mockLog;
  late MockImageService mockImageService;

  setUp(() {
    mockRepo = MockInventoryRepository();
    mockCatRepo = MockCategoryRepository();
    mockLog = MockLogService();
    mockImageService = MockImageService();

    when(() => mockRepo.list(params: any(named: 'params'))).thenAnswer(
      (_) async => PaginatedResponse(
        data: _testInventories,
        pagination: _emptyPagination,
      ),
    );
    when(
      () => mockRepo.listLabels(),
    ).thenAnswer((_) async => ['alpha', 'beta', 'test']);
    when(
      () => mockRepo.getById('inv-00100'),
    ).thenAnswer((_) async => _testInventories[0]);
    when(
      () => mockRepo.getById('inv-00200'),
    ).thenAnswer((_) async => _testInventories[1]);
    when(() => mockRepo.getImageUrl('inv-00100')).thenAnswer(
      (_) async => const ImageUrlResponse(url: 'https://example.com/img.jpg'),
    );
    when(() => mockCatRepo.list(params: any(named: 'params'))).thenAnswer(
      (_) async => PaginatedResponse(
        data: const [
          CategoryResponse(
            id: 'cat-00100',
            name: 'Test Category',
            labels: [],
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
    getIt.registerSingleton<InventoryRepository>(mockRepo);
    getIt.registerSingleton<CategoryRepository>(mockCatRepo);
    getIt.registerSingleton<LogService>(mockLog);
    getIt.registerSingleton<ImageService>(mockImageService);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('DummyInventoriesPage', () {
    testWidgets('shows appbar title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Inventories'), findsOneWidget);
    });

    testWidgets('shows loading indicator while data loads', (tester) async {
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

    testWidgets('renders inventory list items', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Alpha Item'), findsOneWidget);
      expect(find.text('Beta Item'), findsOneWidget);
    });

    testWidgets('shows empty list when no inventories', (tester) async {
      when(() => mockRepo.list(params: any(named: 'params'))).thenAnswer(
        (_) async =>
            PaginatedResponse(data: const [], pagination: _emptyPagination),
      );

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Alpha Item'), findsNothing);
      expect(find.text('Beta Item'), findsNothing);
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

    testWidgets('shows detail dialog on item tap', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Alpha Item'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('ID: inv-00100'), findsOneWidget);
      expect(find.text('Category: cat-00100'), findsOneWidget);
      expect(find.text('Description: An alpha item'), findsOneWidget);
      expect(find.text('View Image'), findsOneWidget);

      verify(() => mockRepo.getById('inv-00100')).called(1);
    });

    testWidgets('detail dialog hides View Image when no image', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Beta Item'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('View Image'), findsNothing);
    });

    testWidgets('View Image button fetches image', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Alpha Item'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('View Image'));
      await tester.pumpAndSettle();

      expect(find.text('Inventory Image'), findsOneWidget);
      verify(() => mockRepo.getImageUrl('inv-00100')).called(1);
    });

    testWidgets('shows Load More when hasMore is true', (tester) async {
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

    testWidgets('create dialog shows category dropdown', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Create Inventory'), findsOneWidget);
      expect(find.text('Select a category'), findsOneWidget);
    });
  });
}
