// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/config/api_endpoints.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_client.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';
import 'package:hexatuneapp/src/core/rest/flow/flow_repository.dart';
import 'package:hexatuneapp/src/core/rest/flow/models/flow_detail_response.dart';
import 'package:hexatuneapp/src/core/rest/flow/models/flow_response.dart';
import 'package:hexatuneapp/src/core/rest/inventory/models/image_url_response.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockLogService extends Mock implements LogService {}

void main() {
  group('FlowRepository', () {
    late Dio dio;
    late DioAdapter dioAdapter;
    late MockApiClient mockApiClient;
    late MockLogService mockLogService;
    late FlowRepository repository;

    final flowJson = {
      'id': 'flow-001',
      'name': 'Morning Routine',
      'description': 'A calming morning flow',
      'labels': ['morning'],
      'imageUploaded': true,
      'createdAt': '2026-01-01T00:00:00Z',
      'updatedAt': '2026-01-02T00:00:00Z',
    };

    final flowDetailJson = {
      'id': 'flow-001',
      'name': 'Morning Routine',
      'description': 'A calming morning flow',
      'labels': ['morning'],
      'imageUploaded': true,
      'steps': [
        {
          'id': 'fs-001',
          'stepId': 'step-001',
          'sortOrder': 1,
          'quantity': 3,
          'timeMs': 60000,
        },
        {
          'id': 'fs-002',
          'stepId': 'step-002',
          'sortOrder': 2,
          'quantity': 1,
          'timeMs': 30000,
        },
      ],
      'createdAt': '2026-01-01T00:00:00Z',
      'updatedAt': '2026-01-02T00:00:00Z',
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

      repository = FlowRepository(mockApiClient, mockLogService);
    });

    group('list', () {
      test('sends GET and returns paginated flows', () async {
        dioAdapter.onGet(
          ApiEndpoints.flows,
          (server) => server.reply(200, {
            'data': [flowJson],
            'pagination': {'has_more': false, 'limit': 20},
          }),
        );

        final result = await repository.list();

        expect(result.data, hasLength(1));
        expect(result.data.first, isA<FlowResponse>());
        expect(result.data.first.name, 'Morning Routine');
      });

      test('passes pagination params', () async {
        const params = PaginationParams(limit: 5);
        dioAdapter.onGet(
          ApiEndpoints.flows,
          (server) => server.reply(200, {
            'data': <Map<String, dynamic>>[],
            'pagination': {'has_more': false, 'limit': 5},
          }),
          queryParameters: params.toQueryParameters(),
        );

        final result = await repository.list(params: params);

        expect(result.data, isEmpty);
      });

      test('passes packageId and locale filter params', () async {
        dioAdapter.onGet(
          ApiEndpoints.flows,
          (server) => server.reply(200, {
            'data': [flowJson],
            'pagination': {'has_more': false, 'limit': 20},
          }),
          queryParameters: {'package_id': 'pkg-001', 'locale': 'en'},
        );

        final result = await repository.list(
          packageId: 'pkg-001',
          locale: 'en',
        );

        expect(result.data, hasLength(1));
        expect(result.data.first.name, 'Morning Routine');
      });

      test('passes labels filter param', () async {
        const params = PaginationParams(labels: 'morning');
        dioAdapter.onGet(
          ApiEndpoints.flows,
          (server) => server.reply(200, {
            'data': [flowJson],
            'pagination': {'has_more': false, 'limit': 20},
          }),
          queryParameters: params.toQueryParameters(),
        );

        final result = await repository.list(params: params);

        expect(result.data, hasLength(1));
      });
    });

    group('getById', () {
      test('sends GET with id and returns flow detail with steps', () async {
        dioAdapter.onGet(
          ApiEndpoints.flow('flow-001'),
          (server) => server.reply(200, flowDetailJson),
        );

        final result = await repository.getById('flow-001');

        expect(result, isA<FlowDetailResponse>());
        expect(result.id, 'flow-001');
        expect(result.name, 'Morning Routine');
        expect(result.steps, hasLength(2));
        expect(result.steps.first.stepId, 'step-001');
        expect(result.steps.first.sortOrder, 1);
        expect(result.steps.first.quantity, 3);
        expect(result.steps.first.timeMs, 60000);
        expect(result.steps.last.stepId, 'step-002');
      });
    });

    group('getImageUrl', () {
      test('sends GET and returns image URL', () async {
        dioAdapter.onGet(
          ApiEndpoints.flowImage('flow-001'),
          (server) =>
              server.reply(200, {'url': 'https://cdn.example.com/flow.png'}),
        );

        final result = await repository.getImageUrl('flow-001');

        expect(result, isA<ImageUrlResponse>());
        expect(result.url, 'https://cdn.example.com/flow.png');
      });
    });

    group('listLabels', () {
      test('sends GET and returns label list', () async {
        dioAdapter.onGet(
          ApiEndpoints.flowLabels,
          (server) => server.reply(200, ['morning', 'evening', 'therapy']),
        );

        final result = await repository.listLabels();

        expect(result, ['morning', 'evening', 'therapy']);
      });

      test('returns empty list when no labels exist', () async {
        dioAdapter.onGet(
          ApiEndpoints.flowLabels,
          (server) => server.reply(200, <String>[]),
        );

        final result = await repository.listLabels();

        expect(result, isEmpty);
      });
    });
  });
}
