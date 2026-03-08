// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/rest/auth/auth_repository.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/apple_auth_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/create_account_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/forgot_password_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/google_auth_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/login_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/login_response.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/oauth_login_response.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/refresh_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/refresh_response.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/resend_password_reset_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/reset_password_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/verify_email_request.dart';
import 'package:hexatuneapp/src/core/rest/account/models/account_response.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_client.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockLogService extends Mock implements LogService {}

void main() {
  group('AuthRepository', () {
    late Dio dio;
    late DioAdapter dioAdapter;
    late MockApiClient mockApiClient;
    late MockLogService mockLogService;
    late AuthRepository repository;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://test.api'));
      dioAdapter = DioAdapter(dio: dio);
      mockApiClient = MockApiClient();
      mockLogService = MockLogService();

      when(() => mockApiClient.dio).thenReturn(dio);
      when(
        () => mockLogService.debug(any(), category: any(named: 'category')),
      ).thenReturn(null);

      repository = AuthRepository(mockApiClient, mockLogService);
    });

    group('login', () {
      test(
        'sends POST to /api/v1/auth/login and returns LoginResponse',
        () async {
          const request = LoginRequest(
            email: 'user@example.com',
            password: 'secret123',
          );

          dioAdapter.onPost(
            '/api/v1/auth/login',
            (server) => server.reply(200, {
              'accessToken': 'at-123',
              'refreshToken': 'rt-456',
              'sessionId': 'sess-789',
              'accountId': 'acc-001',
              'expiresAt': '2025-12-31T23:59:59Z',
            }),
            data: request.toJson(),
          );

          final result = await repository.login(request);

          expect(result, isA<LoginResponse>());
          expect(result.accessToken, 'at-123');
          expect(result.refreshToken, 'rt-456');
          expect(result.sessionId, 'sess-789');
          expect(result.accountId, 'acc-001');
        },
      );
    });

    group('register', () {
      test(
        'sends POST to /api/v1/auth/register and returns AccountResponse',
        () async {
          const request = CreateAccountRequest(
            email: 'new@example.com',
            password: 'newpass123',
          );

          dioAdapter.onPost(
            '/api/v1/auth/register',
            (server) => server.reply(201, {
              'id': 'acc-new',
              'status': 'pending_verification',
              'createdAt': '2025-01-01T00:00:00Z',
              'updatedAt': '2025-01-01T00:00:00Z',
            }),
            data: request.toJson(),
          );

          final result = await repository.register(request);

          expect(result, isA<AccountResponse>());
          expect(result.id, 'acc-new');
          expect(result.status, 'pending_verification');
        },
      );
    });

    group('logout', () {
      test('sends DELETE to /api/v1/auth/logout', () async {
        dioAdapter.onDelete(
          '/api/v1/auth/logout',
          (server) => server.reply(204, null),
        );

        await expectLater(repository.logout(), completes);
      });
    });

    group('refresh', () {
      test(
        'sends POST to /api/v1/auth/refresh with refreshToken body',
        () async {
          const request = RefreshRequest(refreshToken: 'rt-old');

          dioAdapter.onPost(
            '/api/v1/auth/refresh',
            (server) => server.reply(200, {
              'accessToken': 'at-new',
              'refreshToken': 'rt-new',
              'sessionId': 'sess-789',
              'expiresAt': '2025-12-31T23:59:59Z',
            }),
            data: request.toJson(),
          );

          final result = await repository.refresh(request);

          expect(result, isA<RefreshResponse>());
          expect(result.accessToken, 'at-new');
          expect(result.refreshToken, 'rt-new');
        },
      );
    });

    group('forgotPassword', () {
      test('sends POST to /api/v1/auth/forgot-password', () async {
        const request = ForgotPasswordRequest(email: 'user@example.com');

        dioAdapter.onPost(
          '/api/v1/auth/forgot-password',
          (server) => server.reply(200, null),
          data: request.toJson(),
        );

        await expectLater(repository.forgotPassword(request), completes);
      });
    });

    group('resetPassword', () {
      test('sends POST to /api/v1/auth/reset-password', () async {
        const request = ResetPasswordRequest(
          email: 'user@example.com',
          code: '12345678',
          newPassword: 'NewSecure123!',
        );

        dioAdapter.onPost(
          '/api/v1/auth/reset-password',
          (server) => server.reply(200, null),
          data: request.toJson(),
        );

        await expectLater(repository.resetPassword(request), completes);
      });
    });

    group('resendPasswordReset', () {
      test('sends POST to /api/v1/auth/resend-password-reset', () async {
        const request = ResendPasswordResetRequest(email: 'user@example.com');

        dioAdapter.onPost(
          '/api/v1/auth/resend-password-reset',
          (server) => server.reply(200, null),
          data: request.toJson(),
        );

        await expectLater(repository.resendPasswordReset(request), completes);
      });
    });

    group('verifyEmail', () {
      test('sends POST to /api/v1/auth/verify-email', () async {
        const request = VerifyEmailRequest(
          email: 'user@example.com',
          code: '123456',
        );

        dioAdapter.onPost(
          '/api/v1/auth/verify-email',
          (server) => server.reply(204, null),
          data: request.toJson(),
        );

        await expectLater(repository.verifyEmail(request), completes);
      });
    });

    group('loginWithGoogle', () {
      test(
        'sends POST to /api/v1/auth/google and returns OAuthLoginResponse',
        () async {
          const request = GoogleAuthRequest(
            idToken: 'google-id-token-123',
            deviceId: 'device-001',
          );

          dioAdapter.onPost(
            '/api/v1/auth/google',
            (server) => server.reply(200, {
              'accessToken': 'at-google',
              'refreshToken': 'rt-google',
              'sessionId': 'sess-google',
              'accountId': 'acc-google',
              'expiresAt': '2025-12-31T23:59:59Z',
              'isNewAccount': false,
            }),
            data: request.toJson(),
          );

          final result = await repository.loginWithGoogle(request);

          expect(result, isA<OAuthLoginResponse>());
          expect(result.accessToken, 'at-google');
          expect(result.refreshToken, 'rt-google');
          expect(result.sessionId, 'sess-google');
          expect(result.accountId, 'acc-google');
          expect(result.isNewAccount, isFalse);
        },
      );

      test('returns isNewAccount true for new registrations', () async {
        const request = GoogleAuthRequest(idToken: 'google-new-token');

        dioAdapter.onPost(
          '/api/v1/auth/google',
          (server) => server.reply(201, {
            'accessToken': 'at-new',
            'refreshToken': 'rt-new',
            'sessionId': 'sess-new',
            'accountId': 'acc-new',
            'expiresAt': '2025-12-31T23:59:59Z',
            'isNewAccount': true,
          }),
          data: request.toJson(),
        );

        final result = await repository.loginWithGoogle(request);

        expect(result.isNewAccount, isTrue);
      });
    });

    group('loginWithApple', () {
      test(
        'sends POST to /api/v1/auth/apple and returns OAuthLoginResponse',
        () async {
          const request = AppleAuthRequest(
            idToken: 'apple-id-token-123',
            authorizationCode: 'auth-code-abc',
            deviceId: 'device-001',
          );

          dioAdapter.onPost(
            '/api/v1/auth/apple',
            (server) => server.reply(200, {
              'accessToken': 'at-apple',
              'refreshToken': 'rt-apple',
              'sessionId': 'sess-apple',
              'accountId': 'acc-apple',
              'expiresAt': '2025-12-31T23:59:59Z',
              'isNewAccount': false,
            }),
            data: request.toJson(),
          );

          final result = await repository.loginWithApple(request);

          expect(result, isA<OAuthLoginResponse>());
          expect(result.accessToken, 'at-apple');
          expect(result.accountId, 'acc-apple');
          expect(result.isNewAccount, isFalse);
        },
      );
    });
  });
}
