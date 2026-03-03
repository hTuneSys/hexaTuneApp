// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/task/models/task_summary_dto.dart';
import 'package:hexatuneapp/src/core/task/models/task_status_response.dart';
import 'package:hexatuneapp/src/core/task/models/create_task_request.dart';
import 'package:hexatuneapp/src/core/task/models/create_task_response.dart';
import 'package:hexatuneapp/src/core/task/models/cancel_task_request.dart';
import 'package:hexatuneapp/src/core/task/models/cancel_task_response.dart';

void main() {
  group('TaskSummaryDto', () {
    test('fromJson with all fields', () {
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
      expect(dto.scheduledAt, '2025-01-01T00:00:00Z');
      expect(dto.retryCount, 0);
      expect(dto.maxRetries, 3);
      expect(dto.createdAt, '2025-01-01T00:00:00Z');
      expect(dto.updatedAt, '2025-01-01T00:00:00Z');
      expect(dto.cronExpression, '0 0 * * *');
      expect(dto.executeAfter, '2025-01-02T00:00:00Z');
    });

    test('fromJson without optional fields', () {
      final json = {
        'taskId': 'task-002',
        'taskType': 'import',
        'status': 'running',
        'scheduledAt': '2025-01-01T00:00:00Z',
        'retryCount': 1,
        'maxRetries': 5,
        'createdAt': '2025-01-01T00:00:00Z',
        'updatedAt': '2025-01-01T00:00:00Z',
      };
      final dto = TaskSummaryDto.fromJson(json);
      expect(dto.cronExpression, isNull);
      expect(dto.executeAfter, isNull);
    });

    test('toJson produces correct keys', () {
      const dto = TaskSummaryDto(
        taskId: 'task-001',
        taskType: 'export',
        status: 'pending',
        scheduledAt: '2025-01-01T00:00:00Z',
        retryCount: 0,
        maxRetries: 3,
        createdAt: '2025-01-01T00:00:00Z',
        updatedAt: '2025-01-01T00:00:00Z',
      );
      final json = dto.toJson();
      expect(json['taskId'], 'task-001');
      expect(json['taskType'], 'export');
      expect(json['retryCount'], 0);
      expect(json['maxRetries'], 3);
    });

    test('round-trip preserves values', () {
      const original = TaskSummaryDto(
        taskId: 't',
        taskType: 'ty',
        status: 's',
        scheduledAt: 'sa',
        retryCount: 0,
        maxRetries: 1,
        createdAt: 'c',
        updatedAt: 'u',
        cronExpression: 'cron',
      );
      final restored = TaskSummaryDto.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('TaskStatusResponse', () {
    test('fromJson with all fields', () {
      final json = {
        'taskId': 'task-001',
        'taskType': 'export',
        'status': 'completed',
        'payload': {'key': 'value'},
        'scheduledAt': '2025-01-01T00:00:00Z',
        'retryCount': 2,
        'maxRetries': 3,
        'createdAt': '2025-01-01T00:00:00Z',
        'updatedAt': '2025-01-02T00:00:00Z',
        'cronExpression': '0 0 * * *',
        'executeAfter': '2025-01-01T12:00:00Z',
        'startedAt': '2025-01-01T00:01:00Z',
        'completedAt': '2025-01-01T00:05:00Z',
        'failedAt': null,
        'cancelledAt': null,
        'errorMessage': null,
        'result': {'output': 'done'},
        'progressPercentage': 100,
        'progressStatus': 'finished',
      };
      final response = TaskStatusResponse.fromJson(json);
      expect(response.taskId, 'task-001');
      expect(response.taskType, 'export');
      expect(response.status, 'completed');
      expect(response.payload, {'key': 'value'});
      expect(response.retryCount, 2);
      expect(response.maxRetries, 3);
      expect(response.cronExpression, '0 0 * * *');
      expect(response.startedAt, '2025-01-01T00:01:00Z');
      expect(response.completedAt, '2025-01-01T00:05:00Z');
      expect(response.failedAt, isNull);
      expect(response.result, {'output': 'done'});
      expect(response.progressPercentage, 100);
      expect(response.progressStatus, 'finished');
    });

    test('fromJson with only required fields', () {
      final json = {
        'taskId': 'task-002',
        'taskType': 'import',
        'status': 'pending',
        'payload': <String, dynamic>{},
        'scheduledAt': '2025-01-01T00:00:00Z',
        'retryCount': 0,
        'maxRetries': 3,
        'createdAt': '2025-01-01T00:00:00Z',
        'updatedAt': '2025-01-01T00:00:00Z',
      };
      final response = TaskStatusResponse.fromJson(json);
      expect(response.taskId, 'task-002');
      expect(response.cronExpression, isNull);
      expect(response.executeAfter, isNull);
      expect(response.startedAt, isNull);
      expect(response.completedAt, isNull);
      expect(response.failedAt, isNull);
      expect(response.cancelledAt, isNull);
      expect(response.errorMessage, isNull);
      expect(response.result, isNull);
      expect(response.progressPercentage, isNull);
      expect(response.progressStatus, isNull);
    });

    test('toJson produces correct keys', () {
      const response = TaskStatusResponse(
        taskId: 'task-001',
        taskType: 'export',
        status: 'running',
        payload: {'a': 1},
        scheduledAt: '2025-01-01T00:00:00Z',
        retryCount: 0,
        maxRetries: 3,
        createdAt: '2025-01-01T00:00:00Z',
        updatedAt: '2025-01-01T00:00:00Z',
        progressPercentage: 50,
      );
      final json = response.toJson();
      expect(json['taskId'], 'task-001');
      expect(json['payload'], {'a': 1});
      expect(json['progressPercentage'], 50);
    });

    test('round-trip preserves values', () {
      const original = TaskStatusResponse(
        taskId: 't',
        taskType: 'ty',
        status: 's',
        payload: {'k': 'v'},
        scheduledAt: 'sa',
        retryCount: 0,
        maxRetries: 1,
        createdAt: 'c',
        updatedAt: 'u',
      );
      final restored = TaskStatusResponse.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('CreateTaskRequest', () {
    test('fromJson with all fields', () {
      final json = {
        'taskType': 'export',
        'payload': {'format': 'csv'},
        'cronExpression': '0 0 * * *',
        'executeAfter': '2025-02-01T00:00:00Z',
      };
      final request = CreateTaskRequest.fromJson(json);
      expect(request.taskType, 'export');
      expect(request.payload, {'format': 'csv'});
      expect(request.cronExpression, '0 0 * * *');
      expect(request.executeAfter, '2025-02-01T00:00:00Z');
    });

    test('fromJson without optional fields', () {
      final json = {
        'taskType': 'import',
        'payload': {'source': 'file'},
      };
      final request = CreateTaskRequest.fromJson(json);
      expect(request.cronExpression, isNull);
      expect(request.executeAfter, isNull);
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

    test('round-trip preserves values', () {
      const original = CreateTaskRequest(
        taskType: 't',
        payload: {'k': 'v'},
        cronExpression: 'c',
      );
      final restored = CreateTaskRequest.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('CreateTaskResponse', () {
    test('fromJson with all fields', () {
      final json = {
        'taskId': 'task-001',
        'status': 'scheduled',
        'scheduledAt': '2025-01-01T00:00:00Z',
        'executeAfter': '2025-02-01T00:00:00Z',
      };
      final response = CreateTaskResponse.fromJson(json);
      expect(response.taskId, 'task-001');
      expect(response.status, 'scheduled');
      expect(response.scheduledAt, '2025-01-01T00:00:00Z');
      expect(response.executeAfter, '2025-02-01T00:00:00Z');
    });

    test('fromJson without optional executeAfter', () {
      final json = {
        'taskId': 'task-002',
        'status': 'scheduled',
        'scheduledAt': '2025-01-01T00:00:00Z',
      };
      final response = CreateTaskResponse.fromJson(json);
      expect(response.executeAfter, isNull);
    });

    test('toJson produces correct keys', () {
      const response = CreateTaskResponse(
        taskId: 'task-001',
        status: 'scheduled',
        scheduledAt: '2025-01-01T00:00:00Z',
      );
      final json = response.toJson();
      expect(json['taskId'], 'task-001');
      expect(json['status'], 'scheduled');
      expect(json['scheduledAt'], '2025-01-01T00:00:00Z');
    });

    test('round-trip preserves values', () {
      const original = CreateTaskResponse(
        taskId: 't',
        status: 's',
        scheduledAt: 'sa',
      );
      final restored = CreateTaskResponse.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('CancelTaskRequest', () {
    test('fromJson with reason', () {
      final json = {'reason': 'No longer needed'};
      final request = CancelTaskRequest.fromJson(json);
      expect(request.reason, 'No longer needed');
    });

    test('fromJson without optional reason', () {
      final json = <String, dynamic>{};
      final request = CancelTaskRequest.fromJson(json);
      expect(request.reason, isNull);
    });

    test('toJson produces correct keys', () {
      const request = CancelTaskRequest(reason: 'test');
      final json = request.toJson();
      expect(json['reason'], 'test');
    });

    test('round-trip preserves values', () {
      const original = CancelTaskRequest(reason: 'r');
      final restored = CancelTaskRequest.fromJson(original.toJson());
      expect(restored, original);
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

    test('round-trip preserves values', () {
      const original = CancelTaskResponse(taskId: 't', status: 's');
      final restored = CancelTaskResponse.fromJson(original.toJson());
      expect(restored, original);
    });
  });
}
