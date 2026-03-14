// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/rest/audit/audit_repository.dart';
import 'package:hexatuneapp/src/core/rest/audit/models/audit_log_dto.dart';
import 'package:hexatuneapp/src/core/config/api_endpoints.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_client.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';
import 'package:hexatuneapp/src/core/rest/audit/models/audit_log_query_params.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockLogService extends Mock implements LogService {}

void main() {
  group('AuditRepository', () {
    late Dio dio;
    late DioAdapter dioAdapter;
    late MockApiClient mockApiClient;
    late MockLogService mockLogService;
    late AuditRepository repository;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://test.api'));
      dioAdapter = DioAdapter(dio: dio);
      mockApiClient = MockApiClient();
      mockLogService = MockLogService();

      when(() => mockApiClient.dio).thenReturn(dio);
      when(
        () => mockLogService.debug(any(), category: any(named: 'category')),
      ).thenReturn(null);

      repository = AuditRepository(mockApiClient, mockLogService);
    });

    group('queryLogs', () {
      final paginatedResponse = {
        'data': [
          {
            'id': 'log-001',
            'tenantId': 'tenant-001',
            'actorType': 'user',
            'actorId': 'user-001',
            'action': 'login',
            'resourceType': 'session',
            'resourceId': 'sess-001',
            'outcome': 'success',
            'severity': 'info',
            'traceId': 'trace-001',
            'containsPii': false,
            'occurredAt': '2025-01-01T00:00:00Z',
            'createdAt': '2025-01-01T00:00:01Z',
          },
        ],
        'pagination': {'has_more': false, 'limit': 20},
      };

      test(
        'sends GET to /api/v1/audit/logs and returns paginated response',
        () async {
          dioAdapter.onGet(
            ApiEndpoints.auditLogs,
            (server) => server.reply(200, paginatedResponse),
          );

          final result = await repository.queryLogs();

          expect(result.data, hasLength(1));
          expect(result.data.first, isA<AuditLogDto>());
          expect(result.data.first.id, 'log-001');
          expect(result.data.first.action, 'login');
          expect(result.hasMore, false);
        },
      );

      test('passes pagination params', () async {
        const params = PaginationParams(cursor: 'abc', limit: 10);
        dioAdapter.onGet(
          ApiEndpoints.auditLogs,
          (server) => server.reply(200, paginatedResponse),
          queryParameters: params.toQueryParameters(),
        );

        final result = await repository.queryLogs(params: params);

        expect(result.data, hasLength(1));
      });

      test('passes query filters', () async {
        const filters = AuditLogQueryParams(
          actorType: 'user',
          action: 'login',
          severity: 'info',
        );
        dioAdapter.onGet(
          ApiEndpoints.auditLogs,
          (server) => server.reply(200, paginatedResponse),
          queryParameters: filters.toQueryParameters(),
        );

        final result = await repository.queryLogs(filters: filters);

        expect(result.data, hasLength(1));
      });

      test('passes resourceId filter param', () async {
        const filters = AuditLogQueryParams(
          resourceType: 'session',
          resourceId: 'sess-001',
        );
        dioAdapter.onGet(
          ApiEndpoints.auditLogs,
          (server) => server.reply(200, paginatedResponse),
          queryParameters: filters.toQueryParameters(),
        );

        final result = await repository.queryLogs(filters: filters);

        expect(result.data, hasLength(1));
        expect(result.data.first.resourceId, 'sess-001');
      });
    });
  });
}
