// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/harmonics/models/generate_harmonics_response.dart';
import 'package:hexatuneapp/src/core/rest/harmonics/models/harmonic_assignment_dto.dart';

void main() {
  group('GenerateHarmonicsResponse', () {
    test('can be created with required fields', () {
      final response = GenerateHarmonicsResponse(
        requestId: 'req-001',
        assignments: [
          HarmonicAssignmentDto(
            inventoryId: 'inv-1',
            harmonicNumber: 1,
            assignedAt: '2026-03-08T03:00:00Z',
          ),
        ],
        totalAssigned: 1,
      );
      expect(response.requestId, 'req-001');
      expect(response.assignments, hasLength(1));
      expect(response.totalAssigned, 1);
    });

    test('serializes to JSON correctly', () {
      final response = GenerateHarmonicsResponse(
        requestId: 'req-abc',
        assignments: [
          HarmonicAssignmentDto(
            inventoryId: 'inv-a',
            harmonicNumber: 10,
            assignedAt: '2026-01-01T00:00:00Z',
          ),
          HarmonicAssignmentDto(
            inventoryId: 'inv-b',
            harmonicNumber: 20,
            assignedAt: '2026-01-01T00:00:01Z',
          ),
        ],
        totalAssigned: 2,
      );
      final json = response.toJson();
      expect(json['requestId'], 'req-abc');
      expect(json['totalAssigned'], 2);
      expect(json['assignments'], hasLength(2));
      // Nested freezed objects may not be raw maps — access via model
      final firstAssignment = response.assignments.first;
      expect(firstAssignment.harmonicNumber, 10);
    });

    test('deserializes from JSON correctly', () {
      final json = {
        'requestId': 'req-xyz',
        'totalAssigned': 1,
        'assignments': [
          {
            'inventoryId': 'inv-x',
            'harmonicNumber': 99,
            'assignedAt': '2026-12-31T23:59:59Z',
          },
        ],
      };
      final response = GenerateHarmonicsResponse.fromJson(json);
      expect(response.requestId, 'req-xyz');
      expect(response.totalAssigned, 1);
      expect(response.assignments.first.harmonicNumber, 99);
    });

    test('handles empty assignments list', () {
      final response = GenerateHarmonicsResponse(
        requestId: 'req-empty',
        assignments: [],
        totalAssigned: 0,
      );
      expect(response.assignments, isEmpty);
      expect(response.totalAssigned, 0);
    });

    test('equality works correctly', () {
      final assignment = HarmonicAssignmentDto(
        inventoryId: 'inv-1',
        harmonicNumber: 1,
        assignedAt: '2026-01-01T00:00:00Z',
      );
      final a = GenerateHarmonicsResponse(
        requestId: 'req-1',
        assignments: [assignment],
        totalAssigned: 1,
      );
      final b = GenerateHarmonicsResponse(
        requestId: 'req-1',
        assignments: [assignment],
        totalAssigned: 1,
      );
      expect(a, equals(b));
    });

    test('round-trip serialization preserves nested data', () {
      final original = GenerateHarmonicsResponse(
        requestId: 'round-trip',
        assignments: [
          HarmonicAssignmentDto(
            inventoryId: 'inv-rt',
            harmonicNumber: 50,
            assignedAt: '2026-06-15T12:30:00Z',
          ),
        ],
        totalAssigned: 1,
      );
      // Serialize nested assignments manually for round-trip
      final json = original.toJson();
      json['assignments'] = (json['assignments'] as List)
          .map((a) => (a as HarmonicAssignmentDto).toJson())
          .toList();
      final roundTripped = GenerateHarmonicsResponse.fromJson(json);
      expect(roundTripped, equals(original));
    });
  });
}
