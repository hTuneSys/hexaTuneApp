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
import 'package:hexatuneapp/src/core/rest/inventory/models/image_url_response.dart';
import 'package:hexatuneapp/src/core/rest/step/models/step_response.dart';
import 'package:hexatuneapp/src/core/rest/step/step_repository.dart';
import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_steps_page.dart';

class MockStepRepository extends Mock implements StepRepository {}

class MockLogService extends Mock implements LogService {}

const _emptyPagination = PaginationMeta(
  hasMore: false,
  limit: 20,
  nextCursor: null,
);

const _testSteps = [
  StepResponse(
    id: 'step-001',
    name: 'Relax Step',
    description: 'A calming frequency step',
    labels: ['relax', 'calm'],
    imageUploaded: true,
    createdAt: '2025-01-01T00:00:00Z',
    updatedAt: '2025-01-02T00:00:00Z',
  ),
  StepResponse(
    id: 'step-002',
    name: 'Focus Step',
    description: 'A concentration frequency step',
    labels: ['focus'],
    imageUploaded: false,
    createdAt: '2025-02-01T00:00:00Z',
    updatedAt: '2025-02-02T00:00:00Z',
  ),
];

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const DummyStepsPage(),
  );
}

void main() {
  late MockStepRepository mockRepo;
  late MockLogService mockLog;

  setUp(() {
    mockRepo = MockStepRepository();
    mockLog = MockLogService();

    when(
      () => mockRepo.list(
        params: any(named: 'params'),
        locale: any(named: 'locale'),
      ),
    ).thenAnswer(
      (_) async =>
          PaginatedResponse(data: _testSteps, pagination: _emptyPagination),
    );
    when(
      () => mockRepo.listLabels(),
    ).thenAnswer((_) async => ['relax', 'calm', 'focus']);
    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);

    getIt.allowReassignment = true;
    getIt.registerSingleton<StepRepository>(mockRepo);
    getIt.registerSingleton<LogService>(mockLog);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('DummyStepsPage', () {
    testWidgets('shows appbar title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Steps'), findsOneWidget);
    });

    testWidgets('shows loading indicator while data loads', (tester) async {
      final completer = Completer<PaginatedResponse<StepResponse>>();
      when(
        () => mockRepo.list(
          params: any(named: 'params'),
          locale: any(named: 'locale'),
        ),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(
        PaginatedResponse(data: _testSteps, pagination: _emptyPagination),
      );
      await tester.pumpAndSettle();
    });

    testWidgets('renders step list items', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Relax Step'), findsOneWidget);
      expect(find.text('Focus Step'), findsOneWidget);
      expect(find.text('relax, calm'), findsOneWidget);
      expect(find.text('focus'), findsWidgets);
    });

    testWidgets('shows empty list when no steps', (tester) async {
      when(
        () => mockRepo.list(
          params: any(named: 'params'),
          locale: any(named: 'locale'),
        ),
      ).thenAnswer(
        (_) async =>
            PaginatedResponse(data: const [], pagination: _emptyPagination),
      );

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Relax Step'), findsNothing);
      expect(find.text('Focus Step'), findsNothing);
    });

    testWidgets('shows label filter chips', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(FilterChip), findsNWidgets(3));
      expect(find.text('relax'), findsWidgets);
      expect(find.text('calm'), findsWidgets);
    });

    testWidgets('search field exists and is functional', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'Relax');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      verify(
        () => mockRepo.list(
          params: any(named: 'params'),
          locale: any(named: 'locale'),
        ),
      ).called(greaterThan(1));
    });

    testWidgets('tapping label chip reloads data', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final chip = find.widgetWithText(FilterChip, 'relax');
      expect(chip, findsOneWidget);

      await tester.tap(chip);
      await tester.pumpAndSettle();

      verify(
        () => mockRepo.list(
          params: any(named: 'params'),
          locale: any(named: 'locale'),
        ),
      ).called(greaterThan(1));
    });

    testWidgets('shows detail dialog on item tap', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Relax Step'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('ID: step-001'), findsOneWidget);
      expect(
        find.text('Description: A calming frequency step'),
        findsOneWidget,
      );
      expect(find.text('View Image'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets('detail dialog hides View Image when no image', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Focus Step'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('View Image'), findsNothing);
    });

    testWidgets('View Image button fetches and shows image', (tester) async {
      when(() => mockRepo.getImageUrl('step-001')).thenAnswer(
        (_) async =>
            const ImageUrlResponse(url: 'https://example.com/step.png'),
      );

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Relax Step'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('View Image'));
      await tester.pumpAndSettle();

      expect(find.text('Step Image'), findsOneWidget);
      verify(() => mockRepo.getImageUrl('step-001')).called(1);
    });

    testWidgets('shows Load More when hasMore is true', (tester) async {
      when(
        () => mockRepo.list(
          params: any(named: 'params'),
          locale: any(named: 'locale'),
        ),
      ).thenAnswer(
        (_) async => PaginatedResponse(
          data: _testSteps,
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
        () => mockRepo.list(
          params: any(named: 'params'),
          locale: any(named: 'locale'),
        ),
      ).called(greaterThan(1));
    });

    testWidgets('handles error gracefully', (tester) async {
      when(
        () => mockRepo.list(
          params: any(named: 'params'),
          locale: any(named: 'locale'),
        ),
      ).thenAnswer((_) async => throw Exception('Network error'));
      when(
        () => mockRepo.listLabels(),
      ).thenAnswer((_) async => throw Exception('Network error'));

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('sort dropdown exists', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Default sort'), findsOneWidget);
    });

    testWidgets('locale dropdown exists', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Default locale'), findsOneWidget);
    });

    testWidgets('selecting sort triggers reload', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Default sort'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Name (A→Z)').last);
      await tester.pumpAndSettle();

      verify(
        () => mockRepo.list(
          params: any(named: 'params'),
          locale: any(named: 'locale'),
        ),
      ).called(greaterThan(1));
    });

    testWidgets('selecting locale triggers reload', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Default locale'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('English').last);
      await tester.pumpAndSettle();

      verify(
        () => mockRepo.list(
          params: any(named: 'params'),
          locale: any(named: 'locale'),
        ),
      ).called(greaterThan(1));
    });
  });
}
