// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/flow/models/flow_response.dart';

void main() {
  group('FlowResponse', () {
    test('can be created with required fields', () {
      final result = FlowResponse(
        id: 'flow-001',
        name: 'Morning Routine',
        description: 'A calming morning flow',
        labels: ['morning'],
        imageUploaded: true,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      expect(result.id, 'flow-001');
      expect(result.name, 'Morning Routine');
      expect(result.description, 'A calming morning flow');
      expect(result.labels, ['morning']);
      expect(result.imageUploaded, true);
      expect(result.createdAt, '2026-01-01T00:00:00Z');
      expect(result.updatedAt, '2026-01-01T00:00:00Z');
    });

    test('serializes to JSON correctly', () {
      final result = FlowResponse(
        id: 'flow-001',
        name: 'Morning Routine',
        description: 'A calming morning flow',
        labels: ['morning'],
        imageUploaded: true,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final json = result.toJson();
      expect(json['id'], 'flow-001');
      expect(json['name'], 'Morning Routine');
      expect(json['description'], 'A calming morning flow');
      expect(json['labels'], ['morning']);
      expect(json['imageUploaded'], true);
      expect(json['createdAt'], '2026-01-01T00:00:00Z');
      expect(json['updatedAt'], '2026-01-01T00:00:00Z');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'id': 'flow-001',
        'name': 'Morning Routine',
        'description': 'A calming morning flow',
        'labels': ['morning'],
        'imageUploaded': true,
        'createdAt': '2026-01-01T00:00:00Z',
        'updatedAt': '2026-01-01T00:00:00Z',
      };
      final result = FlowResponse.fromJson(json);
      expect(result.id, 'flow-001');
      expect(result.name, 'Morning Routine');
      expect(result.description, 'A calming morning flow');
      expect(result.labels, ['morning']);
      expect(result.imageUploaded, true);
      expect(result.createdAt, '2026-01-01T00:00:00Z');
      expect(result.updatedAt, '2026-01-01T00:00:00Z');
    });

    test('equality works correctly', () {
      final a = FlowResponse(
        id: 'flow-001',
        name: 'Morning Routine',
        description: 'A calming morning flow',
        labels: ['morning'],
        imageUploaded: true,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final b = FlowResponse(
        id: 'flow-001',
        name: 'Morning Routine',
        description: 'A calming morning flow',
        labels: ['morning'],
        imageUploaded: true,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final c = FlowResponse(
        id: 'different',
        name: 'Morning Routine',
        description: 'A calming morning flow',
        labels: ['morning'],
        imageUploaded: true,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = FlowResponse(
        id: 'flow-001',
        name: 'Morning Routine',
        description: 'A calming morning flow',
        labels: ['morning'],
        imageUploaded: true,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final roundTripped = FlowResponse.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
