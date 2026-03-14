// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/auth/models/login_response.dart';

void main() {
  group('LoginResponse', () {
    test('can be created with required fields', () {
      final result = const LoginResponse(
        accessToken: 'access-token-123',
        refreshToken: 'refresh-token-456',
        sessionId: 'session-789',
        accountId: 'account-abc',
        expiresAt: '2026-01-01T01:00:00Z',
      );
      expect(result.accessToken, 'access-token-123');
      expect(result.refreshToken, 'refresh-token-456');
      expect(result.sessionId, 'session-789');
      expect(result.accountId, 'account-abc');
      expect(result.expiresAt, '2026-01-01T01:00:00Z');
    });

    test('serializes to JSON correctly', () {
      final result = const LoginResponse(
        accessToken: 'access-token-123',
        refreshToken: 'refresh-token-456',
        sessionId: 'session-789',
        accountId: 'account-abc',
        expiresAt: '2026-01-01T01:00:00Z',
      );
      final json = result.toJson();
      expect(json['accessToken'], 'access-token-123');
      expect(json['refreshToken'], 'refresh-token-456');
      expect(json['sessionId'], 'session-789');
      expect(json['accountId'], 'account-abc');
      expect(json['expiresAt'], '2026-01-01T01:00:00Z');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'accessToken': 'access-token-123',
        'refreshToken': 'refresh-token-456',
        'sessionId': 'session-789',
        'accountId': 'account-abc',
        'expiresAt': '2026-01-01T01:00:00Z',
      };
      final result = LoginResponse.fromJson(json);
      expect(result.accessToken, 'access-token-123');
      expect(result.refreshToken, 'refresh-token-456');
      expect(result.sessionId, 'session-789');
      expect(result.accountId, 'account-abc');
      expect(result.expiresAt, '2026-01-01T01:00:00Z');
    });

    test('equality works correctly', () {
      final a = const LoginResponse(
        accessToken: 'access-token-123',
        refreshToken: 'refresh-token-456',
        sessionId: 'session-789',
        accountId: 'account-abc',
        expiresAt: '2026-01-01T01:00:00Z',
      );
      final b = const LoginResponse(
        accessToken: 'access-token-123',
        refreshToken: 'refresh-token-456',
        sessionId: 'session-789',
        accountId: 'account-abc',
        expiresAt: '2026-01-01T01:00:00Z',
      );
      final c = const LoginResponse(
        accessToken: 'different',
        refreshToken: 'refresh-token-456',
        sessionId: 'session-789',
        accountId: 'account-abc',
        expiresAt: '2026-01-01T01:00:00Z',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const LoginResponse(
        accessToken: 'access-token-123',
        refreshToken: 'refresh-token-456',
        sessionId: 'session-789',
        accountId: 'account-abc',
        expiresAt: '2026-01-01T01:00:00Z',
      );
      final roundTripped = LoginResponse.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
