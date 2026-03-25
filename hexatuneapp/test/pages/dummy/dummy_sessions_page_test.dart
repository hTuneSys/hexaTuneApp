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
import 'package:hexatuneapp/src/core/rest/session/session_repository.dart';
import 'package:hexatuneapp/src/core/rest/session/models/session_response.dart';
import 'package:hexatuneapp/src/core/rest/session/models/revoke_sessions_response.dart';
import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_sessions_page.dart';

class MockSessionRepository extends Mock implements SessionRepository {}

class MockLogService extends Mock implements LogService {}

const _emptyPagination = PaginationMeta(
  hasMore: false,
  limit: 20,
  nextCursor: null,
);

const _testSessions = [
  SessionResponse(
    id: 'sess-00100',
    accountId: 'acc-00100',
    deviceId: 'dev-00100',
    createdAt: '2025-01-01T00:00:00Z',
    expiresAt: '2025-02-01T00:00:00Z',
    lastActivityAt: '2025-01-15T00:00:00Z',
  ),
  SessionResponse(
    id: 'sess-00200',
    accountId: 'acc-00100',
    deviceId: 'dev-00200',
    createdAt: '2025-01-02T00:00:00Z',
    expiresAt: '2025-02-02T00:00:00Z',
    lastActivityAt: '2025-01-16T00:00:00Z',
  ),
];

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const DummySessionsPage(),
  );
}

void main() {
  late MockSessionRepository mockRepo;
  late MockLogService mockLog;

  setUp(() {
    mockRepo = MockSessionRepository();
    mockLog = MockLogService();

    when(() => mockRepo.listSessions(params: any(named: 'params'))).thenAnswer(
      (_) async =>
          PaginatedResponse(data: _testSessions, pagination: _emptyPagination),
    );
    when(() => mockRepo.revokeAll()).thenAnswer((_) async {});
    when(
      () => mockRepo.revokeOthers(),
    ).thenAnswer((_) async => const RevokeSessionsResponse(revokedCount: 1));
    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);

    getIt.allowReassignment = true;
    getIt.registerSingleton<SessionRepository>(mockRepo);
    getIt.registerSingleton<LogService>(mockLog);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('DummySessionsPage', () {
    testWidgets('shows appbar title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Sessions'), findsOneWidget);
    });

    testWidgets('shows loading indicator while data loads', (tester) async {
      final completer = Completer<PaginatedResponse<SessionResponse>>();
      when(
        () => mockRepo.listSessions(params: any(named: 'params')),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(
        PaginatedResponse(data: _testSessions, pagination: _emptyPagination),
      );
      await tester.pumpAndSettle();
    });

    testWidgets('renders session list items', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('sess-001'), findsOneWidget);
      expect(find.textContaining('sess-002'), findsOneWidget);
      expect(find.textContaining('dev-0010'), findsOneWidget);
      expect(find.textContaining('dev-0020'), findsOneWidget);
    });

    testWidgets('shows empty list when no sessions', (tester) async {
      when(
        () => mockRepo.listSessions(params: any(named: 'params')),
      ).thenAnswer(
        (_) async =>
            PaginatedResponse(data: const [], pagination: _emptyPagination),
      );

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('sess-001'), findsNothing);
      expect(find.textContaining('sess-002'), findsNothing);
    });

    testWidgets('search field exists and is functional', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final searchField = find.widgetWithText(TextField, 'Search');
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'test');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      verify(
        () => mockRepo.listSessions(params: any(named: 'params')),
      ).called(greaterThan(1));
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
        () => mockRepo.listSessions(params: any(named: 'params')),
      ).called(greaterThan(1));
    });

    testWidgets('shows revoke buttons in popup menu', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      expect(find.text('Revoke Others'), findsOneWidget);
      expect(find.text('Revoke All'), findsOneWidget);
    });

    testWidgets('shows session details in list items', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('Session sess-001'), findsOneWidget);
      expect(find.textContaining('Device: dev-0010'), findsOneWidget);
      expect(find.textContaining('Created: 2025-01-01'), findsOneWidget);
      expect(find.textContaining('Expires: 2025-02-01'), findsOneWidget);
    });

    testWidgets('shows Load More when hasMore is true', (tester) async {
      when(
        () => mockRepo.listSessions(params: any(named: 'params')),
      ).thenAnswer(
        (_) async => PaginatedResponse(
          data: _testSessions,
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
        () => mockRepo.listSessions(params: any(named: 'params')),
      ).called(greaterThan(1));
    });

    testWidgets('handles error gracefully', (tester) async {
      when(
        () => mockRepo.listSessions(params: any(named: 'params')),
      ).thenAnswer((_) async => throw Exception('Network error'));

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('revoke all triggers API call', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Revoke All'));
      await tester.pumpAndSettle();

      expect(find.text('Revoke ALL Sessions'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Revoke All'));
      await tester.pumpAndSettle();

      verify(() => mockRepo.revokeAll()).called(1);
    });

    testWidgets('revoke others triggers API call', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Revoke Others'));
      await tester.pumpAndSettle();

      expect(find.text('Revoke Other Sessions'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Revoke'));
      await tester.pumpAndSettle();

      verify(() => mockRepo.revokeOthers()).called(1);
    });
  });
}
