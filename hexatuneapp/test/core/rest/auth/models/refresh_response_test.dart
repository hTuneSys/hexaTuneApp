// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/auth/models/refresh_response.dart';

void main() {
  group('RefreshResponse', () {
    test('can be created with required fields', () {
      final result = const RefreshResponse(
        accessToken: 'new-access-token',
        refreshToken: 'new-refresh-token',
        sessionId: 'session-new',
        expiresAt: '2026-01-01T02:00:00Z',
      );
      expect(result.accessToken, 'new-access-token');
      expect(result.refreshToken, 'new-refresh-token');
      expect(result.sessionId, 'session-new');
      expect(result.expiresAt, '2026-01-01T02:00:00Z');
    });

    test('serializes to JSON correctly', () {
      final result = const RefreshResponse(
        accessToken: 'new-access-token',
        refreshToken: 'new-refresh-token',
        sessionId: 'session-new',
        expiresAt: '2026-01-01T02:00:00Z',
      );
      final json = result.toJson();
      expect(json['accessToken'], 'new-access-token');
      expect(json['refreshToken'], 'new-refresh-token');
      expect(json['sessionId'], 'session-new');
      expect(json['expiresAt'], '2026-01-01T02:00:00Z');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'accessToken': 'new-access-token',
        'refreshToken': 'new-refresh-token',
        'sessionId': 'session-new',
        'expiresAt': '2026-01-01T02:00:00Z',
      };
      final result = RefreshResponse.fromJson(json);
      expect(result.accessToken, 'new-access-token');
      expect(result.refreshToken, 'new-refresh-token');
      expect(result.sessionId, 'session-new');
      expect(result.expiresAt, '2026-01-01T02:00:00Z');
    });

    test('equality works correctly', () {
      final a = const RefreshResponse(
        accessToken: 'new-access-token',
        refreshToken: 'new-refresh-token',
        sessionId: 'session-new',
        expiresAt: '2026-01-01T02:00:00Z',
      );
      final b = const RefreshResponse(
        accessToken: 'new-access-token',
        refreshToken: 'new-refresh-token',
        sessionId: 'session-new',
        expiresAt: '2026-01-01T02:00:00Z',
      );
      final c = const RefreshResponse(
        accessToken: 'different',
        refreshToken: 'new-refresh-token',
        sessionId: 'session-new',
        expiresAt: '2026-01-01T02:00:00Z',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const RefreshResponse(
        accessToken: 'new-access-token',
        refreshToken: 'new-refresh-token',
        sessionId: 'session-new',
        expiresAt: '2026-01-01T02:00:00Z',
      );
      final roundTripped = RefreshResponse.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
