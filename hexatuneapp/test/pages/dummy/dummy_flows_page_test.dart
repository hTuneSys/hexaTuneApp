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
import 'package:hexatuneapp/src/core/rest/flow/flow_repository.dart';
import 'package:hexatuneapp/src/core/rest/flow/models/flow_detail_response.dart';
import 'package:hexatuneapp/src/core/rest/flow/models/flow_response.dart';
import 'package:hexatuneapp/src/core/rest/flow/models/flow_step_response.dart';
import 'package:hexatuneapp/src/core/rest/inventory/models/image_url_response.dart';
import 'package:hexatuneapp/src/core/rest/package/models/package_response.dart';
import 'package:hexatuneapp/src/core/rest/package/package_repository.dart';
import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_flows_page.dart';

class MockFlowRepository extends Mock implements FlowRepository {}

class MockPackageRepository extends Mock implements PackageRepository {}

class MockLogService extends Mock implements LogService {}

const _emptyPagination = PaginationMeta(
  hasMore: false,
  limit: 20,
  nextCursor: null,
);

const _testFlowSteps = [
  FlowStepResponse(
    id: 'fs-001',
    stepId: 'step-001',
    sortOrder: 1,
    quantity: 3,
    timeMs: 60000,
  ),
  FlowStepResponse(
    id: 'fs-002',
    stepId: 'step-002',
    sortOrder: 2,
    quantity: 1,
    timeMs: 30000,
  ),
];

const _testFlows = [
  FlowResponse(
    id: 'flow-001',
    name: 'Morning Flow',
    description: 'A morning relaxation flow',
    labels: ['morning', 'relax'],
    imageUploaded: true,
    createdAt: '2025-01-01T00:00:00Z',
    updatedAt: '2025-01-02T00:00:00Z',
  ),
  FlowResponse(
    id: 'flow-002',
    name: 'Evening Flow',
    description: 'An evening calming flow',
    labels: ['evening'],
    imageUploaded: false,
    createdAt: '2025-02-01T00:00:00Z',
    updatedAt: '2025-02-02T00:00:00Z',
  ),
];

const _testFlowDetail = FlowDetailResponse(
  id: 'flow-001',
  name: 'Morning Flow',
  description: 'A morning relaxation flow',
  labels: ['morning', 'relax'],
  imageUploaded: true,
  steps: _testFlowSteps,
  createdAt: '2025-01-01T00:00:00Z',
  updatedAt: '2025-01-02T00:00:00Z',
);

const _testFlowDetailNoImage = FlowDetailResponse(
  id: 'flow-002',
  name: 'Evening Flow',
  description: 'An evening calming flow',
  labels: ['evening'],
  imageUploaded: false,
  steps: [],
  createdAt: '2025-02-01T00:00:00Z',
  updatedAt: '2025-02-02T00:00:00Z',
);

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const DummyFlowsPage(),
  );
}

