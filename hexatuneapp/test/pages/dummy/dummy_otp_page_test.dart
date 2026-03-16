// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/rest/auth/auth_repository.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/resend_verification_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/verify_email_request.dart';
import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_otp_page.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockLogService extends Mock implements LogService {}

Widget _buildApp({String? email}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: DummyOtpPage(email: email),
  );
}

void main() {
  late MockAuthRepository mockAuthRepo;
  late MockLogService mockLog;

  setUpAll(() {
    registerFallbackValue(const VerifyEmailRequest(email: '', code: ''));
    registerFallbackValue(const ResendVerificationRequest(email: ''));
  });

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    mockLog = MockLogService();

    when(() => mockAuthRepo.verifyEmail(any())).thenAnswer((_) async {});
    when(() => mockAuthRepo.resendVerification(any())).thenAnswer((_) async {});
    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);

    getIt.allowReassignment = true;
    getIt.registerSingleton<AuthRepository>(mockAuthRepo);
    getIt.registerSingleton<LogService>(mockLog);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('DummyOtpPage', () {
    testWidgets('shows verify email title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Verify Email'), findsOneWidget);
    });

    testWidgets('shows instruction text', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(
        find.text('Enter the 8-digit code sent to\nyour email'),
        findsOneWidget,
      );
    });

    testWidgets('shows instruction with provided email', (tester) async {
      await tester.pumpWidget(_buildApp(email: 'test@example.com'));
      await tester.pumpAndSettle();

      expect(
        find.text('Enter the 8-digit code sent to\ntest@example.com'),
        findsOneWidget,
      );
    });

    testWidgets('shows email field when no email provided', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('hides email field when email is provided', (tester) async {
      await tester.pumpWidget(_buildApp(email: 'test@example.com'));
      await tester.pumpAndSettle();

      // OTP Code label is still present, but Email field is not
      expect(find.text('OTP Code'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Email'), findsNothing);
    });

    testWidgets('shows OTP code field', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('OTP Code'), findsOneWidget);
    });

    testWidgets('shows Verify button', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ElevatedButton, 'Verify'), findsOneWidget);
    });

    testWidgets('shows Resend Code button', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Resend Code'), findsOneWidget);
    });

    testWidgets('shows Back to Sign In button', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Back to Sign In'), findsOneWidget);
    });

    testWidgets('verify with empty code shows error', (tester) async {
      await tester.pumpWidget(_buildApp(email: 'test@example.com'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Verify'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter the OTP code'), findsOneWidget);
      verifyNever(() => mockAuthRepo.verifyEmail(any()));
    });

    testWidgets('verify with empty email shows error', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Enter code but no email
      await tester.enterText(
        find.widgetWithText(TextField, 'OTP Code'),
        '12345678',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Verify'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter an email address'), findsOneWidget);
      verifyNever(() => mockAuthRepo.verifyEmail(any()));
    });

    testWidgets('resend with empty email shows error', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Resend Code'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter an email address'), findsOneWidget);
      verifyNever(() => mockAuthRepo.resendVerification(any()));
    });

    testWidgets('resend calls auth repository', (tester) async {
      await tester.pumpWidget(_buildApp(email: 'test@example.com'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Resend Code'));
      await tester.pumpAndSettle();

      verify(() => mockAuthRepo.resendVerification(any())).called(1);
    });

    testWidgets('verify error shows snackbar', (tester) async {
      when(
        () => mockAuthRepo.verifyEmail(any()),
      ).thenAnswer((_) async => throw Exception('Invalid code'));

      await tester.pumpWidget(_buildApp(email: 'test@example.com'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextField, 'OTP Code'),
        '12345678',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Verify'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('resend error shows snackbar', (tester) async {
      when(
        () => mockAuthRepo.resendVerification(any()),
      ).thenAnswer((_) async => throw Exception('Rate limited'));

      await tester.pumpWidget(_buildApp(email: 'test@example.com'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Resend Code'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
