// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/rest/formula/formula_repository.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/add_formula_item_entry.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/add_formula_items_request.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/create_formula_request.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/formula_detail_response.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/formula_response.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/reorder_entry.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/reorder_formula_items_request.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/update_formula_item_quantity_request.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/update_formula_request.dart';
import 'package:hexatuneapp/src/core/config/api_endpoints.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_client.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockLogService extends Mock implements LogService {}

void main() {
  group('FormulaRepository', () {
    late Dio dio;
    late DioAdapter dioAdapter;
    late MockApiClient mockApiClient;
    late MockLogService mockLogService;
    late FormulaRepository repository;

    final formulaJson = {
      'id': 'frm-001',
      'name': 'Test Formula',
      'labels': ['test'],
      'createdAt': '2025-01-01T00:00:00Z',
      'updatedAt': '2025-01-02T00:00:00Z',
    };

    final formulaItemJson = {
      'id': 'item-001',
      'inventoryId': 'inv-001',
      'sortOrder': 1,
      'quantity': 10,
      'timeMs': 1000,
      'createdAt': '2025-01-01T00:00:00Z',
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

      repository = FormulaRepository(mockApiClient, mockLogService);
    });

    group('list', () {
      test('sends GET and returns paginated formulas', () async {
        dioAdapter.onGet(
          ApiEndpoints.formulas,
          (server) => server.reply(200, {
            'data': [formulaJson],
            'pagination': {'has_more': false, 'limit': 20},
          }),
        );

        final result = await repository.list();

        expect(result.data, hasLength(1));
        expect(result.data.first, isA<FormulaResponse>());
        expect(result.data.first.name, 'Test Formula');
      });

      test('passes pagination params', () async {
        const params = PaginationParams(limit: 5);
        dioAdapter.onGet(
          ApiEndpoints.formulas,
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
        const params = PaginationParams(labels: 'rock,jazz');
        dioAdapter.onGet(
          ApiEndpoints.formulas,
          (server) => server.reply(200, {
            'data': [formulaJson],
            'pagination': {'has_more': false, 'limit': 20},
          }),
          queryParameters: params.toQueryParameters(),
        );

        final result = await repository.list(params: params);

        expect(result.data, hasLength(1));
      });
    });

    group('create', () {
      test('sends POST and returns created formula', () async {
        const request = CreateFormulaRequest(
          name: 'Test Formula',
          labels: ['test'],
        );

        dioAdapter.onPost(
          ApiEndpoints.formulas,
          (server) => server.reply(201, formulaJson),
          data: request.toJson(),
        );

        final result = await repository.create(request);

        expect(result, isA<FormulaResponse>());
        expect(result.name, 'Test Formula');
      });
    });

    group('getById', () {
      test('sends GET and returns formula detail', () async {
        dioAdapter.onGet(
          ApiEndpoints.formula('frm-001'),
          (server) => server.reply(200, {
            ...formulaJson,
            'items': [formulaItemJson],
          }),
        );

        final result = await repository.getById('frm-001');

        expect(result, isA<FormulaDetailResponse>());
        expect(result.items, hasLength(1));
        expect(result.items.first.inventoryId, 'inv-001');
      });
    });

    group('update', () {
      test('sends PATCH and returns updated formula', () async {
        const request = UpdateFormulaRequest(name: 'Updated Formula');

        dioAdapter.onPatch(
          ApiEndpoints.formula('frm-001'),
          (server) =>
              server.reply(200, {...formulaJson, 'name': 'Updated Formula'}),
          data: request.toJson(),
        );

        final result = await repository.update('frm-001', request);

        expect(result.name, 'Updated Formula');
      });
    });

    group('delete', () {
      test('sends DELETE and completes', () async {
        dioAdapter.onDelete(
          ApiEndpoints.formula('frm-001'),
          (server) => server.reply(204, null),
        );

        await expectLater(repository.delete('frm-001'), completes);
      });
    });

    group('addItems', () {
      test('sends POST and returns list of items', () async {
        const request = AddFormulaItemsRequest(
          items: [AddFormulaItemEntry(inventoryId: 'inv-001', quantity: 5)],
        );

        dioAdapter.onPost(
          ApiEndpoints.formulaItems('frm-001'),
          (server) => server.reply(201, [formulaItemJson]),
          data: request.toJson(),
        );

        final result = await repository.addItems('frm-001', request);

        expect(result, hasLength(1));
        expect(result.first.inventoryId, 'inv-001');
      });
    });

    group('removeItem', () {
      test('sends DELETE and completes', () async {
        dioAdapter.onDelete(
          ApiEndpoints.formulaItem('frm-001', 'item-001'),
          (server) => server.reply(204, null),
        );

        await expectLater(
          repository.removeItem('frm-001', 'item-001'),
          completes,
        );
      });
    });

    group('updateItemQuantity', () {
      test('sends PATCH and returns updated item', () async {
        const request = UpdateFormulaItemQuantityRequest(quantity: 20);

        dioAdapter.onPatch(
          ApiEndpoints.formulaItem('frm-001', 'item-001'),
          (server) => server.reply(200, {...formulaItemJson, 'quantity': 20}),
          data: request.toJson(),
        );

        final result = await repository.updateItemQuantity(
          'frm-001',
          'item-001',
          request,
        );

        expect(result.quantity, 20);
      });
    });

    group('reorderItems', () {
      test('sends PUT and completes', () async {
        const request = ReorderFormulaItemsRequest(
          items: [ReorderEntry(itemId: 'item-001', sortOrder: 2)],
        );

        dioAdapter.onPut(
          ApiEndpoints.formulaItemsReorder('frm-001'),
          (server) => server.reply(204, null),
          data: request.toJson(),
        );

        await expectLater(
          repository.reorderItems('frm-001', request),
          completes,
        );
      });
    });

    group('listLabels', () {
      test('sends GET and returns label list', () async {
        dioAdapter.onGet(
          ApiEndpoints.formulaLabels,
          (server) => server.reply(200, ['jazz', 'rock', 'classical']),
        );

        final result = await repository.listLabels();

        expect(result, ['jazz', 'rock', 'classical']);
      });

      test('returns empty list when no labels exist', () async {
        dioAdapter.onGet(
          ApiEndpoints.formulaLabels,
          (server) => server.reply(200, <String>[]),
        );

        final result = await repository.listLabels();

        expect(result, isEmpty);
      });
    });
  });
}
