// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/flow/models/flow_detail_response.dart';
import 'package:hexatuneapp/src/core/rest/flow/models/flow_step_response.dart';

void main() {
  group('FlowDetailResponse', () {
    test('can be created with required fields', () {
      final result = FlowDetailResponse(
        id: 'flow-001',
        name: 'Morning Routine',
        description: 'A calming morning flow',
        labels: ['morning'],
        imageUploaded: true,
        steps: const [
          FlowStepResponse(
            id: 'fs-001',
            stepId: 'step-001',
            sortOrder: 1,
            quantity: 3,
            timeMs: 60000,
          ),
        ],
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      expect(result.id, 'flow-001');
      expect(result.name, 'Morning Routine');
      expect(result.steps, hasLength(1));
      expect(result.steps.first.stepId, 'step-001');
    });

    test('serializes to JSON correctly', () {
      final result = FlowDetailResponse(
        id: 'flow-001',
        name: 'Morning Routine',
        description: 'A calming morning flow',
        labels: ['morning'],
        imageUploaded: true,
        steps: const [
          FlowStepResponse(
            id: 'fs-001',
            stepId: 'step-001',
            sortOrder: 1,
            quantity: 3,
            timeMs: 60000,
          ),
        ],
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final json = result.toJson();
      expect(json['id'], 'flow-001');
      expect(json['steps'], isList);
      final step = (json['steps'] as List).first as FlowStepResponse;
      expect(step.stepId, 'step-001');
      expect(step.timeMs, 60000);
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'id': 'flow-001',
        'name': 'Morning Routine',
        'description': 'A calming morning flow',
        'labels': ['morning'],
        'imageUploaded': true,
        'steps': [
          {
            'id': 'fs-001',
            'stepId': 'step-001',
            'sortOrder': 1,
            'quantity': 3,
            'timeMs': 60000,
          },
        ],
        'createdAt': '2026-01-01T00:00:00Z',
        'updatedAt': '2026-01-01T00:00:00Z',
      };
      final result = FlowDetailResponse.fromJson(json);
      expect(result.id, 'flow-001');
      expect(result.steps, hasLength(1));
      expect(result.steps.first.stepId, 'step-001');
      expect(result.steps.first.quantity, 3);
      expect(result.steps.first.timeMs, 60000);
    });

    test('equality works correctly', () {
      final a = FlowDetailResponse(
        id: 'flow-001',
        name: 'Morning Routine',
        description: 'A calming morning flow',
        labels: ['morning'],
        imageUploaded: true,
        steps: const [
          FlowStepResponse(
            id: 'fs-001',
            stepId: 'step-001',
            sortOrder: 1,
            quantity: 3,
            timeMs: 60000,
          ),
        ],
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final b = FlowDetailResponse(
        id: 'flow-001',
        name: 'Morning Routine',
        description: 'A calming morning flow',
        labels: ['morning'],
        imageUploaded: true,
        steps: const [
          FlowStepResponse(
            id: 'fs-001',
            stepId: 'step-001',
            sortOrder: 1,
            quantity: 3,
            timeMs: 60000,
          ),
        ],
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final c = FlowDetailResponse(
        id: 'different',
        name: 'Morning Routine',
        description: 'A calming morning flow',
        labels: ['morning'],
        imageUploaded: true,
        steps: const [],
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final json = <String, dynamic>{
        'id': 'flow-001',
        'name': 'Morning Routine',
        'description': 'A calming morning flow',
        'labels': ['morning'],
        'imageUploaded': true,
        'steps': [
          {
            'id': 'fs-001',
            'stepId': 'step-001',
            'sortOrder': 1,
            'quantity': 3,
            'timeMs': 60000,
          },
        ],
        'createdAt': '2026-01-01T00:00:00Z',
        'updatedAt': '2026-01-01T00:00:00Z',
      };
      final parsed = FlowDetailResponse.fromJson(json);
      expect(parsed.id, 'flow-001');
      expect(parsed.steps.first.stepId, 'step-001');
      expect(parsed.steps.first.timeMs, 60000);
    });
  });
}
