// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/rest/auth/auth_repository.dart';
import 'package:hexatuneapp/src/pages/shared/auth/reset_password_page.dart';
import 'package:hexatuneapp/src/pages/shared/auth/widgets/otp_input_field.dart';
import 'package:hexatuneapp/src/pages/shared/auth/widgets/password_strength_indicator.dart';

class MockLogService extends Mock implements LogService {}

class MockAuthRepository extends Mock implements AuthRepository {}

Widget _buildApp({String email = 'test@example.com'}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: ResetPasswordPage(email: email),
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

  group('ResetPasswordPage', () {
    testWidgets('renders without errors', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(ResetPasswordPage), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('shows reset password title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      // resetYourPassword = "Reset Your Password"
      expect(find.text('Reset Your Password'), findsOneWidget);
    });

    testWidgets('shows OTP input field', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(OtpInputField), findsOneWidget);
    });

    testWidgets('shows new password text field', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      // newPassword = "New Password"
      expect(find.widgetWithText(TextField, 'New Password'), findsOneWidget);
    });

    testWidgets('shows confirm password text field', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      // confirmPassword = "Confirm password"
      expect(
        find.widgetWithText(TextField, 'Confirm password'),
        findsOneWidget,
      );
    });

    testWidgets('shows reset password button', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      // resetPassword = "Reset Password"
      expect(
        find.widgetWithText(FilledButton, 'Reset Password'),
        findsOneWidget,
      );
    });

    testWidgets('shows password strength indicator', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(PasswordStrengthIndicator), findsOneWidget);
    });

    testWidgets('shows resend countdown timer initially', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      // Timer starts at 00:30
      expect(find.textContaining('00:30'), findsOneWidget);
    });

    testWidgets('shows did not receive code text', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      // didntReceiveCode = "Didn't receive the code?"
      expect(find.text("Didn't receive the code?"), findsOneWidget);
    });

    testWidgets('password fields are obscured by default', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      final newPassword = tester.widget<TextField>(
        find.widgetWithText(TextField, 'New Password'),
      );
      final confirmPassword = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Confirm password'),
      );

      expect(newPassword.obscureText, isTrue);
      expect(confirmPassword.obscureText, isTrue);
    });

    testWidgets('password visibility can be toggled', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      final toggleIcons = find.byIcon(Icons.visibility_off_outlined);
      expect(toggleIcons, findsNWidgets(2));

      // Tap the first toggle (New password)
      await tester.tap(toggleIcons.first);
      await tester.pump();

      final newPassword = tester.widget<TextField>(
        find.widgetWithText(TextField, 'New Password'),
      );
      expect(newPassword.obscureText, isFalse);
    });

    testWidgets('shows resend button after timer expires', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      // Advance the timer past 30 seconds
      await tester.pump(const Duration(seconds: 31));

      // resendCode = "Resend Code"
      expect(find.widgetWithText(TextButton, 'Resend Code'), findsOneWidget);
    });
  });
}
