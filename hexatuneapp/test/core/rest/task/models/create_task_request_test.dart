// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/task/models/create_task_request.dart';

void main() {
  group('CreateTaskRequest', () {
    test('can be created with required fields', () {
      final result = CreateTaskRequest(
        taskType: 'export',
        payload: {'format': 'csv'},
      );
      expect(result.taskType, 'export');
      expect(result.payload, isA<Map<String, dynamic>>());
    });

    test('serializes to JSON correctly', () {
      final result = CreateTaskRequest(
        taskType: 'export',
        payload: {'format': 'csv'},
      );
      final json = result.toJson();
      expect(json['taskType'], 'export');
      expect(json['payload'], isA<Map<String, dynamic>>());
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'taskType': 'export',
        'payload': {'format': 'csv'},
      };
      final result = CreateTaskRequest.fromJson(json);
      expect(result.taskType, 'export');
      expect(result.payload, isA<Map<String, dynamic>>());
    });

    test('equality works correctly', () {
      final a = CreateTaskRequest(
        taskType: 'export',
        payload: {'format': 'csv'},
      );
      final b = CreateTaskRequest(
        taskType: 'export',
        payload: {'format': 'csv'},
      );
      final c = CreateTaskRequest(
        taskType: 'different',
        payload: {'format': 'csv'},
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = CreateTaskRequest(
        taskType: 'export',
        payload: {'format': 'csv'},
      );
      final roundTripped = CreateTaskRequest.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
