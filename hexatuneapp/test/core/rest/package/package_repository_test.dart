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
import 'package:hexatuneapp/src/core/rest/package/models/package_response.dart';
import 'package:hexatuneapp/src/core/rest/package/package_repository.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockLogService extends Mock implements LogService {}

void main() {
  group('PackageRepository', () {
    late Dio dio;
    late DioAdapter dioAdapter;
    late MockApiClient mockApiClient;
    late MockLogService mockLogService;
    late PackageRepository repository;

    final packageJson = {
      'id': 'pkg-001',
      'name': 'Relaxation Suite',
      'description': 'A package of relaxation flows',
      'labels': ['wellness'],
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

      repository = PackageRepository(mockApiClient, mockLogService);
    });

    group('list', () {
      test('sends GET and returns paginated packages', () async {
        dioAdapter.onGet(
          ApiEndpoints.packages,
          (server) => server.reply(200, {
            'data': [packageJson],
            'pagination': {'has_more': false, 'limit': 20},
          }),
        );

        final result = await repository.list();

        expect(result.data, hasLength(1));
        expect(result.data.first, isA<PackageResponse>());
        expect(result.data.first.name, 'Relaxation Suite');
      });

      test('passes pagination params', () async {
        const params = PaginationParams(limit: 5);
        dioAdapter.onGet(
          ApiEndpoints.packages,
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
          ApiEndpoints.packages,
          (server) => server.reply(200, {
            'data': [packageJson],
            'pagination': {'has_more': false, 'limit': 20},
          }),
          queryParameters: {'locale': 'fr'},
        );

        final result = await repository.list(locale: 'fr');

        expect(result.data, hasLength(1));
        expect(result.data.first.name, 'Relaxation Suite');
      });

      test('passes labels filter param', () async {
        const params = PaginationParams(labels: 'wellness');
        dioAdapter.onGet(
          ApiEndpoints.packages,
          (server) => server.reply(200, {
            'data': [packageJson],
            'pagination': {'has_more': false, 'limit': 20},
          }),
          queryParameters: params.toQueryParameters(),
        );

        final result = await repository.list(params: params);

        expect(result.data, hasLength(1));
      });
    });

    group('getById', () {
      test('sends GET with id and returns package', () async {
        dioAdapter.onGet(
          ApiEndpoints.package('pkg-001'),
          (server) => server.reply(200, packageJson),
        );

        final result = await repository.getById('pkg-001');

        expect(result.id, 'pkg-001');
        expect(result.name, 'Relaxation Suite');
        expect(result.description, 'A package of relaxation flows');
      });
    });

    group('getImageUrl', () {
      test('sends GET and returns image URL', () async {
        dioAdapter.onGet(
          ApiEndpoints.packageImage('pkg-001'),
          (server) =>
              server.reply(200, {'url': 'https://cdn.example.com/package.png'}),
        );

        final result = await repository.getImageUrl('pkg-001');

        expect(result, isA<ImageUrlResponse>());
        expect(result.url, 'https://cdn.example.com/package.png');
      });
    });

    group('listLabels', () {
      test('sends GET and returns label list', () async {
        dioAdapter.onGet(
          ApiEndpoints.packageLabels,
          (server) => server.reply(200, ['wellness', 'therapy', 'sleep']),
        );

        final result = await repository.listLabels();

        expect(result, ['wellness', 'therapy', 'sleep']);
      });

      test('returns empty list when no labels exist', () async {
        dioAdapter.onGet(
          ApiEndpoints.packageLabels,
          (server) => server.reply(200, <String>[]),
        );

        final result = await repository.listLabels();

        expect(result, isEmpty);
      });
    });
  });
}
