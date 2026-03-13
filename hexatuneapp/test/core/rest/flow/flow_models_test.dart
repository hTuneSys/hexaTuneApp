// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/flow/models/flow_detail_response.dart';
import 'package:hexatuneapp/src/core/rest/flow/models/flow_response.dart';
import 'package:hexatuneapp/src/core/rest/flow/models/flow_step_response.dart';

void main() {
  group('FlowResponse', () {
    test('fromJson creates instance with all fields', () {
      final json = {
        'id': 'flow-001',
        'name': 'Morning Routine',
        'description': 'A calming morning flow',
        'labels': ['morning', 'calm'],
        'imageUploaded': true,
        'createdAt': '2026-01-01T00:00:00Z',
        'updatedAt': '2026-01-02T00:00:00Z',
      };
      final response = FlowResponse.fromJson(json);
      expect(response.id, 'flow-001');
      expect(response.name, 'Morning Routine');
      expect(response.description, 'A calming morning flow');
      expect(response.labels, ['morning', 'calm']);
      expect(response.imageUploaded, true);
    });

    test('toJson produces correct keys', () {
      const response = FlowResponse(
        id: 'flow-001',
        name: 'Morning Routine',
        description: 'A calming morning flow',
        labels: ['morning'],
        imageUploaded: false,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-02T00:00:00Z',
      );
      final json = response.toJson();
      expect(json['id'], 'flow-001');
      expect(json['name'], 'Morning Routine');
      expect(json['imageUploaded'], false);
    });
  });

  group('FlowDetailResponse', () {
    test('fromJson creates instance with steps', () {
      final json = {
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
        'updatedAt': '2026-01-02T00:00:00Z',
      };
      final response = FlowDetailResponse.fromJson(json);
      expect(response.id, 'flow-001');
      expect(response.steps, hasLength(1));
      expect(response.steps.first.stepId, 'step-001');
      expect(response.steps.first.quantity, 3);
      expect(response.steps.first.timeMs, 60000);
    });

    test('toJson includes nested steps', () {
      const response = FlowDetailResponse(
        id: 'flow-001',
        name: 'Morning Routine',
        description: 'A calming morning flow',
        labels: ['morning'],
        imageUploaded: true,
        steps: [
          FlowStepResponse(
            id: 'fs-001',
            stepId: 'step-001',
            sortOrder: 1,
            quantity: 3,
            timeMs: 60000,
          ),
        ],
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-02T00:00:00Z',
      );
      final json = response.toJson();
      expect(json['steps'], isList);
      final step = (json['steps'] as List).first as FlowStepResponse;
      expect(step.stepId, 'step-001');
    });

    test('handles empty steps list', () {
      final json = {
        'id': 'flow-002',
        'name': 'Empty Flow',
        'description': 'No steps yet',
        'labels': <String>[],
        'imageUploaded': false,
        'steps': <Map<String, dynamic>>[],
        'createdAt': '2026-01-01T00:00:00Z',
        'updatedAt': '2026-01-01T00:00:00Z',
      };
      final response = FlowDetailResponse.fromJson(json);
      expect(response.steps, isEmpty);
    });
  });

  group('FlowStepResponse', () {
    test('fromJson creates instance', () {
      final json = {
        'id': 'fs-001',
        'stepId': 'step-001',
        'sortOrder': 1,
        'quantity': 3,
        'timeMs': 60000,
      };
      final response = FlowStepResponse.fromJson(json);
      expect(response.id, 'fs-001');
      expect(response.stepId, 'step-001');
      expect(response.sortOrder, 1);
      expect(response.quantity, 3);
      expect(response.timeMs, 60000);
    });

    test('toJson produces correct keys', () {
      const response = FlowStepResponse(
        id: 'fs-001',
        stepId: 'step-001',
        sortOrder: 1,
        quantity: 3,
        timeMs: 60000,
      );
      final json = response.toJson();
      expect(json['id'], 'fs-001');
      expect(json['stepId'], 'step-001');
      expect(json['sortOrder'], 1);
      expect(json['quantity'], 3);
      expect(json['timeMs'], 60000);
    });
  });
}
