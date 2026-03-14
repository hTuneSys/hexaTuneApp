// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/auth/models/oauth_login_response.dart';

void main() {
  group('OAuthLoginResponse', () {
    test('can be created with required fields', () {
      final result = const OAuthLoginResponse(
        accessToken: 'oauth-access-token',
        refreshToken: 'oauth-refresh-token',
        sessionId: 'oauth-session',
        accountId: 'oauth-account',
        expiresAt: '2026-01-01T01:00:00Z',
        isNewAccount: true,
      );
      expect(result.accessToken, 'oauth-access-token');
      expect(result.refreshToken, 'oauth-refresh-token');
      expect(result.sessionId, 'oauth-session');
      expect(result.accountId, 'oauth-account');
      expect(result.expiresAt, '2026-01-01T01:00:00Z');
      expect(result.isNewAccount, true);
    });

    test('serializes to JSON correctly', () {
      final result = const OAuthLoginResponse(
        accessToken: 'oauth-access-token',
        refreshToken: 'oauth-refresh-token',
        sessionId: 'oauth-session',
        accountId: 'oauth-account',
        expiresAt: '2026-01-01T01:00:00Z',
        isNewAccount: true,
      );
      final json = result.toJson();
      expect(json['accessToken'], 'oauth-access-token');
      expect(json['refreshToken'], 'oauth-refresh-token');
      expect(json['sessionId'], 'oauth-session');
      expect(json['accountId'], 'oauth-account');
      expect(json['expiresAt'], '2026-01-01T01:00:00Z');
      expect(json['isNewAccount'], true);
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'accessToken': 'oauth-access-token',
        'refreshToken': 'oauth-refresh-token',
        'sessionId': 'oauth-session',
        'accountId': 'oauth-account',
        'expiresAt': '2026-01-01T01:00:00Z',
        'isNewAccount': true,
      };
      final result = OAuthLoginResponse.fromJson(json);
      expect(result.accessToken, 'oauth-access-token');
      expect(result.refreshToken, 'oauth-refresh-token');
      expect(result.sessionId, 'oauth-session');
      expect(result.accountId, 'oauth-account');
      expect(result.expiresAt, '2026-01-01T01:00:00Z');
      expect(result.isNewAccount, true);
    });

    test('equality works correctly', () {
      final a = const OAuthLoginResponse(
        accessToken: 'oauth-access-token',
        refreshToken: 'oauth-refresh-token',
        sessionId: 'oauth-session',
        accountId: 'oauth-account',
        expiresAt: '2026-01-01T01:00:00Z',
        isNewAccount: true,
      );
      final b = const OAuthLoginResponse(
        accessToken: 'oauth-access-token',
        refreshToken: 'oauth-refresh-token',
        sessionId: 'oauth-session',
        accountId: 'oauth-account',
        expiresAt: '2026-01-01T01:00:00Z',
        isNewAccount: true,
      );
      final c = const OAuthLoginResponse(
        accessToken: 'different',
        refreshToken: 'oauth-refresh-token',
        sessionId: 'oauth-session',
        accountId: 'oauth-account',
        expiresAt: '2026-01-01T01:00:00Z',
        isNewAccount: true,
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const OAuthLoginResponse(
        accessToken: 'oauth-access-token',
        refreshToken: 'oauth-refresh-token',
        sessionId: 'oauth-session',
        accountId: 'oauth-account',
        expiresAt: '2026-01-01T01:00:00Z',
        isNewAccount: true,
      );
      final roundTripped = OAuthLoginResponse.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
