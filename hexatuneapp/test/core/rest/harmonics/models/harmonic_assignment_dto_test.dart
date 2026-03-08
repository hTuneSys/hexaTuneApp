// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/harmonics/models/harmonic_assignment_dto.dart';

void main() {
  group('HarmonicAssignmentDto', () {
    test('can be created with required fields', () {
      final dto = HarmonicAssignmentDto(
        inventoryId: 'inv-123',
        harmonicNumber: 42,
        assignedAt: '2026-03-08T03:00:00Z',
      );
      expect(dto.inventoryId, 'inv-123');
      expect(dto.harmonicNumber, 42);
      expect(dto.assignedAt, '2026-03-08T03:00:00Z');
    });

    test('serializes to JSON correctly', () {
      final dto = HarmonicAssignmentDto(
        inventoryId: 'inv-abc',
        harmonicNumber: 1,
        assignedAt: '2026-01-01T00:00:00Z',
      );
      final json = dto.toJson();
      expect(json['inventoryId'], 'inv-abc');
      expect(json['harmonicNumber'], 1);
      expect(json['assignedAt'], '2026-01-01T00:00:00Z');
    });

    test('deserializes from JSON correctly', () {
      final json = {
        'inventoryId': 'inv-xyz',
        'harmonicNumber': 100,
        'assignedAt': '2026-12-31T23:59:59Z',
      };
      final dto = HarmonicAssignmentDto.fromJson(json);
      expect(dto.inventoryId, 'inv-xyz');
      expect(dto.harmonicNumber, 100);
      expect(dto.assignedAt, '2026-12-31T23:59:59Z');
    });

    test('equality works correctly', () {
      final a = HarmonicAssignmentDto(
        inventoryId: 'id-1',
        harmonicNumber: 5,
        assignedAt: '2026-01-01T00:00:00Z',
      );
      final b = HarmonicAssignmentDto(
        inventoryId: 'id-1',
        harmonicNumber: 5,
        assignedAt: '2026-01-01T00:00:00Z',
      );
      final c = HarmonicAssignmentDto(
        inventoryId: 'id-1',
        harmonicNumber: 6,
        assignedAt: '2026-01-01T00:00:00Z',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = HarmonicAssignmentDto(
        inventoryId: 'round-trip',
        harmonicNumber: 77,
        assignedAt: '2026-06-15T12:30:00Z',
      );
      final roundTripped = HarmonicAssignmentDto.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
