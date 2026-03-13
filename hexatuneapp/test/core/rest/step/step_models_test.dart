// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/step/models/step_response.dart';

void main() {
  group('StepResponse', () {
    test('fromJson creates instance with all fields', () {
      final json = {
        'id': 'step-001',
        'name': 'Deep Breathing',
        'description': 'Slow deep breathing exercise',
        'labels': ['relaxation', 'focus'],
        'imageUploaded': true,
        'createdAt': '2026-01-01T00:00:00Z',
        'updatedAt': '2026-01-02T00:00:00Z',
      };
      final response = StepResponse.fromJson(json);
      expect(response.id, 'step-001');
      expect(response.name, 'Deep Breathing');
      expect(response.description, 'Slow deep breathing exercise');
      expect(response.labels, ['relaxation', 'focus']);
      expect(response.imageUploaded, true);
    });

    test('toJson produces correct keys', () {
      const response = StepResponse(
        id: 'step-001',
        name: 'Deep Breathing',
        description: 'Slow deep breathing exercise',
        labels: ['relaxation'],
        imageUploaded: false,
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-02T00:00:00Z',
      );
      final json = response.toJson();
      expect(json['id'], 'step-001');
      expect(json['name'], 'Deep Breathing');
      expect(json['imageUploaded'], false);
    });
  });
}
