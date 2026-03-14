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
import 'package:hexatuneapp/src/core/rest/task/task_repository.dart';
import 'package:hexatuneapp/src/core/rest/task/models/task_summary_dto.dart';
import 'package:hexatuneapp/src/core/rest/task/models/task_status_response.dart';
import 'package:hexatuneapp/src/core/rest/task/models/create_task_request.dart';
import 'package:hexatuneapp/src/core/rest/task/models/create_task_response.dart';
import 'package:hexatuneapp/src/core/rest/task/models/cancel_task_request.dart';
import 'package:hexatuneapp/src/core/rest/task/models/cancel_task_response.dart';
import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_tasks_page.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

class MockLogService extends Mock implements LogService {}

const _emptyPagination = PaginationMeta(
  hasMore: false,
  limit: 20,
  nextCursor: null,
);

const _testTasks = [
  TaskSummaryDto(
    taskId: 'task-001',
    taskType: 'sync',
    status: 'pending',
    scheduledAt: '2025-01-01T00:00:00Z',
    retryCount: 0,
    maxRetries: 3,
    createdAt: '2025-01-01T00:00:00Z',
    updatedAt: '2025-01-01T00:00:00Z',
  ),
  TaskSummaryDto(
    taskId: 'task-002',
    taskType: 'export',
    status: 'completed',
    scheduledAt: '2025-01-02T00:00:00Z',
    retryCount: 1,
    maxRetries: 3,
    createdAt: '2025-01-02T00:00:00Z',
    updatedAt: '2025-01-02T00:00:00Z',
  ),
];

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const DummyTasksPage(),
  );
}

