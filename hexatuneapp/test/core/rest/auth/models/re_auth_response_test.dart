// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/auth/models/re_auth_response.dart';

void main() {
  group('ReAuthResponse', () {
    test('can be created with required fields', () {
      final result = const ReAuthResponse(
        token: 'reauth-token',
        expiresAt: '2026-01-01T01:00:00Z',
      );
      expect(result.token, 'reauth-token');
      expect(result.expiresAt, '2026-01-01T01:00:00Z');
    });

    test('serializes to JSON correctly', () {
      final result = const ReAuthResponse(
        token: 'reauth-token',
        expiresAt: '2026-01-01T01:00:00Z',
      );
      final json = result.toJson();
      expect(json['token'], 'reauth-token');
      expect(json['expiresAt'], '2026-01-01T01:00:00Z');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'token': 'reauth-token',
        'expiresAt': '2026-01-01T01:00:00Z',
      };
      final result = ReAuthResponse.fromJson(json);
      expect(result.token, 'reauth-token');
      expect(result.expiresAt, '2026-01-01T01:00:00Z');
    });

    test('equality works correctly', () {
      final a = const ReAuthResponse(
        token: 'reauth-token',
        expiresAt: '2026-01-01T01:00:00Z',
      );
      final b = const ReAuthResponse(
        token: 'reauth-token',
        expiresAt: '2026-01-01T01:00:00Z',
      );
      final c = const ReAuthResponse(
        token: 'different',
        expiresAt: '2026-01-01T01:00:00Z',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const ReAuthResponse(
        token: 'reauth-token',
        expiresAt: '2026-01-01T01:00:00Z',
      );
      final roundTripped = ReAuthResponse.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
