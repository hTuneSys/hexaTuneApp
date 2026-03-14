// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/task/models/cancel_task_request.dart';
import 'package:hexatuneapp/src/core/rest/task/models/cancel_task_response.dart';
import 'package:hexatuneapp/src/core/rest/task/models/create_task_request.dart';
import 'package:hexatuneapp/src/core/rest/task/models/create_task_response.dart';
import 'package:hexatuneapp/src/core/rest/task/models/task_status_response.dart';
import 'package:hexatuneapp/src/core/rest/task/models/task_summary_dto.dart';

void main() {
  group('TaskSummaryDto', () {
    test('fromJson creates instance with all fields', () {
      final json = {
        'taskId': 'task-001',
        'taskType': 'export',
        'status': 'pending',
        'scheduledAt': '2025-01-01T00:00:00Z',
        'retryCount': 0,
        'maxRetries': 3,
        'createdAt': '2025-01-01T00:00:00Z',
        'updatedAt': '2025-01-01T00:00:00Z',
        'cronExpression': '0 0 * * *',
        'executeAfter': '2025-01-02T00:00:00Z',
      };
      final dto = TaskSummaryDto.fromJson(json);
      expect(dto.taskId, 'task-001');
      expect(dto.taskType, 'export');
      expect(dto.status, 'pending');
      expect(dto.retryCount, 0);
      expect(dto.maxRetries, 3);
      expect(dto.cronExpression, '0 0 * * *');
      expect(dto.executeAfter, '2025-01-02T00:00:00Z');
    });

    test('optional fields default to null', () {
      final json = {
        'taskId': 'task-001',
        'taskType': 'export',
        'status': 'pending',
        'scheduledAt': '2025-01-01T00:00:00Z',
        'retryCount': 0,
        'maxRetries': 3,
        'createdAt': '2025-01-01T00:00:00Z',
        'updatedAt': '2025-01-01T00:00:00Z',
      };
      final dto = TaskSummaryDto.fromJson(json);
      expect(dto.cronExpression, isNull);
      expect(dto.executeAfter, isNull);
    });
  });

  group('CreateTaskRequest', () {
    test('fromJson creates instance', () {
      final json = {
        'taskType': 'export',
        'payload': {'format': 'csv'},
        'cronExpression': '0 0 * * *',
      };
      final request = CreateTaskRequest.fromJson(json);
      expect(request.taskType, 'export');
      expect(request.payload, {'format': 'csv'});
      expect(request.cronExpression, '0 0 * * *');
    });

    test('toJson produces correct keys', () {
      const request = CreateTaskRequest(
        taskType: 'export',
        payload: {'format': 'csv'},
      );
      final json = request.toJson();
      expect(json['taskType'], 'export');
      expect(json['payload'], {'format': 'csv'});
    });

    test('optional fields default to null', () {
      const request = CreateTaskRequest(taskType: 'export', payload: {});
      expect(request.cronExpression, isNull);
      expect(request.executeAfter, isNull);
    });
  });

  group('CreateTaskResponse', () {
    test('fromJson creates instance', () {
      final json = {
        'taskId': 'task-001',
        'status': 'pending',
        'scheduledAt': '2025-01-01T00:00:00Z',
        'executeAfter': '2025-01-02T00:00:00Z',
      };
      final response = CreateTaskResponse.fromJson(json);
      expect(response.taskId, 'task-001');
      expect(response.status, 'pending');
      expect(response.executeAfter, '2025-01-02T00:00:00Z');
    });

    test('executeAfter is optional', () {
      final json = {
        'taskId': 'task-001',
        'status': 'pending',
        'scheduledAt': '2025-01-01T00:00:00Z',
      };
      final response = CreateTaskResponse.fromJson(json);
      expect(response.executeAfter, isNull);
    });
  });

  group('TaskStatusResponse', () {
    test('fromJson creates instance with all fields', () {
      final json = {
        'taskId': 'task-001',
        'taskType': 'export',
        'status': 'completed',
        'payload': {'format': 'csv'},
        'scheduledAt': '2025-01-01T00:00:00Z',
        'retryCount': 1,
        'maxRetries': 3,
        'createdAt': '2025-01-01T00:00:00Z',
        'updatedAt': '2025-01-01T01:00:00Z',
        'startedAt': '2025-01-01T00:30:00Z',
        'completedAt': '2025-01-01T01:00:00Z',
        'result': {'url': 'https://cdn.example.com/export.csv'},
        'progressPercentage': 100,
        'progressStatus': 'done',
      };
      final response = TaskStatusResponse.fromJson(json);
      expect(response.taskId, 'task-001');
      expect(response.status, 'completed');
      expect(response.startedAt, '2025-01-01T00:30:00Z');
      expect(response.completedAt, '2025-01-01T01:00:00Z');
      expect(response.result, isNotNull);
      expect(response.progressPercentage, 100);
    });

    test('optional fields default to null', () {
      final json = {
        'taskId': 'task-001',
        'taskType': 'export',
        'status': 'pending',
        'payload': <String, dynamic>{},
        'scheduledAt': '2025-01-01T00:00:00Z',
        'retryCount': 0,
        'maxRetries': 3,
        'createdAt': '2025-01-01T00:00:00Z',
        'updatedAt': '2025-01-01T00:00:00Z',
      };
      final response = TaskStatusResponse.fromJson(json);
      expect(response.cronExpression, isNull);
      expect(response.startedAt, isNull);
      expect(response.completedAt, isNull);
      expect(response.failedAt, isNull);
      expect(response.cancelledAt, isNull);
      expect(response.errorMessage, isNull);
      expect(response.result, isNull);
      expect(response.progressPercentage, isNull);
      expect(response.progressStatus, isNull);
    });
  });

  group('CancelTaskRequest', () {
    test('fromJson creates instance', () {
      final json = {'reason': 'No longer needed'};
      final request = CancelTaskRequest.fromJson(json);
      expect(request.reason, 'No longer needed');
    });

    test('reason is optional', () {
      const request = CancelTaskRequest();
      expect(request.reason, isNull);
    });
  });

  group('CancelTaskResponse', () {
    test('fromJson creates instance', () {
      final json = {'taskId': 'task-001', 'status': 'cancelled'};
      final response = CancelTaskResponse.fromJson(json);
      expect(response.taskId, 'task-001');
      expect(response.status, 'cancelled');
    });

    test('toJson produces correct keys', () {
      const response = CancelTaskResponse(
        taskId: 'task-001',
        status: 'cancelled',
      );
      final json = response.toJson();
      expect(json['taskId'], 'task-001');
      expect(json['status'], 'cancelled');
    });
  });
}
