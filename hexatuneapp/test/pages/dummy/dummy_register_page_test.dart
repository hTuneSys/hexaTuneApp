// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/rest/auth/auth_repository.dart';
import 'package:hexatuneapp/src/core/rest/auth/auth_service.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/create_account_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/google_auth_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/apple_auth_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/oauth_login_response.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/register_response.dart';
import 'package:hexatuneapp/src/core/rest/auth/oauth_service.dart';
import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_register_page.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthService extends Mock implements AuthService {}

class MockOAuthService extends Mock implements OAuthService {}

class MockLogService extends Mock implements LogService {}

const _testRegisterResponse = RegisterResponse(
  id: 'acc-00100',
  email: 'test@example.com',
  status: 'pending_verification',
  createdAt: '2025-01-01T00:00:00Z',
  updatedAt: '2025-01-01T00:00:00Z',
  otpExpiresInSeconds: 300,
);

const _testOAuthResponse = OAuthLoginResponse(
  accessToken: 'test-access',
  refreshToken: 'test-refresh',
  sessionId: 'test-session',
  accountId: 'test-account',
  expiresAt: '2025-12-31T00:00:00Z',
  isNewAccount: true,
);

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const DummyRegisterPage(),
  );
}

void main() {
  late MockAuthRepository mockAuthRepo;
  late MockAuthService mockAuth;
  late MockOAuthService mockOAuth;
  late MockLogService mockLog;

  setUpAll(() {
    registerFallbackValue(const CreateAccountRequest(email: '', password: ''));
    registerFallbackValue(const GoogleAuthRequest(idToken: ''));
    registerFallbackValue(const AppleAuthRequest(idToken: ''));
  });

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    mockAuth = MockAuthService();
    mockOAuth = MockOAuthService();
    mockLog = MockLogService();

    when(
      () => mockAuthRepo.register(any()),
    ).thenAnswer((_) async => _testRegisterResponse);
    when(
      () => mockAuth.loginWithGoogle(any()),
    ).thenAnswer((_) async => _testOAuthResponse);
    when(
      () => mockAuth.loginWithApple(any()),
    ).thenAnswer((_) async => _testOAuthResponse);
    when(() => mockOAuth.isAppleSignInAvailable).thenReturn(false);
    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);

    getIt.allowReassignment = true;
    getIt.registerSingleton<AuthRepository>(mockAuthRepo);
    getIt.registerSingleton<AuthService>(mockAuth);
    getIt.registerSingleton<OAuthService>(mockOAuth);
    getIt.registerSingleton<LogService>(mockLog);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('DummyRegisterPage', () {
    testWidgets('shows Create Account title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('shows email and password fields', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('shows Register button', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ElevatedButton, 'Register'), findsOneWidget);
    });

    testWidgets('shows sign in link', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('or Sign In'), findsOneWidget);
    });

    testWidgets('shows OAuth sign-up section', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('OAuth Sign-Up'), findsOneWidget);
      expect(find.text('Sign up with Google'), findsOneWidget);
      expect(find.text('Sign up with Apple'), findsOneWidget);
    });

    testWidgets('register with empty fields shows validation error', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
      await tester.pumpAndSettle();

      expect(find.text('Email and password are required'), findsOneWidget);
      verifyNever(() => mockAuthRepo.register(any()));
    });

    testWidgets('register error shows snackbar', (tester) async {
      when(
        () => mockAuthRepo.register(any()),
      ).thenAnswer((_) async => throw Exception('Email taken'));

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextField, 'Email'),
        'user@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Password'),
        'secret123',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('password field is obscured', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final passwordField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Password'),
      );
      expect(passwordField.obscureText, isTrue);
    });

    testWidgets('shows Google and Apple icons', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.g_mobiledata), findsOneWidget);
      expect(find.byIcon(Icons.apple), findsOneWidget);
    });
  });
}
