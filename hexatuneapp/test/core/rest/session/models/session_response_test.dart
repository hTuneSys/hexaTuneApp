// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/session/models/session_response.dart';

void main() {
  group('SessionResponse', () {
    test('can be created with required fields', () {
      final result = const SessionResponse(
        id: 'session-001',
        accountId: 'acc-001',
        deviceId: 'device-001',
        createdAt: '2026-01-01T00:00:00Z',
        expiresAt: '2026-01-02T00:00:00Z',
      );
      expect(result.id, 'session-001');
      expect(result.accountId, 'acc-001');
      expect(result.deviceId, 'device-001');
      expect(result.createdAt, '2026-01-01T00:00:00Z');
      expect(result.expiresAt, '2026-01-02T00:00:00Z');
    });

    test('serializes to JSON correctly', () {
      final result = const SessionResponse(
        id: 'session-001',
        accountId: 'acc-001',
        deviceId: 'device-001',
        createdAt: '2026-01-01T00:00:00Z',
        expiresAt: '2026-01-02T00:00:00Z',
      );
      final json = result.toJson();
      expect(json['id'], 'session-001');
      expect(json['accountId'], 'acc-001');
      expect(json['deviceId'], 'device-001');
      expect(json['createdAt'], '2026-01-01T00:00:00Z');
      expect(json['expiresAt'], '2026-01-02T00:00:00Z');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'id': 'session-001',
        'accountId': 'acc-001',
        'deviceId': 'device-001',
        'createdAt': '2026-01-01T00:00:00Z',
        'expiresAt': '2026-01-02T00:00:00Z',
      };
      final result = SessionResponse.fromJson(json);
      expect(result.id, 'session-001');
      expect(result.accountId, 'acc-001');
      expect(result.deviceId, 'device-001');
      expect(result.createdAt, '2026-01-01T00:00:00Z');
      expect(result.expiresAt, '2026-01-02T00:00:00Z');
    });

    test('equality works correctly', () {
      final a = const SessionResponse(
        id: 'session-001',
        accountId: 'acc-001',
        deviceId: 'device-001',
        createdAt: '2026-01-01T00:00:00Z',
        expiresAt: '2026-01-02T00:00:00Z',
      );
      final b = const SessionResponse(
        id: 'session-001',
        accountId: 'acc-001',
        deviceId: 'device-001',
        createdAt: '2026-01-01T00:00:00Z',
        expiresAt: '2026-01-02T00:00:00Z',
      );
      final c = const SessionResponse(
        id: 'different',
        accountId: 'acc-001',
        deviceId: 'device-001',
        createdAt: '2026-01-01T00:00:00Z',
        expiresAt: '2026-01-02T00:00:00Z',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const SessionResponse(
        id: 'session-001',
        accountId: 'acc-001',
        deviceId: 'device-001',
        createdAt: '2026-01-01T00:00:00Z',
        expiresAt: '2026-01-02T00:00:00Z',
      );
      final roundTripped = SessionResponse.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
