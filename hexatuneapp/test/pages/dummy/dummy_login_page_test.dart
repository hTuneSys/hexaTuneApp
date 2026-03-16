// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/notification/notification_service.dart';
import 'package:hexatuneapp/src/core/rest/auth/auth_service.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/login_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/login_response.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/google_auth_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/apple_auth_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/oauth_service.dart';
import 'package:hexatuneapp/src/core/rest/device/device_repository.dart';
import 'package:hexatuneapp/src/core/rest/device/device_service.dart';
import 'package:hexatuneapp/src/core/rest/device/models/register_push_token_request.dart';
import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_login_page.dart';

class MockAuthService extends Mock implements AuthService {}

class MockOAuthService extends Mock implements OAuthService {}

class MockDeviceService extends Mock implements DeviceService {}

class MockDeviceRepository extends Mock implements DeviceRepository {}

class MockNotificationService extends Mock implements NotificationService {}

class MockLogService extends Mock implements LogService {}

const _testLoginResponse = LoginResponse(
  accessToken: 'test-access-token',
  refreshToken: 'test-refresh-token',
  sessionId: 'test-session-id',
  accountId: 'test-account-id',
  expiresAt: '2025-12-31T00:00:00Z',
);

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const DummyLoginPage(),
  );
}

void main() {
  late MockAuthService mockAuth;
  late MockOAuthService mockOAuth;
  late MockDeviceService mockDevice;
  late MockDeviceRepository mockDeviceRepo;
  late MockNotificationService mockNotification;
  late MockLogService mockLog;

  setUpAll(() {
    registerFallbackValue(const LoginRequest(email: '', password: ''));
    registerFallbackValue(const GoogleAuthRequest(idToken: ''));
    registerFallbackValue(const AppleAuthRequest(idToken: ''));
    registerFallbackValue(
      const RegisterPushTokenRequest(token: '', platform: '', appId: ''),
    );
  });

  setUp(() {
    mockAuth = MockAuthService();
    mockOAuth = MockOAuthService();
    mockDevice = MockDeviceService();
    mockDeviceRepo = MockDeviceRepository();
    mockNotification = MockNotificationService();
    mockLog = MockLogService();

    when(
      () => mockAuth.login(any()),
    ).thenAnswer((_) async => _testLoginResponse);
    when(() => mockAuth.logout()).thenAnswer((_) async {});
    when(() => mockOAuth.isAppleSignInAvailable).thenReturn(false);
    when(() => mockDevice.deviceId).thenReturn('test-device-id');
    when(() => mockNotification.fcmToken).thenReturn(null);
    when(() => mockNotification.init()).thenAnswer((_) async {});
    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);
    when(
      () => mockLog.info(any(), category: any(named: 'category')),
    ).thenReturn(null);
    when(
      () => mockLog.warning(
        any(),
        category: any(named: 'category'),
        exception: any(named: 'exception'),
      ),
    ).thenReturn(null);

    getIt.allowReassignment = true;
    getIt.registerSingleton<AuthService>(mockAuth);
    getIt.registerSingleton<OAuthService>(mockOAuth);
    getIt.registerSingleton<DeviceService>(mockDevice);
    getIt.registerSingleton<DeviceRepository>(mockDeviceRepo);
    getIt.registerSingleton<NotificationService>(mockNotification);
    getIt.registerSingleton<LogService>(mockLog);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('DummyLoginPage', () {
    testWidgets('shows hexaTune title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('hexaTune'), findsOneWidget);
    });

    testWidgets('shows email and password fields', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('shows Login button', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    });

    testWidgets('shows sign up link', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('or Sign Up'), findsOneWidget);
    });

    testWidgets('shows OAuth sign-in section', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('OAuth Sign-In'), findsOneWidget);
      expect(find.text('Sign in with Google'), findsOneWidget);
      expect(find.text('Sign in with Apple'), findsOneWidget);
    });

    testWidgets('shows advanced manual token section', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Advanced: Manual Token'), findsOneWidget);
    });

    testWidgets('login with empty fields shows validation error', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      expect(find.text('Email and password are required'), findsOneWidget);
      verifyNever(() => mockAuth.login(any()));
    });

    testWidgets('login calls auth service with credentials', (tester) async {
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
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      verify(() => mockAuth.login(any())).called(1);
    });

    testWidgets('login error shows snackbar', (tester) async {
      when(
        () => mockAuth.login(any()),
      ).thenAnswer((_) async => throw Exception('Invalid credentials'));

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextField, 'Email'),
        'user@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Password'),
        'wrong',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
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
  });
}
