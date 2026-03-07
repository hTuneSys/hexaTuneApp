// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/auth/models/switch_tenant_request.dart';
import 'package:hexatuneapp/src/core/auth/models/switch_tenant_response.dart';
import 'package:hexatuneapp/src/core/auth/models/tenant_membership_response.dart';
import 'package:hexatuneapp/src/core/auth/tenant_repository.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_client.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockLogService extends Mock implements LogService {}

void main() {
  group('TenantRepository', () {
    late Dio dio;
    late DioAdapter dioAdapter;
    late MockApiClient mockApiClient;
    late MockLogService mockLogService;
    late TenantRepository repository;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://test.api'));
      dioAdapter = DioAdapter(dio: dio);
      mockApiClient = MockApiClient();
      mockLogService = MockLogService();

      when(() => mockApiClient.dio).thenReturn(dio);
      when(
        () => mockLogService.debug(any(), category: any(named: 'category')),
      ).thenReturn(null);

      repository = TenantRepository(mockApiClient, mockLogService);
    });

    group('listTenantMemberships', () {
      test(
        'sends GET to /api/v1/accounts/me/tenants and returns list',
        () async {
          dioAdapter.onGet(
            '/api/v1/accounts/me/tenants',
            (server) => server.reply(200, [
              {
                'id': 'mem-001',
                'tenantId': 'tid-001',
                'role': 'owner',
                'status': 'active',
                'isOwner': true,
                'joinedAt': '2025-01-01T00:00:00Z',
              },
              {
                'id': 'mem-002',
                'tenantId': 'tid-002',
                'role': 'viewer',
                'status': 'invited',
                'isOwner': false,
              },
            ]),
          );

          final result = await repository.listTenantMemberships();

          expect(result, hasLength(2));
          expect(result[0], isA<TenantMembershipResponse>());
          expect(result[0].tenantId, 'tid-001');
          expect(result[0].isOwner, isTrue);
          expect(result[0].joinedAt, '2025-01-01T00:00:00Z');
          expect(result[1].tenantId, 'tid-002');
          expect(result[1].isOwner, isFalse);
          expect(result[1].joinedAt, isNull);
        },
      );

      test('returns empty list when no memberships', () async {
        dioAdapter.onGet(
          '/api/v1/accounts/me/tenants',
          (server) => server.reply(200, <dynamic>[]),
        );

        final result = await repository.listTenantMemberships();

        expect(result, isEmpty);
      });
    });

    group('switchTenant', () {
      test(
        'sends POST to /api/v1/auth/switch-tenant and returns new tokens',
        () async {
          const request = SwitchTenantRequest(
            tenantId: '019c9646-e0ec-7e28-9fce-95a20324e7fb',
          );

          dioAdapter.onPost(
            '/api/v1/auth/switch-tenant',
            (server) => server.reply(200, {
              'accessToken': 'new-at',
              'refreshToken': 'new-rt',
              'sessionId': 'new-sid',
            }),
            data: request.toJson(),
          );

          final result = await repository.switchTenant(request);

          expect(result, isA<SwitchTenantResponse>());
          expect(result.accessToken, 'new-at');
          expect(result.refreshToken, 'new-rt');
          expect(result.sessionId, 'new-sid');
        },
      );
    });
  });
}
