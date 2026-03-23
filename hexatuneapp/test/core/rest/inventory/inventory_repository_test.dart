// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/rest/inventory/inventory_repository.dart';
import 'package:hexatuneapp/src/core/rest/inventory/models/image_url_response.dart';
import 'package:hexatuneapp/src/core/rest/inventory/models/inventory_response.dart';
import 'package:hexatuneapp/src/core/config/api_endpoints.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_client.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockLogService extends Mock implements LogService {}

void main() {
  group('InventoryRepository', () {
    late Dio dio;
    late DioAdapter dioAdapter;
    late MockApiClient mockApiClient;
    late MockLogService mockLogService;
    late InventoryRepository repository;

    final inventoryJson = {
      'id': 'inv-001',
      'categoryId': 'cat-001',
      'name': 'Red Paint',
      'labels': ['oil'],
      'imageUploaded': true,
      'createdAt': '2025-01-01T00:00:00Z',
      'updatedAt': '2025-01-02T00:00:00Z',
      'description': 'A red oil paint',
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

      repository = InventoryRepository(mockApiClient, mockLogService);
    });

    group('list', () {
      test('sends GET and returns paginated inventories', () async {
        dioAdapter.onGet(
          ApiEndpoints.inventories,
          (server) => server.reply(200, {
            'data': [inventoryJson],
            'pagination': {'has_more': false, 'limit': 20},
          }),
        );

        final result = await repository.list();

        expect(result.data, hasLength(1));
        expect(result.data.first, isA<InventoryResponse>());
        expect(result.data.first.name, 'Red Paint');
      });

      test('passes pagination params', () async {
        const params = PaginationParams(limit: 5);
        dioAdapter.onGet(
          ApiEndpoints.inventories,
          (server) => server.reply(200, {
            'data': <Map<String, dynamic>>[],
            'pagination': {'has_more': false, 'limit': 5},
          }),
          queryParameters: params.toQueryParameters(),
        );

        final result = await repository.list(params: params);

        expect(result.data, isEmpty);
      });

      test('passes labels filter param', () async {
        const params = PaginationParams(labels: 'oil');
        dioAdapter.onGet(
          ApiEndpoints.inventories,
          (server) => server.reply(200, {
            'data': [inventoryJson],
            'pagination': {'has_more': false, 'limit': 20},
          }),
          queryParameters: params.toQueryParameters(),
        );

        final result = await repository.list(params: params);

        expect(result.data, hasLength(1));
      });
    });

    group('getById', () {
      test('sends GET with id and returns inventory', () async {
        dioAdapter.onGet(
          ApiEndpoints.inventory('inv-001'),
          (server) => server.reply(200, inventoryJson),
        );

        final result = await repository.getById('inv-001');

        expect(result.id, 'inv-001');
        expect(result.name, 'Red Paint');
        expect(result.description, 'A red oil paint');
      });
    });

    group('delete', () {
      test('sends DELETE and completes', () async {
        dioAdapter.onDelete(
          ApiEndpoints.inventory('inv-001'),
          (server) => server.reply(204, null),
        );

        await expectLater(repository.delete('inv-001'), completes);
      });
    });

    group('getImageUrl', () {
      test('sends GET and returns image URL', () async {
        dioAdapter.onGet(
          ApiEndpoints.inventoryImage('inv-001'),
          (server) =>
              server.reply(200, {'url': 'https://cdn.example.com/image.png'}),
        );

        final result = await repository.getImageUrl('inv-001');

        expect(result, isA<ImageUrlResponse>());
        expect(result.url, 'https://cdn.example.com/image.png');
      });
    });

    group('listLabels', () {
      test('sends GET and returns label list', () async {
        dioAdapter.onGet(
          ApiEndpoints.inventoryLabels,
          (server) => server.reply(200, ['oil', 'acrylic', 'watercolor']),
        );

        final result = await repository.listLabels();

        expect(result, ['oil', 'acrylic', 'watercolor']);
      });

      test('returns empty list when no labels exist', () async {
        dioAdapter.onGet(
          ApiEndpoints.inventoryLabels,
          (server) => server.reply(200, <String>[]),
        );

        final result = await repository.listLabels();

        expect(result, isEmpty);
      });
    });

    group('create', () {
      test('sends POST and returns created inventory', () async {
        dioAdapter.onPost(
          ApiEndpoints.inventories,
          (server) => server.reply(201, inventoryJson),
          data: Matchers.any,
        );

        final result = await repository.create(
          categoryId: 'cat-001',
          name: 'Red Paint',
        );

        expect(result, isA<InventoryResponse>());
        expect(result.name, 'Red Paint');
      });

      test('includes image bytes as multipart when provided', () async {
        dioAdapter.onPost(
          ApiEndpoints.inventories,
          (server) => server.reply(201, inventoryJson),
          data: Matchers.any,
        );

        final result = await repository.create(
          categoryId: 'cat-001',
          name: 'Red Paint',
          imageBytes: Uint8List.fromList([0xFF, 0xD8, 0xFF, 0xE0]),
        );

        expect(result, isA<InventoryResponse>());
      });

      test('sends optional fields when provided', () async {
        dioAdapter.onPost(
          ApiEndpoints.inventories,
          (server) => server.reply(201, inventoryJson),
          data: Matchers.any,
        );

        final result = await repository.create(
          categoryId: 'cat-001',
          name: 'Red Paint',
          description: 'A red oil paint',
          labels: ['oil'],
        );

        expect(result.name, 'Red Paint');
      });
    });

    group('update', () {
      test('sends PATCH and returns updated inventory', () async {
        dioAdapter.onPatch(
          ApiEndpoints.inventory('inv-001'),
          (server) => server.reply(200, inventoryJson),
          data: Matchers.any,
        );

        final result = await repository.update(
          'inv-001',
          name: 'Updated Paint',
        );

        expect(result, isA<InventoryResponse>());
      });

      test('includes image bytes as multipart when provided', () async {
        dioAdapter.onPatch(
          ApiEndpoints.inventory('inv-001'),
          (server) => server.reply(200, inventoryJson),
          data: Matchers.any,
        );

        final result = await repository.update(
          'inv-001',
          imageBytes: Uint8List.fromList([0xFF, 0xD8, 0xFF, 0xE0]),
        );

        expect(result, isA<InventoryResponse>());
      });
    });
  });
}