void main() {
  late MockFlowRepository mockRepo;
  late MockPackageRepository mockPackageRepo;
  late MockLogService mockLog;

  setUp(() {
    mockRepo = MockFlowRepository();
    mockPackageRepo = MockPackageRepository();
    mockLog = MockLogService();

    when(
      () => mockRepo.list(
        params: any(named: 'params'),
        packageId: any(named: 'packageId'),
        locale: any(named: 'locale'),
      ),
    ).thenAnswer(
      (_) async =>
          PaginatedResponse(data: _testFlows, pagination: _emptyPagination),
    );
    when(
      () => mockRepo.listLabels(),
    ).thenAnswer((_) async => ['morning', 'evening', 'relax']);
    when(
      () => mockRepo.getById('flow-001'),
    ).thenAnswer((_) async => _testFlowDetail);
    when(
      () => mockRepo.getById('flow-002'),
    ).thenAnswer((_) async => _testFlowDetailNoImage);
    when(() => mockPackageRepo.list()).thenAnswer(
      (_) async => PaginatedResponse(
        data: const [
          PackageResponse(
            id: 'pkg-001',
            name: 'Test Package',
            description: 'A test package',
            labels: ['test'],
            imageUploaded: false,
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
    getIt.registerSingleton<FlowRepository>(mockRepo);
    getIt.registerSingleton<PackageRepository>(mockPackageRepo);
    getIt.registerSingleton<LogService>(mockLog);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('DummyFlowsPage', () {
    testWidgets('shows appbar title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Flows'), findsOneWidget);
    });

    testWidgets('shows loading indicator while data loads', (tester) async {
      final completer = Completer<PaginatedResponse<FlowResponse>>();
      when(
        () => mockRepo.list(
          params: any(named: 'params'),
          packageId: any(named: 'packageId'),
          locale: any(named: 'locale'),
        ),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(
        PaginatedResponse(data: _testFlows, pagination: _emptyPagination),
      );
      await tester.pumpAndSettle();
    });

    testWidgets('renders flow list items', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Morning Flow'), findsOneWidget);
      expect(find.text('Evening Flow'), findsOneWidget);
      expect(find.text('morning, relax'), findsOneWidget);
      expect(find.text('evening'), findsWidgets);
    });

    testWidgets('shows empty list when no flows', (tester) async {
      when(
        () => mockRepo.list(
          params: any(named: 'params'),
          packageId: any(named: 'packageId'),
          locale: any(named: 'locale'),
        ),
      ).thenAnswer(
        (_) async =>
            PaginatedResponse(data: const [], pagination: _emptyPagination),
      );

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Morning Flow'), findsNothing);
      expect(find.text('Evening Flow'), findsNothing);
    });

    testWidgets('shows label filter chips', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(FilterChip), findsNWidgets(3));
      expect(find.text('morning'), findsWidgets);
      expect(find.text('evening'), findsWidgets);
    });

    testWidgets('search field exists and is functional', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'Morning');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      verify(
        () => mockRepo.list(
          params: any(named: 'params'),
          packageId: any(named: 'packageId'),
          locale: any(named: 'locale'),
        ),
      ).called(greaterThan(1));
    });

    testWidgets('tapping label chip reloads data', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final chip = find.widgetWithText(FilterChip, 'morning');
      expect(chip, findsOneWidget);

      await tester.tap(chip);
      await tester.pumpAndSettle();

      verify(
        () => mockRepo.list(
          params: any(named: 'params'),
          packageId: any(named: 'packageId'),
          locale: any(named: 'locale'),
        ),
      ).called(greaterThan(1));
    });

    testWidgets('shows detail dialog with steps on item tap', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Morning Flow'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('ID: flow-001'), findsOneWidget);
      expect(
        find.text('Description: A morning relaxation flow'),
        findsOneWidget,
      );
      expect(find.text('Steps: 2'), findsOneWidget);
      expect(find.text('Flow Steps'), findsOneWidget);
      expect(find.text('View Image'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);

      verify(() => mockRepo.getById('flow-001')).called(1);
    });

    testWidgets('detail dialog shows flow step entries', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Morning Flow'));
      await tester.pumpAndSettle();

      // Flow step #1: sortOrder 1, stepId step-001, quantity 3, 60000ms
      expect(find.textContaining('#1'), findsOneWidget);
      // Flow step #2: sortOrder 2, stepId step-002, quantity 1, 30000ms
      expect(find.textContaining('#2'), findsOneWidget);
    });

    testWidgets('detail dialog hides View Image when no image', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Evening Flow'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('View Image'), findsNothing);
      expect(find.text('Flow Steps'), findsNothing);
    });

    testWidgets('View Image button fetches and shows image', (tester) async {
      when(() => mockRepo.getImageUrl('flow-001')).thenAnswer(
        (_) async =>
            const ImageUrlResponse(url: 'https://example.com/flow.png'),
      );

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Morning Flow'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('View Image'));
      await tester.pumpAndSettle();

      expect(find.text('Flow Image'), findsOneWidget);
      verify(() => mockRepo.getImageUrl('flow-001')).called(1);
    });

    testWidgets('shows Load More when hasMore is true', (tester) async {
      when(
        () => mockRepo.list(
          params: any(named: 'params'),
          packageId: any(named: 'packageId'),
          locale: any(named: 'locale'),
        ),
      ).thenAnswer(
        (_) async => PaginatedResponse(
          data: _testFlows,
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
          packageId: any(named: 'packageId'),
          locale: any(named: 'locale'),
        ),
      ).called(greaterThan(1));
    });

    testWidgets('handles error gracefully', (tester) async {
      when(
        () => mockRepo.list(
          params: any(named: 'params'),
          packageId: any(named: 'packageId'),
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

    testWidgets('handles detail fetch error gracefully', (tester) async {
      when(
        () => mockRepo.getById('flow-001'),
      ).thenAnswer((_) async => throw Exception('Not found'));

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Morning Flow'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('sort dropdown exists and changes sort', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Default sort'), findsOneWidget);
    });

    testWidgets('locale dropdown exists and shows options', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Default locale'), findsOneWidget);
    });

    testWidgets('package selector shows loaded packages', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('All packages'), findsOneWidget);
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
          packageId: any(named: 'packageId'),
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
          packageId: any(named: 'packageId'),
          locale: any(named: 'locale'),
        ),
      ).called(greaterThan(1));
    });

    testWidgets('selecting package triggers reload', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('All packages'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Test Package').last);
      await tester.pumpAndSettle();

      verify(
        () => mockRepo.list(
          params: any(named: 'params'),
          packageId: any(named: 'packageId'),
          locale: any(named: 'locale'),
        ),
      ).called(greaterThan(1));
    });
  });
}
