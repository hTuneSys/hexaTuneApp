// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/rest/auth/auth_repository.dart';
import 'package:hexatuneapp/src/pages/auth/forgot_password_page.dart';

class MockLogService extends Mock implements LogService {}

class MockAuthRepository extends Mock implements AuthRepository {}

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const ForgotPasswordPage(),
  );
}

void main() {
  late MockLogService mockLog;
  late MockAuthRepository mockAuthRepo;

  setUp(() {
    mockLog = MockLogService();
    mockAuthRepo = MockAuthRepository();

    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);

    getIt.allowReassignment = true;
    getIt.registerSingleton<LogService>(mockLog);
    getIt.registerSingleton<AuthRepository>(mockAuthRepo);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('ForgotPasswordPage', () {
    testWidgets('renders without errors', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(ForgotPasswordPage), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('shows forgot password title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // forgotPasswordTitle = "Forgot Password"
      expect(find.text('Forgot Password'), findsOneWidget);
    });

    testWidgets('shows subtitle', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // forgotPasswordSubtitle = "Enter your email to receive a reset code."
      expect(
        find.text('Enter your email to receive a reset code.'),
        findsOneWidget,
      );
    });

    testWidgets('shows email text field', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextField, 'Email address'), findsOneWidget);
    });

    testWidgets('shows send reset code button', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // sendResetCode = "Send Reset Code"
      expect(
        find.widgetWithText(FilledButton, 'Send Reset Code'),
        findsOneWidget,
      );
    });

    testWidgets('can enter email', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final emailField = find.widgetWithText(TextField, 'Email address');
      await tester.enterText(emailField, 'test@example.com');

      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('shows auth header', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // AuthHeader shows an Image
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('shows sign in link to return to login', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // alreadyHaveAccountPrefix = "Already have an account? "
      expect(find.text('Already have an account? '), findsOneWidget);
      // signInLink = "Sign In"
      expect(find.text('Sign In'), findsOneWidget);
    });
  });
}
