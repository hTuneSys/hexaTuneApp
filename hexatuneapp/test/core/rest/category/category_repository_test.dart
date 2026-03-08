// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/rest/category/category_repository.dart';
import 'package:hexatuneapp/src/core/rest/category/models/category_response.dart';
import 'package:hexatuneapp/src/core/rest/category/models/create_category_request.dart';
import 'package:hexatuneapp/src/core/rest/category/models/update_category_request.dart';
import 'package:hexatuneapp/src/core/config/api_endpoints.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_client.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockLogService extends Mock implements LogService {}

void main() {
  group('CategoryRepository', () {
    late Dio dio;
    late DioAdapter dioAdapter;
    late MockApiClient mockApiClient;
    late MockLogService mockLogService;
    late CategoryRepository repository;

    final categoryJson = {
      'id': 'cat-001',
      'name': 'Paints',
      'labels': ['oil', 'acrylic'],
      'createdAt': '2025-01-01T00:00:00Z',
      'updatedAt': '2025-01-02T00:00:00Z',
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

      repository = CategoryRepository(mockApiClient, mockLogService);
    });

    group('list', () {
      test('sends GET and returns paginated categories', () async {
        dioAdapter.onGet(
          ApiEndpoints.categories,
          (server) => server.reply(200, {
            'data': [categoryJson],
            'pagination': {'has_more': false, 'limit': 20},
          }),
        );

        final result = await repository.list();

        expect(result.data, hasLength(1));
        expect(result.data.first, isA<CategoryResponse>());
        expect(result.data.first.name, 'Paints');
      });

      test('passes pagination params', () async {
        const params = PaginationParams(limit: 5);
        dioAdapter.onGet(
          ApiEndpoints.categories,
          (server) => server.reply(200, {
            'data': <Map<String, dynamic>>[],
            'pagination': {'has_more': false, 'limit': 5},
          }),
          queryParameters: params.toQueryParameters(),
        );

        final result = await repository.list(params: params);

        expect(result.data, isEmpty);
      });
    });

    group('create', () {
      test('sends POST and returns created category', () async {
        const request = CreateCategoryRequest(name: 'Paints', labels: ['oil']);

        dioAdapter.onPost(
          ApiEndpoints.categories,
          (server) => server.reply(201, categoryJson),
          data: request.toJson(),
        );

        final result = await repository.create(request);

        expect(result, isA<CategoryResponse>());
        expect(result.name, 'Paints');
      });
    });

    group('getById', () {
      test('sends GET with id and returns category', () async {
        dioAdapter.onGet(
          ApiEndpoints.category('cat-001'),
          (server) => server.reply(200, categoryJson),
        );

        final result = await repository.getById('cat-001');

        expect(result.id, 'cat-001');
      });
    });

    group('update', () {
      test('sends PATCH and returns updated category', () async {
        const request = UpdateCategoryRequest(name: 'Updated Paints');

        dioAdapter.onPatch(
          ApiEndpoints.category('cat-001'),
          (server) =>
              server.reply(200, {...categoryJson, 'name': 'Updated Paints'}),
          data: request.toJson(),
        );

        final result = await repository.update('cat-001', request);

        expect(result.name, 'Updated Paints');
      });
    });

    group('delete', () {
      test('sends DELETE and completes', () async {
        dioAdapter.onDelete(
          ApiEndpoints.category('cat-001'),
          (server) => server.reply(204, null),
        );

        await expectLater(repository.delete('cat-001'), completes);
      });
    });
  });
}
