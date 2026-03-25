// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/rest/auth/auth_service.dart';
import 'package:hexatuneapp/src/core/rest/auth/oauth_service.dart';
import 'package:hexatuneapp/src/core/rest/device/device_repository.dart';
import 'package:hexatuneapp/src/core/rest/device/device_service.dart';
import 'package:hexatuneapp/src/core/notification/notification_service.dart';
import 'package:hexatuneapp/src/pages/auth/login_page.dart';

class MockLogService extends Mock implements LogService {}

class MockAuthService extends Mock implements AuthService {}

class MockOAuthService extends Mock implements OAuthService {}

class MockDeviceService extends Mock implements DeviceService {}

class MockDeviceRepository extends Mock implements DeviceRepository {}

class MockNotificationService extends Mock implements NotificationService {}

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const LoginPage(),
  );
}

void main() {
  late MockLogService mockLog;
  late MockAuthService mockAuth;
  late MockOAuthService mockOAuth;
  late MockDeviceService mockDevice;
  late MockDeviceRepository mockDeviceRepo;
  late MockNotificationService mockNotification;

  setUp(() {
    mockLog = MockLogService();
    mockAuth = MockAuthService();
    mockOAuth = MockOAuthService();
    mockDevice = MockDeviceService();
    mockDeviceRepo = MockDeviceRepository();
    mockNotification = MockNotificationService();

    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);
    when(
      () => mockLog.warning(
        any(),
        category: any(named: 'category'),
        exception: any(named: 'exception'),
      ),
    ).thenReturn(null);
    when(() => mockDevice.deviceId).thenReturn('test-device-id');
    when(() => mockOAuth.isAppleSignInAvailable).thenReturn(false);
    when(() => mockNotification.fcmToken).thenReturn(null);

    getIt.allowReassignment = true;
    getIt.registerSingleton<LogService>(mockLog);
    getIt.registerSingleton<AuthService>(mockAuth);
    getIt.registerSingleton<OAuthService>(mockOAuth);
    getIt.registerSingleton<DeviceService>(mockDevice);
    getIt.registerSingleton<DeviceRepository>(mockDeviceRepo);
    getIt.registerSingleton<NotificationService>(mockNotification);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('LoginPage', () {
    testWidgets('renders without errors', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('shows sign-in title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // signInTitle = "Sign in"
      expect(find.text('Sign in'), findsOneWidget);
    });

    testWidgets('shows email text field', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextField, 'Email address'), findsOneWidget);
    });

    testWidgets('shows password text field', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);
    });

    testWidgets('shows sign-in button', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // signIn = "Sign In"
      expect(find.widgetWithText(FilledButton, 'Sign In'), findsOneWidget);
    });

    testWidgets('shows forgot password link', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // forgotPasswordQuestion = "Forgot Password?"
      expect(
        find.widgetWithText(TextButton, 'Forgot Password?'),
        findsOneWidget,
      );
    });

    testWidgets('shows create account link', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // createAccount = "Create account"
      expect(find.text('Create account'), findsOneWidget);
    });

    testWidgets('password field is obscured by default', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final passwordField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Password'),
      );
      expect(passwordField.obscureText, isTrue);
    });

    testWidgets('password visibility can be toggled', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Initially obscured
      var passwordField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Password'),
      );
      expect(passwordField.obscureText, isTrue);

      // Tap the visibility toggle
      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pumpAndSettle();

      // Now visible
      passwordField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Password'),
      );
      expect(passwordField.obscureText, isFalse);
    });

    testWidgets('shows social sign-in buttons', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Google and Apple buttons via SocialSignInButtons
      expect(
        find.byWidgetPredicate((w) => w is FilledButton),
        findsNWidgets(3),
      );
    });

    testWidgets('can enter text in email field', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final emailField = find.widgetWithText(TextField, 'Email address');
      await tester.enterText(emailField, 'user@example.com');

      expect(find.text('user@example.com'), findsOneWidget);
    });

    testWidgets('can enter text in password field', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final passwordField = find.widgetWithText(TextField, 'Password');
      await tester.enterText(passwordField, 'secret123');

      expect(find.text('secret123'), findsOneWidget);
    });
  });
}
