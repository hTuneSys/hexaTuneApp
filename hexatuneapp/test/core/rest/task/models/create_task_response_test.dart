// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/task/models/create_task_response.dart';

void main() {
  group('CreateTaskResponse', () {
    test('can be created with required fields', () {
      final result = const CreateTaskResponse(
        taskId: 'task-001',
        status: 'pending',
        scheduledAt: '2026-01-01T00:00:00Z',
      );
      expect(result.taskId, 'task-001');
      expect(result.status, 'pending');
      expect(result.scheduledAt, '2026-01-01T00:00:00Z');
    });

    test('serializes to JSON correctly', () {
      final result = const CreateTaskResponse(
        taskId: 'task-001',
        status: 'pending',
        scheduledAt: '2026-01-01T00:00:00Z',
      );
      final json = result.toJson();
      expect(json['taskId'], 'task-001');
      expect(json['status'], 'pending');
      expect(json['scheduledAt'], '2026-01-01T00:00:00Z');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'taskId': 'task-001',
        'status': 'pending',
        'scheduledAt': '2026-01-01T00:00:00Z',
      };
      final result = CreateTaskResponse.fromJson(json);
      expect(result.taskId, 'task-001');
      expect(result.status, 'pending');
      expect(result.scheduledAt, '2026-01-01T00:00:00Z');
    });

    test('equality works correctly', () {
      final a = const CreateTaskResponse(
        taskId: 'task-001',
        status: 'pending',
        scheduledAt: '2026-01-01T00:00:00Z',
      );
      final b = const CreateTaskResponse(
        taskId: 'task-001',
        status: 'pending',
        scheduledAt: '2026-01-01T00:00:00Z',
      );
      final c = const CreateTaskResponse(
        taskId: 'different',
        status: 'pending',
        scheduledAt: '2026-01-01T00:00:00Z',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const CreateTaskResponse(
        taskId: 'task-001',
        status: 'pending',
        scheduledAt: '2026-01-01T00:00:00Z',
      );
      final roundTripped = CreateTaskResponse.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
