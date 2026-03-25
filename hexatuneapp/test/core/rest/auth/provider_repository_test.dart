// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/rest/auth/models/link_apple_provider_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/link_email_provider_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/link_google_provider_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/provider_response.dart';
import 'package:hexatuneapp/src/core/rest/auth/provider_repository.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_client.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockLogService extends Mock implements LogService {}

void main() {
  group('ProviderRepository', () {
    late Dio dio;
    late DioAdapter dioAdapter;
    late MockApiClient mockApiClient;
    late MockLogService mockLogService;
    late ProviderRepository repository;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://test.api'));
      dioAdapter = DioAdapter(dio: dio);
      mockApiClient = MockApiClient();
      mockLogService = MockLogService();

      when(() => mockApiClient.dio).thenReturn(dio);
      when(
        () => mockLogService.debug(any(), category: any(named: 'category')),
      ).thenReturn(null);

      repository = ProviderRepository(mockApiClient, mockLogService);
    });

    group('listProviders', () {
      test(
        'sends GET to /api/v1/accounts/me/providers and returns list',
        () async {
          dioAdapter.onGet(
            '/api/v1/accounts/me/providers',
            (server) => server.reply(200, [
              {
                'providerType': 'email',
                'linkedAt': '2025-01-01T00:00:00Z',
                'email': 'user@example.com',
              },
              {
                'providerType': 'google',
                'linkedAt': '2025-06-01T00:00:00Z',
                'email': 'user@gmail.com',
              },
            ]),
          );

          final result = await repository.listProviders();

          expect(result, hasLength(2));
          expect(result[0], isA<ProviderResponse>());
          expect(result[0].providerType, 'email');
          expect(result[1].providerType, 'google');
        },
      );

      test('returns empty list when no providers', () async {
        dioAdapter.onGet(
          '/api/v1/accounts/me/providers',
          (server) => server.reply(200, <dynamic>[]),
        );

        final result = await repository.listProviders();

        expect(result, isEmpty);
      });
    });

    group('linkEmail', () {
      test(
        'sends POST to /api/v1/auth/providers/email/link and returns OtpSentResponse',
        () async {
          const request = LinkEmailProviderRequest(
            email: 'user@example.com',
            password: 'SecurePass123!',
          );

          dioAdapter.onPost(
            '/api/v1/auth/providers/email/link',
            (server) => server.reply(200, {'expiresInSeconds': 300}),
            data: request.toJson(),
          );

          final result = await repository.linkEmail(request);

          expect(result.expiresInSeconds, 300);
        },
      );
    });

    group('linkGoogle', () {
      test('sends POST to /api/v1/auth/providers/google/link', () async {
        const request = LinkGoogleProviderRequest(idToken: 'google-jwt');

        dioAdapter.onPost(
          '/api/v1/auth/providers/google/link',
          (server) => server.reply(204, null),
          data: request.toJson(),
        );

        await expectLater(repository.linkGoogle(request), completes);
      });
    });

    group('linkApple', () {
      test('sends POST to /api/v1/auth/providers/apple/link', () async {
        const request = LinkAppleProviderRequest(idToken: 'apple-jwt');

        dioAdapter.onPost(
          '/api/v1/auth/providers/apple/link',
          (server) => server.reply(204, null),
          data: request.toJson(),
        );

        await expectLater(repository.linkApple(request), completes);
      });
    });

    group('unlinkProvider', () {
      test('sends DELETE to /api/v1/auth/providers/{type}', () async {
        dioAdapter.onDelete(
          '/api/v1/auth/providers/google',
          (server) => server.reply(204, null),
        );

        await expectLater(repository.unlinkProvider('google'), completes);
      });
    });
  });
}
