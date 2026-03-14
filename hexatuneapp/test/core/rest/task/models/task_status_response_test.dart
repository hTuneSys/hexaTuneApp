// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/task/models/task_status_response.dart';

void main() {
  group('TaskStatusResponse', () {
    test('can be created with required fields', () {
      final result = TaskStatusResponse(
        taskId: 'task-001',
        taskType: 'export',
        status: 'running',
        payload: {'format': 'csv'},
        scheduledAt: '2026-01-01T00:00:00Z',
        retryCount: 0,
        maxRetries: 3,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      expect(result.taskId, 'task-001');
      expect(result.taskType, 'export');
      expect(result.status, 'running');
      expect(result.payload, isA<Map<String, dynamic>>());
      expect(result.scheduledAt, '2026-01-01T00:00:00Z');
      expect(result.retryCount, 0);
      expect(result.maxRetries, 3);
      expect(result.createdAt, '2026-01-01T00:00:00Z');
      expect(result.updatedAt, '2026-01-01T00:00:00Z');
    });

    test('serializes to JSON correctly', () {
      final result = TaskStatusResponse(
        taskId: 'task-001',
        taskType: 'export',
        status: 'running',
        payload: {'format': 'csv'},
        scheduledAt: '2026-01-01T00:00:00Z',
        retryCount: 0,
        maxRetries: 3,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final json = result.toJson();
      expect(json['taskId'], 'task-001');
      expect(json['taskType'], 'export');
      expect(json['status'], 'running');
      expect(json['payload'], isA<Map<String, dynamic>>());
      expect(json['scheduledAt'], '2026-01-01T00:00:00Z');
      expect(json['retryCount'], 0);
      expect(json['maxRetries'], 3);
      expect(json['createdAt'], '2026-01-01T00:00:00Z');
      expect(json['updatedAt'], '2026-01-01T00:00:00Z');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'taskId': 'task-001',
        'taskType': 'export',
        'status': 'running',
        'payload': {'format': 'csv'},
        'scheduledAt': '2026-01-01T00:00:00Z',
        'retryCount': 0,
        'maxRetries': 3,
        'createdAt': '2026-01-01T00:00:00Z',
        'updatedAt': '2026-01-01T00:00:00Z',
      };
      final result = TaskStatusResponse.fromJson(json);
      expect(result.taskId, 'task-001');
      expect(result.taskType, 'export');
      expect(result.status, 'running');
      expect(result.payload, isA<Map<String, dynamic>>());
      expect(result.scheduledAt, '2026-01-01T00:00:00Z');
      expect(result.retryCount, 0);
      expect(result.maxRetries, 3);
      expect(result.createdAt, '2026-01-01T00:00:00Z');
      expect(result.updatedAt, '2026-01-01T00:00:00Z');
    });

    test('equality works correctly', () {
      final a = TaskStatusResponse(
        taskId: 'task-001',
        taskType: 'export',
        status: 'running',
        payload: {'format': 'csv'},
        scheduledAt: '2026-01-01T00:00:00Z',
        retryCount: 0,
        maxRetries: 3,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final b = TaskStatusResponse(
        taskId: 'task-001',
        taskType: 'export',
        status: 'running',
        payload: {'format': 'csv'},
        scheduledAt: '2026-01-01T00:00:00Z',
        retryCount: 0,
        maxRetries: 3,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final c = TaskStatusResponse(
        taskId: 'different',
        taskType: 'export',
        status: 'running',
        payload: {'format': 'csv'},
        scheduledAt: '2026-01-01T00:00:00Z',
        retryCount: 0,
        maxRetries: 3,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = TaskStatusResponse(
        taskId: 'task-001',
        taskType: 'export',
        status: 'running',
        payload: {'format': 'csv'},
        scheduledAt: '2026-01-01T00:00:00Z',
        retryCount: 0,
        maxRetries: 3,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final roundTripped = TaskStatusResponse.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
