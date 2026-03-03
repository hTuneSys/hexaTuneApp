// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/auth/auth_repository.dart';
import 'package:hexatuneapp/src/core/auth/models/create_account_request.dart';
import 'package:hexatuneapp/src/core/auth/models/forgot_password_request.dart';
import 'package:hexatuneapp/src/core/auth/models/login_request.dart';
import 'package:hexatuneapp/src/core/auth/models/login_response.dart';
import 'package:hexatuneapp/src/core/auth/models/refresh_request.dart';
import 'package:hexatuneapp/src/core/auth/models/refresh_response.dart';
import 'package:hexatuneapp/src/core/auth/models/verify_email_request.dart';
import 'package:hexatuneapp/src/core/account/models/account_response.dart';
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
              'email': 'new@example.com',
              'status': 'pending_verification',
              'createdAt': '2025-01-01T00:00:00Z',
              'updatedAt': '2025-01-01T00:00:00Z',
            }),
            data: request.toJson(),
          );

          final result = await repository.register(request);

          expect(result, isA<AccountResponse>());
          expect(result.id, 'acc-new');
          expect(result.email, 'new@example.com');
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
          (server) => server.reply(204, null),
          data: request.toJson(),
        );

        await expectLater(repository.forgotPassword(request), completes);
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
  });
}
