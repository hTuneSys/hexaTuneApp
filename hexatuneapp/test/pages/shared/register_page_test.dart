// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/rest/auth/auth_repository.dart';
import 'package:hexatuneapp/src/core/rest/auth/auth_service.dart';
import 'package:hexatuneapp/src/core/rest/auth/oauth_service.dart';
import 'package:hexatuneapp/src/pages/shared/register_page.dart';
import 'package:hexatuneapp/src/pages/shared/widgets/password_strength_indicator.dart';

class MockLogService extends Mock implements LogService {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthService extends Mock implements AuthService {}

class MockOAuthService extends Mock implements OAuthService {}

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const RegisterPage(),
  );
}

void main() {
  late MockLogService mockLog;
  late MockAuthRepository mockAuthRepo;
  late MockAuthService mockAuth;
  late MockOAuthService mockOAuth;

  setUp(() {
    mockLog = MockLogService();
    mockAuthRepo = MockAuthRepository();
    mockAuth = MockAuthService();
    mockOAuth = MockOAuthService();

    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);
    when(() => mockOAuth.isAppleSignInAvailable).thenReturn(false);

    getIt.allowReassignment = true;
    getIt.registerSingleton<LogService>(mockLog);
    getIt.registerSingleton<AuthRepository>(mockAuthRepo);
    getIt.registerSingleton<AuthService>(mockAuth);
    getIt.registerSingleton<OAuthService>(mockOAuth);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('RegisterPage', () {
    testWidgets('renders without errors', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(RegisterPage), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('shows create account title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Create an account'), findsOneWidget);
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

    testWidgets('shows confirm password text field', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(TextField, 'Confirm password'),
        findsOneWidget,
      );
    });

    testWidgets('shows sign-up button', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // signUp = "Sign Up"
      expect(find.widgetWithText(FilledButton, 'Sign Up'), findsOneWidget);
    });

    testWidgets('shows password strength indicator', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(PasswordStrengthIndicator), findsOneWidget);
    });

    testWidgets('shows social sign-in buttons', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(OutlinedButton), findsNWidgets(2));
    });

    testWidgets('shows sign-in link for existing users', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // signInLink = "Sign In"
      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('password field is obscured by default', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final passwordField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Password'),
      );
      expect(passwordField.obscureText, isTrue);
    });

    testWidgets('confirm password field is obscured by default', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final confirmField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Confirm password'),
      );
      expect(confirmField.obscureText, isTrue);
    });

    testWidgets('password visibility can be toggled', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Both password fields start obscured; there are 2 visibility_off icons
      final toggleIcons = find.byIcon(Icons.visibility_off_outlined);
      expect(toggleIcons, findsNWidgets(2));

      // Tap the first visibility toggle (Password field)
      await tester.tap(toggleIcons.first);
      await tester.pumpAndSettle();

      // Now the Password field should be visible
      final passwordField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Password'),
      );
      expect(passwordField.obscureText, isFalse);
    });

    testWidgets('can enter text in all fields', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextField, 'Email address'),
        'new@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Password'),
        'StrongP@ss1',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Confirm password'),
        'StrongP@ss1',
      );

      expect(find.text('new@example.com'), findsOneWidget);
      expect(find.text('StrongP@ss1'), findsNWidgets(2));
    });
  });
}
