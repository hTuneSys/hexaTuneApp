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
import 'package:hexatuneapp/src/core/rest/inventory/models/image_url_response.dart';
import 'package:hexatuneapp/src/core/rest/step/models/step_response.dart';
import 'package:hexatuneapp/src/core/rest/step/step_repository.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockLogService extends Mock implements LogService {}

void main() {
  group('StepRepository', () {
    late Dio dio;
    late DioAdapter dioAdapter;
    late MockApiClient mockApiClient;
    late MockLogService mockLogService;
    late StepRepository repository;

    final stepJson = {
      'id': 'step-001',
      'name': 'Deep Breathing',
      'description': 'Slow deep breathing exercise',
      'labels': ['relaxation'],
      'imageUploaded': true,
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

      repository = StepRepository(mockApiClient, mockLogService);
    });

    group('list', () {
      test('sends GET and returns paginated steps', () async {
        dioAdapter.onGet(
          ApiEndpoints.steps,
          (server) => server.reply(200, {
            'data': [stepJson],
            'pagination': {'has_more': false, 'limit': 20},
          }),
        );

        final result = await repository.list();

        expect(result.data, hasLength(1));
        expect(result.data.first, isA<StepResponse>());
        expect(result.data.first.name, 'Deep Breathing');
      });

      test('passes pagination params', () async {
        const params = PaginationParams(limit: 5);
        dioAdapter.onGet(
          ApiEndpoints.steps,
          (server) => server.reply(200, {
            'data': <Map<String, dynamic>>[],
            'pagination': {'has_more': false, 'limit': 5},
          }),
          queryParameters: params.toQueryParameters(),
        );

        final result = await repository.list(params: params);

        expect(result.data, isEmpty);
      });

      test('passes locale filter param', () async {
        dioAdapter.onGet(
          ApiEndpoints.steps,
          (server) => server.reply(200, {
            'data': [stepJson],
            'pagination': {'has_more': false, 'limit': 20},
          }),
          queryParameters: {'locale': 'de'},
        );

        final result = await repository.list(locale: 'de');

        expect(result.data, hasLength(1));
        expect(result.data.first.name, 'Deep Breathing');
      });

      test('passes labels filter param', () async {
        const params = PaginationParams(labels: 'relaxation');
        dioAdapter.onGet(
          ApiEndpoints.steps,
          (server) => server.reply(200, {
            'data': [stepJson],
            'pagination': {'has_more': false, 'limit': 20},
          }),
          queryParameters: params.toQueryParameters(),
        );

        final result = await repository.list(params: params);

        expect(result.data, hasLength(1));
      });
    });

    group('getById', () {
      test('sends GET with id and returns step', () async {
        dioAdapter.onGet(
          ApiEndpoints.step('step-001'),
          (server) => server.reply(200, stepJson),
        );

        final result = await repository.getById('step-001');

        expect(result.id, 'step-001');
        expect(result.name, 'Deep Breathing');
        expect(result.description, 'Slow deep breathing exercise');
      });
    });

    group('getImageUrl', () {
      test('sends GET and returns image URL', () async {
        dioAdapter.onGet(
          ApiEndpoints.stepImage('step-001'),
          (server) =>
              server.reply(200, {'url': 'https://cdn.example.com/step.png'}),
        );

        final result = await repository.getImageUrl('step-001');

        expect(result, isA<ImageUrlResponse>());
        expect(result.url, 'https://cdn.example.com/step.png');
      });
    });

    group('listLabels', () {
      test('sends GET and returns label list', () async {
        dioAdapter.onGet(
          ApiEndpoints.stepLabels,
          (server) => server.reply(200, ['relaxation', 'focus', 'energy']),
        );

        final result = await repository.listLabels();

        expect(result, ['relaxation', 'focus', 'energy']);
      });

      test('returns empty list when no labels exist', () async {
        dioAdapter.onGet(
          ApiEndpoints.stepLabels,
          (server) => server.reply(200, <String>[]),
        );

        final result = await repository.listLabels();

        expect(result, isEmpty);
      });
    });
  });
}
