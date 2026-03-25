// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/rest/session/session_repository.dart';
import 'package:hexatuneapp/src/core/rest/session/models/revoke_sessions_response.dart';
import 'package:hexatuneapp/src/core/rest/session/models/session_response.dart';
import 'package:hexatuneapp/src/core/config/api_endpoints.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_client.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockLogService extends Mock implements LogService {}

void main() {
  group('SessionRepository', () {
    late Dio dio;
    late DioAdapter dioAdapter;
    late MockApiClient mockApiClient;
    late MockLogService mockLogService;
    late SessionRepository repository;

    final sessionJson = {
      'id': 'sess-001',
      'accountId': 'acc-001',
      'deviceId': 'dev-001',
      'createdAt': '2025-01-01T00:00:00Z',
      'expiresAt': '2025-02-01T00:00:00Z',
      'lastActivityAt': '2025-01-15T00:00:00Z',
    };

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://test.api'));
      dioAdapter = DioAdapter(dio: dio);
      mockApiClient = MockApiClient();
      mockLogService = MockLogService();

      when(() => mockApiClient.dio).thenReturn(dio);
      when(
        () => mockLogService.debug(any(), category: any(named: 'category')),
      ).thenReturn(null);

      repository = SessionRepository(mockApiClient, mockLogService);
    });

    group('listSessions', () {
      test('sends GET and returns paginated sessions', () async {
        dioAdapter.onGet(
          ApiEndpoints.sessions,
          (server) => server.reply(200, {
            'data': [sessionJson],
            'pagination': {'has_more': false, 'limit': 20},
          }),
        );

        final result = await repository.listSessions();

        expect(result.data, hasLength(1));
        expect(result.data.first, isA<SessionResponse>());
        expect(result.data.first.id, 'sess-001');
      });

      test('passes pagination params', () async {
        const params = PaginationParams(limit: 10);
        dioAdapter.onGet(
          ApiEndpoints.sessions,
          (server) => server.reply(200, {
            'data': <Map<String, dynamic>>[],
            'pagination': {'has_more': false, 'limit': 10},
          }),
          queryParameters: params.toQueryParameters(),
        );

        final result = await repository.listSessions(params: params);

        expect(result.data, isEmpty);
      });
    });

    group('revokeAll', () {
      test('sends DELETE to sessions endpoint', () async {
        dioAdapter.onDelete(
          ApiEndpoints.sessions,
          (server) => server.reply(204, null),
        );

        await expectLater(repository.revokeAll(), completes);
      });
    });

    group('revokeOthers', () {
      test('sends DELETE and returns revoked count', () async {
        dioAdapter.onDelete(
          ApiEndpoints.sessionsOthers,
          (server) => server.reply(200, {'revokedCount': 3}),
        );

        final result = await repository.revokeOthers();

        expect(result, isA<RevokeSessionsResponse>());
        expect(result.revokedCount, 3);
      });
    });
  });
}
