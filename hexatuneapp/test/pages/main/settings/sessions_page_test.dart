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
import 'package:hexatuneapp/src/core/rest/session/models/revoke_sessions_response.dart';
import 'package:hexatuneapp/src/core/rest/session/models/session_response.dart';
import 'package:hexatuneapp/src/core/rest/session/session_repository.dart';
import 'package:hexatuneapp/src/pages/main/settings/sessions_page.dart';

class MockSessionRepository extends Mock implements SessionRepository {}

class MockLogService extends Mock implements LogService {}

const _session1 = SessionResponse(
  id: 'sess-12345678-long',
  accountId: 'acc-1',
  deviceId: 'dev-12345678-long',
  lastActivityAt: '2025-03-01',
  createdAt: '2025-01-01',
  expiresAt: '2025-06-01',
);

const _emptyPagination = PaginationMeta(hasMore: false, limit: 20);

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const SessionsPage(),
  );
}

void main() {
  late MockSessionRepository mockRepo;
  late MockLogService mockLog;

  setUpAll(() {
    registerFallbackValue(const PaginationParams());
  });

  setUp(() {
    mockRepo = MockSessionRepository();
    mockLog = MockLogService();

    when(() => mockRepo.listSessions(params: any(named: 'params'))).thenAnswer(
      (_) async => PaginatedResponse<SessionResponse>(
        data: [_session1],
        pagination: _emptyPagination,
      ),
    );
    when(
      () => mockLog.debug(any(), category: any(named: 'category')),
    ).thenReturn(null);
    when(
      () => mockLog.warning(any(), category: any(named: 'category')),
    ).thenReturn(null);

    getIt.allowReassignment = true;
    getIt.registerSingleton<SessionRepository>(mockRepo);
    getIt.registerSingleton<LogService>(mockLog);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('SessionsPage', () {
    testWidgets('shows loading indicator initially', (tester) async {
      final completer = Completer<PaginatedResponse<SessionResponse>>();
      when(
        () => mockRepo.listSessions(params: any(named: 'params')),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(
        PaginatedResponse<SessionResponse>(
          data: [_session1],
          pagination: _emptyPagination,
        ),
      );
      await tester.pumpAndSettle();
    });

    testWidgets('shows session card with truncated ID after load', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('sess-123…', skipOffstage: false), findsOneWidget);
    });

    testWidgets('shows search bar with search icon', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('shows sort dropdown', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Default'), findsOneWidget);
    });

    testWidgets(
      'Revoke Others via popup menu shows confirmation dialog and calls repo',
      (tester) async {
        when(() => mockRepo.revokeOthers()).thenAnswer(
          (_) async => const RevokeSessionsResponse(revokedCount: 3),
        );

        await tester.pumpWidget(_buildApp());
        await tester.pumpAndSettle();

        await tester.tap(find.byType(PopupMenuButton<String>));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Revoke Others'));
        await tester.pumpAndSettle();

        expect(find.text('Revoke Other Sessions'), findsOneWidget);

        await tester.tap(find.text('Revoke'));
        await tester.pumpAndSettle();

        verify(() => mockRepo.revokeOthers()).called(1);
      },
    );

    testWidgets('Revoke All via popup menu shows confirmation dialog', (
      tester,
    ) async {
      when(() => mockRepo.revokeAll()).thenAnswer((_) async {});

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Revoke All'));
      await tester.pumpAndSettle();

      expect(find.text('Revoke All Sessions'), findsOneWidget);
    });

    testWidgets('error handling does not crash', (tester) async {
      when(
        () => mockRepo.listSessions(params: any(named: 'params')),
      ).thenAnswer((_) async => throw Exception('Network error'));

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
