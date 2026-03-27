// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/rest/auth/auth_repository.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/link_apple_provider_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/link_email_provider_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/link_google_provider_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/otp_sent_response.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/provider_response.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/resend_verification_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/verify_email_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/oauth_service.dart';
import 'package:hexatuneapp/src/core/rest/auth/provider_repository.dart';
import 'package:hexatuneapp/src/core/storage/otp_timer_service.dart';
import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/pages/provider/provider_page.dart';

class MockProviderRepository extends Mock implements ProviderRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockOAuthService extends Mock implements OAuthService {}

class MockLogService extends Mock implements LogService {}

class MockOtpTimerService extends Mock implements OtpTimerService {}

const _emailProvider = ProviderResponse(
  providerType: 'email',
  linkedAt: '2025-01-01T00:00:00Z',
  email: 'user@example.com',
  emailVerified: true,
);

const _unverifiedEmailProvider = ProviderResponse(
  providerType: 'email',
  linkedAt: '2025-01-01T00:00:00Z',
  email: 'user@example.com',
  emailVerified: false,
);

const _googleProvider = ProviderResponse(
  providerType: 'google',
  linkedAt: '2025-01-02T00:00:00Z',
  email: 'user@gmail.com',
);

const _appleProvider = ProviderResponse(
  providerType: 'apple',
  linkedAt: '2025-01-03T00:00:00Z',
  email: 'user@apple.com',
);

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const ProviderPage(),
  );
}

void main() {
  late MockProviderRepository mockProviderRepo;
  late MockAuthRepository mockAuthRepo;
  late MockOAuthService mockOAuth;
  late MockLogService mockLog;
  late MockOtpTimerService mockOtpTimer;

  setUpAll(() {
    registerFallbackValue(
      const LinkEmailProviderRequest(email: '', password: ''),
    );
    registerFallbackValue(const LinkGoogleProviderRequest(idToken: ''));
    registerFallbackValue(const LinkAppleProviderRequest(idToken: ''));
    registerFallbackValue(OtpFlow.emailProviderLink);
    registerFallbackValue(const VerifyEmailRequest(email: '', code: ''));
    registerFallbackValue(const ResendVerificationRequest(email: ''));
  });

  setUp(() {
    mockProviderRepo = MockProviderRepository();
    mockAuthRepo = MockAuthRepository();
    mockOAuth = MockOAuthService();
    mockLog = MockLogService();
    mockOtpTimer = MockOtpTimerService();

    when(
      () => mockProviderRepo.listProviders(),
    ).thenAnswer((_) async => [_emailProvider, _googleProvider]);
    when(
      () => mockProviderRepo.linkEmail(any()),
    ).thenAnswer((_) async => const OtpSentResponse(expiresInSeconds: 300));
    when(() => mockProviderRepo.linkGoogle(any())).thenAnswer((_) async {});
    when(() => mockProviderRepo.linkApple(any())).thenAnswer((_) async {});
    when(() => mockProviderRepo.unlinkProvider(any())).thenAnswer((_) async {});
    when(() => mockAuthRepo.verifyEmail(any())).thenAnswer((_) async {});
    when(
      () => mockAuthRepo.resendVerification(any()),
    ).thenAnswer((_) async => const OtpSentResponse(expiresInSeconds: 300));
    when(() => mockOAuth.isAppleSignInAvailable).thenReturn(false);
    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);
    when(
      () => mockOtpTimer.saveOtpExpiry(any(), any(), any()),
    ).thenAnswer((_) async {});
    when(() => mockOtpTimer.getRemainingSeconds(any(), any())).thenReturn(0);

    getIt.allowReassignment = true;
    getIt.registerSingleton<ProviderRepository>(mockProviderRepo);
    getIt.registerSingleton<AuthRepository>(mockAuthRepo);
    getIt.registerSingleton<OAuthService>(mockOAuth);
    getIt.registerSingleton<LogService>(mockLog);
    getIt.registerSingleton<OtpTimerService>(mockOtpTimer);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('ProviderPage', () {
    testWidgets('shows appbar title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Linked Accounts'), findsOneWidget);
    });

    testWidgets('shows loading indicator while loading', (tester) async {
      final completer = Completer<List<ProviderResponse>>();
      when(
        () => mockProviderRepo.listProviders(),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete([_emailProvider]);
      await tester.pumpAndSettle();
    });

    testWidgets('shows email section', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('shows google section', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Google'), findsOneWidget);
    });

    testWidgets('shows apple section', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Apple'), findsOneWidget);
    });

    testWidgets('shows verified chip for verified email', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Verified'), findsOneWidget);
    });

    testWidgets('shows not verified chip for unverified email', (tester) async {
      when(
        () => mockProviderRepo.listProviders(),
      ).thenAnswer((_) async => [_unverifiedEmailProvider]);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Not verified'), findsOneWidget);
    });

    testWidgets('shows email address for linked email provider', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('user@example.com'), findsOneWidget);
    });

    testWidgets('shows reset password button for verified email', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Reset Password'), findsOneWidget);
    });

    testWidgets('shows OTP verify section for unverified email', (
      tester,
    ) async {
      when(
        () => mockProviderRepo.listProviders(),
      ).thenAnswer((_) async => [_unverifiedEmailProvider]);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(
        find.text('Enter the verification code sent to your email'),
        findsOneWidget,
      );
    });

    testWidgets('shows link form when no email provider', (tester) async {
      when(
        () => mockProviderRepo.listProviders(),
      ).thenAnswer((_) async => [_googleProvider]);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Link with Email'), findsOneWidget);
    });

    testWidgets('shows google email when linked', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('user@gmail.com'), findsOneWidget);
    });

    testWidgets('shows link with google when not linked', (tester) async {
      when(
        () => mockProviderRepo.listProviders(),
      ).thenAnswer((_) async => [_emailProvider]);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Link with Google'), findsOneWidget);
    });

    testWidgets('shows unlink buttons for linked providers', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Unlink'), findsNWidgets(2));
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

      verify(() => mockProviderRepo.listProviders()).called(greaterThan(1));
    });

    testWidgets('email link validates empty fields', (tester) async {
      when(() => mockProviderRepo.listProviders()).thenAnswer((_) async => []);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Link with Email'));
      await tester.pumpAndSettle();

      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('handles load error gracefully', (tester) async {
      when(
        () => mockProviderRepo.listProviders(),
      ).thenAnswer((_) async => throw Exception('Network error'));

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();
    });

    testWidgets('shows all three provider sections', (tester) async {
      when(() => mockProviderRepo.listProviders()).thenAnswer(
        (_) async => [_emailProvider, _googleProvider, _appleProvider],
      );

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Google'), findsOneWidget);
      expect(find.text('Apple'), findsOneWidget);
    });
  });
}
