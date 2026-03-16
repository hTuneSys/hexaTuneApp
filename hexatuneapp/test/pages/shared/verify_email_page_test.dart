// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/rest/auth/auth_repository.dart';
import 'package:hexatuneapp/src/pages/shared/verify_email_page.dart';
import 'package:hexatuneapp/src/pages/shared/widgets/otp_input_field.dart';

class MockLogService extends Mock implements LogService {}

class MockAuthRepository extends Mock implements AuthRepository {}

Widget _buildApp({String email = 'test@example.com'}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: VerifyEmailPage(email: email),
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

  group('VerifyEmailPage', () {
    testWidgets('renders without errors', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(VerifyEmailPage), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('shows enter OTP code title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      // enterOtpCode = "Enter OTP Code"
      expect(find.text('Enter OTP Code'), findsOneWidget);
    });

    testWidgets('displays the user email', (tester) async {
      await tester.pumpWidget(_buildApp(email: 'user@example.com'));
      await tester.pump();

      expect(find.text('user@example.com'), findsOneWidget);
    });

    testWidgets('shows OTP input field', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(OtpInputField), findsOneWidget);
    });

    testWidgets('shows verify button', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.widgetWithText(FilledButton, 'Verify'), findsOneWidget);
    });

    testWidgets('shows did not receive code text', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      // didntReceiveCode = "Didn't receive the code?"
      expect(find.text("Didn't receive the code?"), findsOneWidget);
    });

    testWidgets('shows resend countdown timer initially', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      // Timer starts at 00:30
      expect(find.textContaining('00:30'), findsOneWidget);
    });

    testWidgets('shows resend button after timer expires', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      // Advance the timer past 30 seconds
      await tester.pump(const Duration(seconds: 31));

      // resendCode = "Resend Code"
      expect(find.widgetWithText(TextButton, 'Resend Code'), findsOneWidget);
    });

    testWidgets('shows auth header', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('shows verification code sent text', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      // verificationCodeSentTo = "We have sent a verification code to:"
      expect(find.text('We have sent a verification code to:'), findsOneWidget);
    });
  });
}
