// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/task/models/cancel_task_response.dart';

void main() {
  group('CancelTaskResponse', () {
    test('can be created with required fields', () {
      final result = const CancelTaskResponse(
        taskId: 'task-001',
        status: 'cancelled',
      );
      expect(result.taskId, 'task-001');
      expect(result.status, 'cancelled');
    });

    test('serializes to JSON correctly', () {
      final result = const CancelTaskResponse(
        taskId: 'task-001',
        status: 'cancelled',
      );
      final json = result.toJson();
      expect(json['taskId'], 'task-001');
      expect(json['status'], 'cancelled');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'taskId': 'task-001',
        'status': 'cancelled',
      };
      final result = CancelTaskResponse.fromJson(json);
      expect(result.taskId, 'task-001');
      expect(result.status, 'cancelled');
    });

    test('equality works correctly', () {
      final a = const CancelTaskResponse(
        taskId: 'task-001',
        status: 'cancelled',
      );
      final b = const CancelTaskResponse(
        taskId: 'task-001',
        status: 'cancelled',
      );
      final c = const CancelTaskResponse(
        taskId: 'different',
        status: 'cancelled',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const CancelTaskResponse(
        taskId: 'task-001',
        status: 'cancelled',
      );
      final roundTripped = CancelTaskResponse.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
