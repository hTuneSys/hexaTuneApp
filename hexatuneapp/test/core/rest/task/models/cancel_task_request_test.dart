// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/task/models/cancel_task_request.dart';

void main() {
  group('CancelTaskRequest', () {
    test('can be created with optional reason', () {
      const result = CancelTaskRequest(reason: 'No longer needed');
      expect(result.reason, 'No longer needed');
    });

    test('can be created with no fields', () {
      const result = CancelTaskRequest();
      expect(result.reason, isNull);
    });

    test('serializes to JSON correctly', () {
      const result = CancelTaskRequest(reason: 'Test');
      final json = result.toJson();
      expect(json['reason'], 'Test');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{'reason': 'From JSON'};
      final result = CancelTaskRequest.fromJson(json);
      expect(result.reason, 'From JSON');
    });

    test('equality works correctly', () {
      const a = CancelTaskRequest(reason: 'Same');
      const b = CancelTaskRequest(reason: 'Same');
      const c = CancelTaskRequest(reason: 'Different');
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      const original = CancelTaskRequest(reason: 'Round Trip');
      final roundTripped = CancelTaskRequest.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
