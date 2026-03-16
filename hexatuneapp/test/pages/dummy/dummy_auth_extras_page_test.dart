// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/rest/auth/auth_repository.dart';
import 'package:hexatuneapp/src/core/rest/auth/token_manager.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/forgot_password_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/re_auth_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/re_auth_response.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/refresh_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/refresh_response.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/resend_password_reset_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/reset_password_request.dart';
import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_auth_extras_page.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockTokenManager extends Mock implements TokenManager {}

class MockLogService extends Mock implements LogService {}

const _testReAuthResponse = ReAuthResponse(
  token: 'reauth-token-1234567890',
  expiresAt: '2025-12-31T00:00:00Z',
);

const _testRefreshResponse = RefreshResponse(
  accessToken: 'new-access',
  refreshToken: 'new-refresh',
  sessionId: 'sess-001',
  expiresAt: '2025-12-31T00:00:00Z',
);

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const DummyAuthExtrasPage(),
  );
}

void main() {
  late MockAuthRepository mockAuthRepo;
  late MockTokenManager mockTokenManager;
  late MockLogService mockLog;

  setUpAll(() {
    registerFallbackValue(const ForgotPasswordRequest(email: ''));
    registerFallbackValue(const ResendPasswordResetRequest(email: ''));
    registerFallbackValue(
      const ResetPasswordRequest(email: '', code: '', newPassword: ''),
    );
    registerFallbackValue(const ReAuthRequest(password: ''));
    registerFallbackValue(const RefreshRequest(refreshToken: ''));
  });

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    mockTokenManager = MockTokenManager();
    mockLog = MockLogService();

    when(() => mockAuthRepo.forgotPassword(any())).thenAnswer((_) async {});
    when(
      () => mockAuthRepo.resendPasswordReset(any()),
    ).thenAnswer((_) async {});
    when(() => mockAuthRepo.resetPassword(any())).thenAnswer((_) async {});
    when(
      () => mockAuthRepo.reAuthenticate(any()),
    ).thenAnswer((_) async => _testReAuthResponse);
    when(
      () => mockAuthRepo.refresh(any()),
    ).thenAnswer((_) async => _testRefreshResponse);

    when(() => mockTokenManager.refreshToken).thenReturn(null);
    when(
      () => mockTokenManager.saveTokens(
        accessToken: any(named: 'accessToken'),
        refreshToken: any(named: 'refreshToken'),
        sessionId: any(named: 'sessionId'),
        expiresAt: any(named: 'expiresAt'),
      ),
    ).thenAnswer((_) async {});

    when(
      () => mockLog.devLog(any(), category: any(named: 'category')),
    ).thenReturn(null);

    getIt.allowReassignment = true;
    getIt.registerSingleton<AuthRepository>(mockAuthRepo);
    getIt.registerSingleton<TokenManager>(mockTokenManager);
    getIt.registerSingleton<LogService>(mockLog);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('DummyAuthExtrasPage', () {
    testWidgets('shows appbar title Auth Extras', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Auth Extras'), findsOneWidget);
    });

    testWidgets('shows Forgot Password section title and button', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Forgot Password'), findsOneWidget);
      expect(
        find.widgetWithText(ElevatedButton, 'Send Reset OTP'),
        findsOneWidget,
      );
      expect(find.widgetWithText(OutlinedButton, 'Resend OTP'), findsOneWidget);
    });

    testWidgets('shows Reset Password section title and button', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Reset Password'), findsAtLeast(1));
      expect(
        find.widgetWithText(ElevatedButton, 'Reset Password'),
        findsOneWidget,
      );
    });

    testWidgets('shows Re-Authenticate section title and button', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.drag(find.byType(ListView), const Offset(0, -400));
      await tester.pumpAndSettle();

      expect(find.text('Re-Authenticate'), findsAtLeast(1));
      expect(
        find.widgetWithText(ElevatedButton, 'Re-Authenticate'),
        findsOneWidget,
      );
    });

    testWidgets('shows Refresh Token section and button', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.drag(find.byType(ListView), const Offset(0, -600));
      await tester.pumpAndSettle();

      expect(find.text('Refresh Token'), findsAtLeast(1));
      expect(
        find.widgetWithText(ElevatedButton, 'Refresh Token'),
        findsOneWidget,
      );
    });

    testWidgets('forgot password button triggers API call', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextField, 'Email').first,
        'test@example.com',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Send Reset OTP'));
      await tester.pumpAndSettle();

      verify(
        () => mockAuthRepo.forgotPassword(
          const ForgotPasswordRequest(email: 'test@example.com'),
        ),
      ).called(1);
    });

    testWidgets('re-authenticate button triggers API call', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final listView = find.byType(Scrollable).first;
      await tester.scrollUntilVisible(
        find.widgetWithText(TextField, 'Current Password'),
        200,
        scrollable: listView,
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextField, 'Current Password'),
        'mypassword',
      );
      await tester.scrollUntilVisible(
        find.widgetWithText(ElevatedButton, 'Re-Authenticate'),
        200,
        scrollable: listView,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Re-Authenticate'));
      await tester.pumpAndSettle();

      verify(
        () => mockAuthRepo.reAuthenticate(
          const ReAuthRequest(password: 'mypassword'),
        ),
      ).called(1);
    });

    testWidgets('refresh token with no token shows result text', (
      tester,
    ) async {
      when(() => mockTokenManager.refreshToken).thenReturn(null);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final listView = find.byType(Scrollable).first;
      await tester.scrollUntilVisible(
        find.widgetWithText(ElevatedButton, 'Refresh Token'),
        200,
        scrollable: listView,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Refresh Token'));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.byType(SelectableText),
        200,
        scrollable: listView,
      );
      await tester.pumpAndSettle();

      expect(find.byType(SelectableText), findsOneWidget);
      final selectableText = tester.widget<SelectableText>(
        find.byType(SelectableText),
      );
      expect(selectableText.data, contains('No refresh token available'));
    });

    testWidgets('handles error gracefully', (tester) async {
      when(
        () => mockAuthRepo.forgotPassword(any()),
      ).thenAnswer((_) async => throw Exception('Network error'));

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextField, 'Email').first,
        'test@example.com',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Send Reset OTP'));
      await tester.pumpAndSettle();

      final listView = find.byType(Scrollable).first;
      await tester.scrollUntilVisible(
        find.byType(SelectableText),
        200,
        scrollable: listView,
      );
      await tester.pumpAndSettle();

      expect(find.byType(SelectableText), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
