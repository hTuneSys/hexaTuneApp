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
import 'package:hexatuneapp/src/core/rest/formula/models/formula_response.dart';
import 'package:hexatuneapp/src/pages/formula/formula_list_page.dart';
import 'package:hexatuneapp/src/pages/shared/harmonize_source_holder.dart';

class MockFormulaRepository extends Mock implements FormulaRepository {}

class MockLogService extends Mock implements LogService {}

const _emptyPagination = PaginationMeta(
  hasMore: false,
  limit: 20,
  nextCursor: null,
);

const _testFormulas = [
  FormulaResponse(
    id: 'frm-001',
    name: 'Alpha Formula',
    labels: ['alpha', 'test'],
    createdAt: '2025-01-01T00:00:00Z',
    updatedAt: '2025-01-01T00:00:00Z',
  ),
  FormulaResponse(
    id: 'frm-002',
    name: 'Beta Formula',
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
    home: const FormulaListPage(),
  );
}

void main() {
  late MockFormulaRepository mockRepo;
  late MockLogService mockLog;

  setUpAll(() {
    registerFallbackValue(const PaginationParams());
  });

  setUp(() {
    mockRepo = MockFormulaRepository();
    mockLog = MockLogService();

    when(() => mockRepo.list(params: any(named: 'params'))).thenAnswer(
      (_) async =>
          PaginatedResponse(data: _testFormulas, pagination: _emptyPagination),
    );
    when(
      () => mockRepo.listLabels(),
    ).thenAnswer((_) async => ['alpha', 'beta', 'test']);
    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);

    getIt.allowReassignment = true;
    getIt.registerSingleton<FormulaRepository>(mockRepo);
    getIt.registerSingleton<LogService>(mockLog);
    getIt.registerLazySingleton<HarmonizeSourceHolder>(
      () => HarmonizeSourceHolder(),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('FormulaListPage', () {
    testWidgets('renders appbar with "Formula Management" title', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Formula Management'), findsOneWidget);
    });

    testWidgets('shows loading indicator while fetching', (tester) async {
      final completer = Completer<PaginatedResponse<FormulaResponse>>();
      when(
        () => mockRepo.list(params: any(named: 'params')),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(
        PaginatedResponse(data: _testFormulas, pagination: _emptyPagination),
      );
      await tester.pumpAndSettle();
    });

    testWidgets('shows empty state when no formulas', (tester) async {
      when(() => mockRepo.list(params: any(named: 'params'))).thenAnswer(
        (_) async =>
            PaginatedResponse(data: const [], pagination: _emptyPagination),
      );

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('No formulas yet.'), findsOneWidget);
      expect(find.byIcon(Icons.science_outlined), findsOneWidget);
    });

    testWidgets('displays formula list tiles with name', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Alpha Formula'), findsOneWidget);
      expect(find.text('Beta Formula'), findsOneWidget);
    });

    testWidgets('shows harmonize button on formula tiles', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.join_inner), findsNWidgets(2));
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
          data: _testFormulas,
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

    testWidgets('filter sheet shows no labels message when labels empty', (
      tester,
    ) async {
      when(() => mockRepo.listLabels()).thenAnswer((_) async => <String>[]);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();

      expect(find.text('No labels'), findsOneWidget);
    });
  });
}
