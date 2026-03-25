// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/rest/account/account_repository.dart';
import 'package:hexatuneapp/src/core/rest/account/models/account_response.dart';
import 'package:hexatuneapp/src/core/rest/account/models/profile_response.dart';
import 'package:hexatuneapp/src/core/rest/account/models/update_profile_request.dart';
import 'package:hexatuneapp/src/core/config/api_endpoints.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_client.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockLogService extends Mock implements LogService {}

void main() {
  group('AccountRepository', () {
    late Dio dio;
    late DioAdapter dioAdapter;
    late MockApiClient mockApiClient;
    late MockLogService mockLogService;
    late AccountRepository repository;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://test.api'));
      dioAdapter = DioAdapter(dio: dio);
      mockApiClient = MockApiClient();
      mockLogService = MockLogService();

      when(() => mockApiClient.dio).thenReturn(dio);
      when(
        () => mockLogService.debug(any(), category: any(named: 'category')),
      ).thenReturn(null);

      repository = AccountRepository(mockApiClient, mockLogService);
    });

    group('getAccount', () {
      test(
        'sends GET to /api/v1/accounts/me and returns AccountResponse',
        () async {
          dioAdapter.onGet(
            ApiEndpoints.account,
            (server) => server.reply(200, {
              'id': 'acc-001',
              'status': 'active',
              'createdAt': '2025-01-01T00:00:00Z',
              'updatedAt': '2025-01-02T00:00:00Z',
            }),
          );

          final result = await repository.getAccount();

          expect(result, isA<AccountResponse>());
          expect(result.id, 'acc-001');
          expect(result.status, 'active');
        },
      );

      test('handles optional fields', () async {
        dioAdapter.onGet(
          ApiEndpoints.account,
          (server) => server.reply(200, {
            'id': 'acc-002',
            'status': 'locked',
            'createdAt': '2025-01-01T00:00:00Z',
            'updatedAt': '2025-01-02T00:00:00Z',
            'lockedAt': '2025-01-03T00:00:00Z',
            'suspendedAt': '2025-01-04T00:00:00Z',
          }),
        );

        final result = await repository.getAccount();

        expect(result.lockedAt, '2025-01-03T00:00:00Z');
        expect(result.suspendedAt, '2025-01-04T00:00:00Z');
      });
    });

    group('getProfile', () {
      test(
        'sends GET to /api/v1/accounts/me/profile and returns ProfileResponse',
        () async {
          dioAdapter.onGet(
            ApiEndpoints.profile,
            (server) => server.reply(200, {
              'accountId': 'acc-001',
              'displayName': 'Test User',
              'avatarUrl': 'https://example.com/avatar.png',
              'bio': 'A test bio',
              'createdAt': '2025-01-01T00:00:00Z',
              'updatedAt': '2025-01-02T00:00:00Z',
            }),
          );

          final result = await repository.getProfile();

          expect(result, isA<ProfileResponse>());
          expect(result.accountId, 'acc-001');
          expect(result.displayName, 'Test User');
          expect(result.avatarUrl, 'https://example.com/avatar.png');
          expect(result.bio, 'A test bio');
        },
      );

      test('handles null optional fields', () async {
        dioAdapter.onGet(
          ApiEndpoints.profile,
          (server) => server.reply(200, {
            'accountId': 'acc-001',
            'createdAt': '2025-01-01T00:00:00Z',
            'updatedAt': '2025-01-02T00:00:00Z',
          }),
        );

        final result = await repository.getProfile();

        expect(result.displayName, isNull);
        expect(result.avatarUrl, isNull);
        expect(result.bio, isNull);
      });
    });

    group('updateProfile', () {
      test(
        'sends PATCH to /api/v1/accounts/me/profile and returns updated ProfileResponse',
        () async {
          const request = UpdateProfileRequest(
            displayName: 'New Name',
            bio: 'New bio',
          );

          dioAdapter.onPatch(
            ApiEndpoints.profile,
            (server) => server.reply(200, {
              'accountId': 'acc-001',
              'displayName': 'New Name',
              'bio': 'New bio',
              'createdAt': '2025-01-01T00:00:00Z',
              'updatedAt': '2025-01-03T00:00:00Z',
            }),
            data: request.toJson(),
          );

          final result = await repository.updateProfile(request);

          expect(result, isA<ProfileResponse>());
          expect(result.displayName, 'New Name');
          expect(result.bio, 'New bio');
        },
      );
    });
  });
}