void main() {
  late MockTaskRepository mockRepo;
  late MockLogService mockLog;

  setUpAll(() {
    registerFallbackValue(const CreateTaskRequest(taskType: '', payload: {}));
    registerFallbackValue(const CancelTaskRequest());
  });

  setUp(() {
    mockRepo = MockTaskRepository();
    mockLog = MockLogService();

    when(
      () => mockRepo.list(
        params: any(named: 'params'),
        status: any(named: 'status'),
        taskType: any(named: 'taskType'),
        createdAfter: any(named: 'createdAfter'),
        createdBefore: any(named: 'createdBefore'),
      ),
    ).thenAnswer(
      (_) async =>
          PaginatedResponse(data: _testTasks, pagination: _emptyPagination),
    );
    when(() => mockRepo.create(any())).thenAnswer(
      (_) async => const CreateTaskResponse(
        taskId: 'task-new',
        status: 'pending',
        scheduledAt: '2025-01-03T00:00:00Z',
      ),
    );
    when(() => mockRepo.getStatus('task-001')).thenAnswer(
      (_) async => const TaskStatusResponse(
        taskId: 'task-001',
        taskType: 'sync',
        status: 'pending',
        payload: {},
        scheduledAt: '2025-01-01T00:00:00Z',
        retryCount: 0,
        maxRetries: 3,
        createdAt: '2025-01-01T00:00:00Z',
        updatedAt: '2025-01-01T00:00:00Z',
      ),
    );
    when(() => mockRepo.cancel(any(), any())).thenAnswer(
      (_) async =>
          const CancelTaskResponse(taskId: 'task-001', status: 'cancelled'),
    );
    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);

    getIt.allowReassignment = true;
    getIt.registerSingleton<TaskRepository>(mockRepo);
    getIt.registerSingleton<LogService>(mockLog);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('DummyTasksPage', () {
    testWidgets('shows appbar title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Tasks'), findsOneWidget);
    });

    testWidgets('shows loading indicator while data loads', (tester) async {
      final completer = Completer<PaginatedResponse<TaskSummaryDto>>();
      when(
        () => mockRepo.list(
          params: any(named: 'params'),
          status: any(named: 'status'),
          taskType: any(named: 'taskType'),
          createdAfter: any(named: 'createdAfter'),
          createdBefore: any(named: 'createdBefore'),
        ),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(
        PaginatedResponse(data: _testTasks, pagination: _emptyPagination),
      );
      await tester.pumpAndSettle();
    });

    testWidgets('renders task list items', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('sync'), findsOneWidget);
      expect(find.text('export'), findsOneWidget);
      expect(find.textContaining('Status: pending'), findsOneWidget);
      expect(find.textContaining('Status: completed'), findsOneWidget);
    });

    testWidgets('shows empty list when no tasks', (tester) async {
      when(
        () => mockRepo.list(
          params: any(named: 'params'),
          status: any(named: 'status'),
          taskType: any(named: 'taskType'),
          createdAfter: any(named: 'createdAfter'),
          createdBefore: any(named: 'createdBefore'),
        ),
      ).thenAnswer(
        (_) async =>
            PaginatedResponse(data: const [], pagination: _emptyPagination),
      );

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('sync'), findsNothing);
      expect(find.text('export'), findsNothing);
    });

    testWidgets('search field exists and is functional', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final searchField = find.widgetWithText(TextField, 'Search');
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'sync');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      verify(
        () => mockRepo.list(
          params: any(named: 'params'),
          status: any(named: 'status'),
          taskType: any(named: 'taskType'),
          createdAfter: any(named: 'createdAfter'),
          createdBefore: any(named: 'createdBefore'),
        ),
      ).called(greaterThan(1));
    });

    testWidgets('task type filter field exists', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextField, 'Task Type'), findsOneWidget);
    });

    testWidgets('sort dropdown exists', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Default'), findsOneWidget);
    });

    testWidgets('selecting sort triggers reload', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Default'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Newest').last);
      await tester.pumpAndSettle();

      verify(
        () => mockRepo.list(
          params: any(named: 'params'),
          status: any(named: 'status'),
          taskType: any(named: 'taskType'),
          createdAfter: any(named: 'createdAfter'),
          createdBefore: any(named: 'createdBefore'),
        ),
      ).called(greaterThan(1));
    });

    testWidgets('status filter chips exist', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(ChoiceChip), findsNWidgets(6));
      expect(find.text('All'), findsOneWidget);
      expect(find.text('pending'), findsWidgets);
      expect(find.text('running'), findsOneWidget);
      expect(find.text('completed'), findsWidgets);
      expect(find.text('failed'), findsOneWidget);
      expect(find.text('cancelled'), findsOneWidget);
    });

    testWidgets('tapping status chip triggers reload', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final chip = find.widgetWithText(ChoiceChip, 'running');
      expect(chip, findsOneWidget);

      await tester.tap(chip);
      await tester.pumpAndSettle();

      verify(
        () => mockRepo.list(
          params: any(named: 'params'),
          status: any(named: 'status'),
          taskType: any(named: 'taskType'),
          createdAfter: any(named: 'createdAfter'),
          createdBefore: any(named: 'createdBefore'),
        ),
      ).called(greaterThan(1));
    });

    testWidgets('date after picker button exists', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('After'), findsOneWidget);
    });

    testWidgets('date before picker button exists', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Before'), findsOneWidget);
    });

    testWidgets('shows FAB for create task', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('shows detail dialog on item tap', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('sync'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('ID: task-001'), findsOneWidget);
      expect(find.text('Type: sync'), findsOneWidget);
      expect(find.text('Status: pending'), findsOneWidget);

      verify(() => mockRepo.getStatus('task-001')).called(1);
    });

    testWidgets('shows Load More when hasMore is true', (tester) async {
      when(
        () => mockRepo.list(
          params: any(named: 'params'),
          status: any(named: 'status'),
          taskType: any(named: 'taskType'),
          createdAfter: any(named: 'createdAfter'),
          createdBefore: any(named: 'createdBefore'),
        ),
      ).thenAnswer(
        (_) async => PaginatedResponse(
          data: _testTasks,
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
          status: any(named: 'status'),
          taskType: any(named: 'taskType'),
          createdAfter: any(named: 'createdAfter'),
          createdBefore: any(named: 'createdBefore'),
        ),
      ).called(greaterThan(1));
    });

    testWidgets('handles error gracefully', (tester) async {
      when(
        () => mockRepo.list(
          params: any(named: 'params'),
          status: any(named: 'status'),
          taskType: any(named: 'taskType'),
          createdAfter: any(named: 'createdAfter'),
          createdBefore: any(named: 'createdBefore'),
        ),
      ).thenAnswer((_) async => throw Exception('Network error'));

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('handles detail error gracefully', (tester) async {
      when(
        () => mockRepo.getStatus('task-001'),
      ).thenAnswer((_) async => throw Exception('Status fetch failed'));

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('sync'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
