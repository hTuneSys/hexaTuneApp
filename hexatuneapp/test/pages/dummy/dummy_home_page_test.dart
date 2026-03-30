// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/rest/auth/auth_service.dart';
import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_home_page.dart';

class MockAuthService extends Mock implements AuthService {}

class MockLogService extends Mock implements LogService {}

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const DummyHomePage(),
  );
}

void main() {
  late MockAuthService mockAuth;
  late MockLogService mockLog;

  setUp(() {
    mockAuth = MockAuthService();
    mockLog = MockLogService();

    when(() => mockAuth.logout()).thenAnswer((_) async {});
    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);

    getIt.allowReassignment = true;
    getIt.registerSingleton<AuthService>(mockAuth);
    getIt.registerSingleton<LogService>(mockLog);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('DummyHomePage', () {
    testWidgets('shows appbar title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('hexaTune Dev'), findsOneWidget);
    });

    testWidgets('shows logout button in appbar', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.logout), findsOneWidget);
    });

    testWidgets('renders navigation items visible at top', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Verify items near the top of the list that are visible
      expect(find.text('Auth Extras'), findsOneWidget);
      expect(find.text('Providers'), findsOneWidget);
      expect(find.text('Tenants'), findsOneWidget);
    });

    testWidgets('renders subtitles for nav items', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(
        find.text('Forgot/reset password, re-auth, refresh'),
        findsOneWidget,
      );
      expect(find.text('Link/unlink auth providers'), findsOneWidget);
    });

    testWidgets('renders chevron trailing icons', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.chevron_right), findsWidgets);
    });

    testWidgets('logout button calls auth service', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();

      verify(() => mockAuth.logout()).called(1);
      verify(
        () => mockLog.devLog(any(), category: any(named: 'category')),
      ).called(greaterThanOrEqualTo(1));
    });

    testWidgets('scrollable list contains more items', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('hexaGen Device'),
        200,
        scrollable: find.byType(Scrollable),
      );

      expect(find.text('hexaGen Device'), findsOneWidget);
    });

    testWidgets('nav items are wrapped in cards', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsWidgets);
      expect(find.byType(ListTile), findsWidgets);
    });
  });
}
