// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/flow/models/flow_step_response.dart';

void main() {
  group('FlowStepResponse', () {
    test('can be created with required fields', () {
      final result = FlowStepResponse(
        id: 'fs-001',
        stepId: 'step-001',
        sortOrder: 1,
        quantity: 3,
        timeMs: 60000,
      );
      expect(result.id, 'fs-001');
      expect(result.stepId, 'step-001');
      expect(result.sortOrder, 1);
      expect(result.quantity, 3);
      expect(result.timeMs, 60000);
    });

    test('serializes to JSON correctly', () {
      final result = FlowStepResponse(
        id: 'fs-001',
        stepId: 'step-001',
        sortOrder: 1,
        quantity: 3,
        timeMs: 60000,
      );
      final json = result.toJson();
      expect(json['id'], 'fs-001');
      expect(json['stepId'], 'step-001');
      expect(json['sortOrder'], 1);
      expect(json['quantity'], 3);
      expect(json['timeMs'], 60000);
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'id': 'fs-001',
        'stepId': 'step-001',
        'sortOrder': 1,
        'quantity': 3,
        'timeMs': 60000,
      };
      final result = FlowStepResponse.fromJson(json);
      expect(result.id, 'fs-001');
      expect(result.stepId, 'step-001');
      expect(result.sortOrder, 1);
      expect(result.quantity, 3);
      expect(result.timeMs, 60000);
    });

    test('equality works correctly', () {
      final a = FlowStepResponse(
        id: 'fs-001',
        stepId: 'step-001',
        sortOrder: 1,
        quantity: 3,
        timeMs: 60000,
      );
      final b = FlowStepResponse(
        id: 'fs-001',
        stepId: 'step-001',
        sortOrder: 1,
        quantity: 3,
        timeMs: 60000,
      );
      final c = FlowStepResponse(
        id: 'different',
        stepId: 'step-001',
        sortOrder: 1,
        quantity: 3,
        timeMs: 60000,
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = FlowStepResponse(
        id: 'fs-001',
        stepId: 'step-001',
        sortOrder: 1,
        quantity: 3,
        timeMs: 60000,
      );
      final roundTripped = FlowStepResponse.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
