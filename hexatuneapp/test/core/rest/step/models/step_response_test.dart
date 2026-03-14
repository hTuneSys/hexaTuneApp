// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/step/models/step_response.dart';

void main() {
  group('StepResponse', () {
    test('can be created with required fields', () {
      final result = StepResponse(
        id: 'step-001',
        name: 'Deep Breathing',
        description: 'Slow deep breathing exercise',
        labels: ['relaxation'],
        imageUploaded: true,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      expect(result.id, 'step-001');
      expect(result.name, 'Deep Breathing');
      expect(result.description, 'Slow deep breathing exercise');
      expect(result.labels, ['relaxation']);
      expect(result.imageUploaded, true);
      expect(result.createdAt, '2026-01-01T00:00:00Z');
      expect(result.updatedAt, '2026-01-01T00:00:00Z');
    });

    test('serializes to JSON correctly', () {
      final result = StepResponse(
        id: 'step-001',
        name: 'Deep Breathing',
        description: 'Slow deep breathing exercise',
        labels: ['relaxation'],
        imageUploaded: true,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final json = result.toJson();
      expect(json['id'], 'step-001');
      expect(json['name'], 'Deep Breathing');
      expect(json['description'], 'Slow deep breathing exercise');
      expect(json['labels'], ['relaxation']);
      expect(json['imageUploaded'], true);
      expect(json['createdAt'], '2026-01-01T00:00:00Z');
      expect(json['updatedAt'], '2026-01-01T00:00:00Z');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'id': 'step-001',
        'name': 'Deep Breathing',
        'description': 'Slow deep breathing exercise',
        'labels': ['relaxation'],
        'imageUploaded': true,
        'createdAt': '2026-01-01T00:00:00Z',
        'updatedAt': '2026-01-01T00:00:00Z',
      };
      final result = StepResponse.fromJson(json);
      expect(result.id, 'step-001');
      expect(result.name, 'Deep Breathing');
      expect(result.description, 'Slow deep breathing exercise');
      expect(result.labels, ['relaxation']);
      expect(result.imageUploaded, true);
      expect(result.createdAt, '2026-01-01T00:00:00Z');
      expect(result.updatedAt, '2026-01-01T00:00:00Z');
    });

    test('equality works correctly', () {
      final a = StepResponse(
        id: 'step-001',
        name: 'Deep Breathing',
        description: 'Slow deep breathing exercise',
        labels: ['relaxation'],
        imageUploaded: true,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final b = StepResponse(
        id: 'step-001',
        name: 'Deep Breathing',
        description: 'Slow deep breathing exercise',
        labels: ['relaxation'],
        imageUploaded: true,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final c = StepResponse(
        id: 'different',
        name: 'Deep Breathing',
        description: 'Slow deep breathing exercise',
        labels: ['relaxation'],
        imageUploaded: true,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = StepResponse(
        id: 'step-001',
        name: 'Deep Breathing',
        description: 'Slow deep breathing exercise',
        labels: ['relaxation'],
        imageUploaded: true,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-01T00:00:00Z',
      );
      final roundTripped = StepResponse.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
