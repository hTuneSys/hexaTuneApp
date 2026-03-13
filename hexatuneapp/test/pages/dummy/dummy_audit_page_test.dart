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
import 'package:hexatuneapp/src/core/rest/audit/audit_repository.dart';
import 'package:hexatuneapp/src/core/rest/audit/models/audit_log_dto.dart';
import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_audit_page.dart';

class MockAuditRepository extends Mock implements AuditRepository {}

class MockLogService extends Mock implements LogService {}

const _emptyPagination = PaginationMeta(
  hasMore: false,
  limit: 20,
  nextCursor: null,
);

const _testLogs = [
  AuditLogDto(
    id: 'log-001',
    tenantId: 'tenant-1',
    actorType: 'user',
    actorId: 'user-001',
    action: 'login',
    resourceType: 'session',
    resourceId: 'sess-001',
    outcome: 'success',
    severity: 'INFO',
    traceId: 'trace-001',
    containsPii: false,
    occurredAt: '2025-01-01T00:00:00Z',
    createdAt: '2025-01-01T00:00:00Z',
  ),
  AuditLogDto(
    id: 'log-002',
    tenantId: 'tenant-1',
    actorType: 'system',
    action: 'delete',
    resourceType: 'account',
    outcome: 'failure',
    severity: 'HIGH',
    traceId: 'trace-002',
    containsPii: true,
    occurredAt: '2025-01-02T00:00:00Z',
    createdAt: '2025-01-02T00:00:00Z',
  ),
];

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const DummyAuditPage(),
  );
}

void main() {
  late MockAuditRepository mockRepo;
  late MockLogService mockLog;

  setUp(() {
    mockRepo = MockAuditRepository();
    mockLog = MockLogService();

    when(
      () => mockRepo.queryLogs(
        params: any(named: 'params'),
        filters: any(named: 'filters'),
      ),
    ).thenAnswer(
      (_) async =>
          PaginatedResponse(data: _testLogs, pagination: _emptyPagination),
    );
    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);

    getIt.allowReassignment = true;
    getIt.registerSingleton<AuditRepository>(mockRepo);
    getIt.registerSingleton<LogService>(mockLog);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('DummyAuditPage', () {
    testWidgets('shows appbar title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Audit Logs'), findsOneWidget);
    });

    testWidgets('shows loading indicator while data loads', (tester) async {
      final completer = Completer<PaginatedResponse<AuditLogDto>>();
      when(
        () => mockRepo.queryLogs(
          params: any(named: 'params'),
          filters: any(named: 'filters'),
        ),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Search').last);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(
        PaginatedResponse(data: _testLogs, pagination: _emptyPagination),
      );
      await tester.pumpAndSettle();
    });

    testWidgets('renders audit log items', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Search').last);
      await tester.pumpAndSettle();

      expect(find.text('login'), findsOneWidget);
      expect(find.text('delete'), findsOneWidget);
      expect(find.textContaining('session'), findsWidgets);
      expect(find.textContaining('account'), findsWidgets);
    });

    testWidgets('shows empty list when no logs', (tester) async {
      when(
        () => mockRepo.queryLogs(
          params: any(named: 'params'),
          filters: any(named: 'filters'),
        ),
      ).thenAnswer(
        (_) async =>
            PaginatedResponse(data: const [], pagination: _emptyPagination),
      );

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Search').last);
      await tester.pumpAndSettle();

      expect(find.text('login'), findsNothing);
      expect(find.text('delete'), findsNothing);
    });

    testWidgets('search field exists', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextField, 'Search'), findsOneWidget);
    });

    testWidgets('sort dropdown exists', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Default'), findsOneWidget);
    });

    testWidgets('outcome dropdown exists', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Outcome'), findsOneWidget);
    });

    testWidgets('severity dropdown exists', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Severity'), findsOneWidget);
    });

    testWidgets('action filter field exists', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextField, 'Action'), findsOneWidget);
    });

    testWidgets('resource type filter field exists', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextField, 'Resource Type'), findsOneWidget);
    });

    testWidgets('actor type filter field exists', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextField, 'Actor Type'), findsOneWidget);
    });

    testWidgets('date range picker button exists', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Date Range'), findsOneWidget);
    });

    testWidgets('search button triggers load', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Search').last);
      await tester.pumpAndSettle();

      verify(
        () => mockRepo.queryLogs(
          params: any(named: 'params'),
          filters: any(named: 'filters'),
        ),
      ).called(1);
    });

    testWidgets('selecting sort triggers reload', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Default'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Newest').last);
      await tester.pumpAndSettle();

      verify(
        () => mockRepo.queryLogs(
          params: any(named: 'params'),
          filters: any(named: 'filters'),
        ),
      ).called(1);
    });

    testWidgets('selecting outcome filter works', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final dropdowns = find.byType(DropdownButtonFormField<String>);
      expect(dropdowns, findsNWidgets(2));

      await tester.tap(dropdowns.first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Success').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Search').last);
      await tester.pumpAndSettle();

      verify(
        () => mockRepo.queryLogs(
          params: any(named: 'params'),
          filters: any(named: 'filters'),
        ),
      ).called(1);
    });

    testWidgets('selecting severity filter works', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final dropdowns = find.byType(DropdownButtonFormField<String>);

      await tester.tap(dropdowns.last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('HIGH').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Search').last);
      await tester.pumpAndSettle();

      verify(
        () => mockRepo.queryLogs(
          params: any(named: 'params'),
          filters: any(named: 'filters'),
        ),
      ).called(1);
    });

    testWidgets('shows details on item expand', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Search').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('login'));
      await tester.pumpAndSettle();

      expect(find.text('ID: log-001'), findsOneWidget);
      expect(find.text('Tenant: tenant-1'), findsOneWidget);
      expect(find.textContaining('Actor: user / user-001'), findsOneWidget);
      expect(find.text('Outcome: success'), findsOneWidget);
      expect(find.text('Severity: INFO'), findsOneWidget);
    });

    testWidgets('handles error gracefully', (tester) async {
      when(
        () => mockRepo.queryLogs(
          params: any(named: 'params'),
          filters: any(named: 'filters'),
        ),
      ).thenAnswer((_) async => throw Exception('Network error'));

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Search').last);
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
