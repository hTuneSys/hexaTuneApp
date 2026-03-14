// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/rest/task/task_repository.dart';
import 'package:hexatuneapp/src/core/rest/task/models/cancel_task_request.dart';
import 'package:hexatuneapp/src/core/rest/task/models/cancel_task_response.dart';
import 'package:hexatuneapp/src/core/rest/task/models/create_task_request.dart';
import 'package:hexatuneapp/src/core/rest/task/models/create_task_response.dart';
import 'package:hexatuneapp/src/core/rest/task/models/task_status_response.dart';
import 'package:hexatuneapp/src/core/rest/task/models/task_summary_dto.dart';
import 'package:hexatuneapp/src/core/config/api_endpoints.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_client.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockLogService extends Mock implements LogService {}

void main() {
  group('TaskRepository', () {
    late Dio dio;
    late DioAdapter dioAdapter;
    late MockApiClient mockApiClient;
    late MockLogService mockLogService;
    late TaskRepository repository;

    final taskSummaryJson = {
      'taskId': 'task-001',
      'taskType': 'export',
      'status': 'pending',
      'scheduledAt': '2025-01-01T00:00:00Z',
      'retryCount': 0,
      'maxRetries': 3,
      'createdAt': '2025-01-01T00:00:00Z',
      'updatedAt': '2025-01-01T00:00:00Z',
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

      repository = TaskRepository(mockApiClient, mockLogService);
    });

    group('list', () {
      test('sends GET and returns paginated tasks', () async {
        dioAdapter.onGet(
          ApiEndpoints.tasks,
          (server) => server.reply(200, {
            'data': [taskSummaryJson],
            'pagination': {'has_more': false, 'limit': 20},
          }),
        );

        final result = await repository.list();

        expect(result.data, hasLength(1));
        expect(result.data.first, isA<TaskSummaryDto>());
        expect(result.data.first.taskId, 'task-001');
      });

      test('passes pagination params and filters', () async {
        const params = PaginationParams(limit: 10);
        dioAdapter.onGet(
          ApiEndpoints.tasks,
          (server) => server.reply(200, {
            'data': <Map<String, dynamic>>[],
            'pagination': {'has_more': false, 'limit': 10},
          }),
          queryParameters: {
            ...params.toQueryParameters(),
            'status': 'pending',
            'taskType': 'export',
          },
        );

        final result = await repository.list(
          params: params,
          status: 'pending',
          taskType: 'export',
        );

        expect(result.data, isEmpty);
      });
      test('passes createdAfter and createdBefore filters', () async {
        const params = PaginationParams(limit: 10);
        dioAdapter.onGet(
          ApiEndpoints.tasks,
          (server) => server.reply(200, {
            'data': [taskSummaryJson],
            'pagination': {'has_more': false, 'limit': 10},
          }),
          queryParameters: {
            ...params.toQueryParameters(),
            'status': 'pending',
            'createdAfter': '2025-01-01T00:00:00Z',
            'createdBefore': '2025-06-01T00:00:00Z',
          },
        );

        final result = await repository.list(
          params: params,
          status: 'pending',
          createdAfter: '2025-01-01T00:00:00Z',
          createdBefore: '2025-06-01T00:00:00Z',
        );

        expect(result.data, hasLength(1));
        expect(result.data.first.taskId, 'task-001');
      });
    });

    group('create', () {
      test('sends POST and returns create response', () async {
        const request = CreateTaskRequest(
          taskType: 'export',
          payload: {'format': 'csv'},
        );

        dioAdapter.onPost(
          ApiEndpoints.tasks,
          (server) => server.reply(201, {
            'taskId': 'task-001',
            'status': 'pending',
            'scheduledAt': '2025-01-01T00:00:00Z',
          }),
          data: request.toJson(),
        );

        final result = await repository.create(request);

        expect(result, isA<CreateTaskResponse>());
        expect(result.taskId, 'task-001');
        expect(result.status, 'pending');
      });
    });

    group('getStatus', () {
      test('sends GET and returns task status', () async {
        dioAdapter.onGet(
          ApiEndpoints.task('task-001'),
          (server) => server.reply(200, {
            'taskId': 'task-001',
            'taskType': 'export',
            'status': 'completed',
            'payload': {'format': 'csv'},
            'scheduledAt': '2025-01-01T00:00:00Z',
            'retryCount': 0,
            'maxRetries': 3,
            'createdAt': '2025-01-01T00:00:00Z',
            'updatedAt': '2025-01-01T01:00:00Z',
            'completedAt': '2025-01-01T01:00:00Z',
            'result': {'url': 'https://cdn.example.com/export.csv'},
          }),
        );

        final result = await repository.getStatus('task-001');

        expect(result, isA<TaskStatusResponse>());
        expect(result.status, 'completed');
        expect(result.completedAt, '2025-01-01T01:00:00Z');
        expect(result.result, isNotNull);
      });
    });

    group('cancel', () {
      test('sends POST and returns cancel response', () async {
        const request = CancelTaskRequest(reason: 'No longer needed');

        dioAdapter.onPost(
          ApiEndpoints.taskCancel('task-001'),
          (server) =>
              server.reply(200, {'taskId': 'task-001', 'status': 'cancelled'}),
          data: request.toJson(),
        );

        final result = await repository.cancel('task-001', request);

        expect(result, isA<CancelTaskResponse>());
        expect(result.taskId, 'task-001');
        expect(result.status, 'cancelled');
      });
    });
  });
}
