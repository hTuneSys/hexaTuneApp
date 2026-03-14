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
import 'package:hexatuneapp/src/core/rest/formula/formula_repository.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/create_formula_request.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/formula_detail_response.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/formula_response.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/update_formula_request.dart';
import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_formulas_page.dart';

class MockFormulaRepository extends Mock implements FormulaRepository {}

class MockLogService extends Mock implements LogService {}

const _emptyPagination = PaginationMeta(
  hasMore: false,
  limit: 20,
  nextCursor: null,
);

const _testFormulas = [
  FormulaResponse(
    id: 'frm-00100',
    name: 'Alpha Formula',
    labels: ['alpha', 'test'],
    createdAt: '2025-01-01T00:00:00Z',
    updatedAt: '2025-01-01T00:00:00Z',
  ),
  FormulaResponse(
    id: 'frm-00200',
    name: 'Beta Formula',
    labels: ['beta'],
    createdAt: '2025-01-02T00:00:00Z',
    updatedAt: '2025-01-02T00:00:00Z',
  ),
];

const _testFormulaDetail = FormulaDetailResponse(
  id: 'frm-00100',
  name: 'Alpha Formula',
  labels: ['alpha', 'test'],
  items: [],
  createdAt: '2025-01-01T00:00:00Z',
  updatedAt: '2025-01-01T00:00:00Z',
);

const _testFormulaDetail2 = FormulaDetailResponse(
  id: 'frm-00200',
  name: 'Beta Formula',
  labels: ['beta'],
  items: [],
  createdAt: '2025-01-02T00:00:00Z',
  updatedAt: '2025-01-02T00:00:00Z',
);

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const DummyFormulasPage(),
  );
}

void main() {
  late MockFormulaRepository mockRepo;
  late MockLogService mockLog;

  setUpAll(() {
    registerFallbackValue(const CreateFormulaRequest(name: ''));
    registerFallbackValue(const UpdateFormulaRequest());
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
      () => mockRepo.create(any()),
    ).thenAnswer((_) async => _testFormulas[0]);
    when(
      () => mockRepo.getById('frm-00100'),
    ).thenAnswer((_) async => _testFormulaDetail);
    when(
      () => mockRepo.getById('frm-00200'),
    ).thenAnswer((_) async => _testFormulaDetail2);
    when(
      () => mockRepo.update(any(), any()),
    ).thenAnswer((_) async => _testFormulas[0]);
    when(() => mockRepo.delete(any())).thenAnswer((_) async {});
    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);

    getIt.allowReassignment = true;
    getIt.registerSingleton<FormulaRepository>(mockRepo);
    getIt.registerSingleton<LogService>(mockLog);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('DummyFormulasPage', () {
    testWidgets('shows appbar title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Formulas'), findsOneWidget);
    });

    testWidgets('shows loading indicator while data loads', (tester) async {
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

    testWidgets('renders formula list items', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Alpha Formula'), findsOneWidget);
      expect(find.text('Beta Formula'), findsOneWidget);
      expect(find.text('alpha, test'), findsOneWidget);
      expect(find.text('beta'), findsWidgets);
    });

    testWidgets('shows empty list when no formulas', (tester) async {
      when(() => mockRepo.list(params: any(named: 'params'))).thenAnswer(
        (_) async =>
            PaginatedResponse(data: const [], pagination: _emptyPagination),
      );

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Alpha Formula'), findsNothing);
      expect(find.text('Beta Formula'), findsNothing);
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
      expect(find.text('Create Formula'), findsOneWidget);
      expect(find.text('Name *'), findsOneWidget);
    });

    testWidgets('shows detail dialog on item tap', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Alpha Formula'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('ID: frm-00100'), findsOneWidget);
      expect(find.text('Labels: alpha, test'), findsOneWidget);
      expect(find.text('Items: 0'), findsOneWidget);

      verify(() => mockRepo.getById('frm-00100')).called(1);
    });

    testWidgets(
      'detail dialog shows delete, update, and manage items buttons',
      (tester) async {
        await tester.pumpWidget(_buildApp());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Alpha Formula'));
        await tester.pumpAndSettle();

        expect(find.text('Delete'), findsOneWidget);
        expect(find.text('Update'), findsOneWidget);
        expect(find.text('Manage Items'), findsOneWidget);
      },
    );

    testWidgets('shows Load More when hasMore is true', (tester) async {
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

      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
