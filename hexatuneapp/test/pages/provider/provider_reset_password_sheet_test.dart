// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/rest/auth/auth_repository.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/forgot_password_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/otp_sent_response.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/resend_password_reset_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/reset_password_request.dart';
import 'package:hexatuneapp/src/core/storage/otp_timer_service.dart';
import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/pages/provider/provider_reset_password_sheet.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockLogService extends Mock implements LogService {}

class MockOtpTimerService extends Mock implements OtpTimerService {}

Widget _buildApp({VoidCallback? onSuccess}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: Scaffold(
      body: Builder(
        builder: (context) => ElevatedButton(
          onPressed: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (_) => ProviderResetPasswordSheet(
              email: 'user@example.com',
              onSuccess: onSuccess,
            ),
          ),
          child: const Text('Open Sheet'),
        ),
      ),
    ),
  );
}

void main() {
  late MockAuthRepository mockAuthRepo;
  late MockLogService mockLog;
  late MockOtpTimerService mockOtpTimer;

  setUpAll(() {
    registerFallbackValue(const ForgotPasswordRequest(email: ''));
    registerFallbackValue(const ResendPasswordResetRequest(email: ''));
    registerFallbackValue(
      const ResetPasswordRequest(email: '', code: '', newPassword: ''),
    );
    registerFallbackValue(OtpFlow.passwordReset);
  });

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    mockLog = MockLogService();
    mockOtpTimer = MockOtpTimerService();

    when(
      () => mockAuthRepo.forgotPassword(any()),
    ).thenAnswer((_) async => const OtpSentResponse(expiresInSeconds: 300));
    when(() => mockAuthRepo.resetPassword(any())).thenAnswer((_) async {});
    when(
      () => mockAuthRepo.resendPasswordReset(any()),
    ).thenAnswer((_) async => const OtpSentResponse(expiresInSeconds: 300));
    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);
    when(
      () => mockOtpTimer.saveOtpExpiry(any(), any(), any()),
    ).thenAnswer((_) async {});
    when(() => mockOtpTimer.getRemainingSeconds(any(), any())).thenReturn(0);

    getIt.allowReassignment = true;
    getIt.registerSingleton<AuthRepository>(mockAuthRepo);
    getIt.registerSingleton<LogService>(mockLog);
    getIt.registerSingleton<OtpTimerService>(mockOtpTimer);
  });

  tearDown(() async {
    await getIt.reset();
  });

  Future<void> openSheet(WidgetTester tester, {VoidCallback? onSuccess}) async {
    await tester.pumpWidget(_buildApp(onSuccess: onSuccess));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open Sheet'));
    await tester.pumpAndSettle();
  }

  group('ProviderResetPasswordSheet', () {
    testWidgets('shows title and email', (tester) async {
      await openSheet(tester);

      expect(find.text('Reset Password'), findsOneWidget);
      expect(find.text('user@example.com'), findsOneWidget);
    });

    testWidgets('shows send reset code button initially', (tester) async {
      await openSheet(tester);

      expect(find.text('Send Reset Code'), findsOneWidget);
    });

    testWidgets('send reset code calls forgotPassword', (tester) async {
      await openSheet(tester);

      await tester.tap(find.text('Send Reset Code'));
      await tester.pumpAndSettle();

      verify(() => mockAuthRepo.forgotPassword(any())).called(1);
    });

    testWidgets('shows OTP input after sending code', (tester) async {
      await openSheet(tester);

      await tester.tap(find.text('Send Reset Code'));
      await tester.pumpAndSettle();

      expect(find.text('New Password'), findsOneWidget);
      expect(find.text('Confirm password'), findsOneWidget);
    });

    testWidgets('shows subtitle text', (tester) async {
      await openSheet(tester);

      expect(
        find.text('Enter the code sent to your email and set a new password'),
        findsOneWidget,
      );
    });

    testWidgets('shows existing timer if OTP was previously sent', (
      tester,
    ) async {
      when(
        () => mockOtpTimer.getRemainingSeconds(any(), any()),
      ).thenReturn(120);

      await openSheet(tester);

      // Should show OTP form directly
      expect(find.text('New Password'), findsOneWidget);
    });
  });
}
