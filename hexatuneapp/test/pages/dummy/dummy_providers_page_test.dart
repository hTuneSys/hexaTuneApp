// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/link_apple_provider_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/link_email_provider_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/link_google_provider_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/provider_response.dart';
import 'package:hexatuneapp/src/core/rest/auth/oauth_service.dart';
import 'package:hexatuneapp/src/core/rest/auth/provider_repository.dart';
import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_providers_page.dart';

class MockProviderRepository extends Mock implements ProviderRepository {}

class MockOAuthService extends Mock implements OAuthService {}

class MockLogService extends Mock implements LogService {}

const _testProviders = [
  ProviderResponse(
    providerType: 'email',
    linkedAt: '2025-01-01T00:00:00Z',
    email: 'user@example.com',
  ),
  ProviderResponse(
    providerType: 'google',
    linkedAt: '2025-01-02T00:00:00Z',
    email: 'user@gmail.com',
  ),
];

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const DummyProvidersPage(),
  );
}

void main() {
  late MockProviderRepository mockRepo;
  late MockOAuthService mockOAuth;
  late MockLogService mockLog;

  setUpAll(() {
    registerFallbackValue(
      const LinkEmailProviderRequest(email: '', password: ''),
    );
    registerFallbackValue(const LinkGoogleProviderRequest(idToken: ''));
    registerFallbackValue(const LinkAppleProviderRequest(idToken: ''));
  });

  setUp(() {
    mockRepo = MockProviderRepository();
    mockOAuth = MockOAuthService();
    mockLog = MockLogService();

    when(
      () => mockRepo.listProviders(),
    ).thenAnswer((_) async => _testProviders);
    when(() => mockRepo.linkEmail(any())).thenAnswer((_) async {});
    when(() => mockRepo.linkGoogle(any())).thenAnswer((_) async {});
    when(() => mockRepo.linkApple(any())).thenAnswer((_) async {});
    when(() => mockRepo.unlinkProvider(any())).thenAnswer((_) async {});
    when(() => mockOAuth.isAppleSignInAvailable).thenReturn(false);
    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);

    getIt.allowReassignment = true;
    getIt.registerSingleton<ProviderRepository>(mockRepo);
    getIt.registerSingleton<OAuthService>(mockOAuth);
    getIt.registerSingleton<LogService>(mockLog);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('DummyProvidersPage', () {
    testWidgets('shows appbar title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Providers'), findsOneWidget);
    });

    testWidgets('shows loading indicator while data loads', (tester) async {
      final completer = Completer<List<ProviderResponse>>();
      when(() => mockRepo.listProviders()).thenAnswer((_) => completer.future);

      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(_testProviders);
      await tester.pumpAndSettle();
    });

    testWidgets('renders linked providers list', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Linked Providers'), findsOneWidget);
      expect(find.text('email'), findsOneWidget);
      expect(find.text('google'), findsOneWidget);
    });

    testWidgets('shows provider emails', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('user@example.com'), findsOneWidget);
      expect(find.textContaining('user@gmail.com'), findsOneWidget);
    });

    testWidgets('shows empty state when no providers', (tester) async {
      when(() => mockRepo.listProviders()).thenAnswer((_) async => []);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('No providers linked'), findsOneWidget);
    });

    testWidgets('shows link email section', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Link Email Provider'), findsOneWidget);
      expect(find.text('Link Email'), findsOneWidget);
    });

    testWidgets('shows link google section', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Link with Google'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('Link Google Provider'), findsOneWidget);
      expect(find.text('Link with Google'), findsOneWidget);
    });

    testWidgets('shows refresh button', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('refresh reloads providers', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      verify(() => mockRepo.listProviders()).called(greaterThan(1));
    });

    testWidgets('shows unlink buttons for providers', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.link_off), findsNWidgets(2));
    });

    testWidgets('link email with empty fields shows error', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Link Email'));
      await tester.pumpAndSettle();

      expect(find.text('Email and password are required'), findsOneWidget);
    });

    testWidgets('handles load error gracefully', (tester) async {
      when(
        () => mockRepo.listProviders(),
      ).thenAnswer((_) async => throw Exception('Network error'));

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('Error:'), findsOneWidget);
    });
  });
}
