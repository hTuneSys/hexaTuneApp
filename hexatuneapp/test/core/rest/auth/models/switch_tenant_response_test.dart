// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/auth/models/switch_tenant_response.dart';

void main() {
  group('SwitchTenantResponse', () {
    test('can be created with required fields', () {
      final result = const SwitchTenantResponse(
        accessToken: 'switched-access-token',
        refreshToken: 'switched-refresh-token',
        sessionId: 'switched-session',
      );
      expect(result.accessToken, 'switched-access-token');
      expect(result.refreshToken, 'switched-refresh-token');
      expect(result.sessionId, 'switched-session');
    });

    test('serializes to JSON correctly', () {
      final result = const SwitchTenantResponse(
        accessToken: 'switched-access-token',
        refreshToken: 'switched-refresh-token',
        sessionId: 'switched-session',
      );
      final json = result.toJson();
      expect(json['accessToken'], 'switched-access-token');
      expect(json['refreshToken'], 'switched-refresh-token');
      expect(json['sessionId'], 'switched-session');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'accessToken': 'switched-access-token',
        'refreshToken': 'switched-refresh-token',
        'sessionId': 'switched-session',
      };
      final result = SwitchTenantResponse.fromJson(json);
      expect(result.accessToken, 'switched-access-token');
      expect(result.refreshToken, 'switched-refresh-token');
      expect(result.sessionId, 'switched-session');
    });

    test('equality works correctly', () {
      final a = const SwitchTenantResponse(
        accessToken: 'switched-access-token',
        refreshToken: 'switched-refresh-token',
        sessionId: 'switched-session',
      );
      final b = const SwitchTenantResponse(
        accessToken: 'switched-access-token',
        refreshToken: 'switched-refresh-token',
        sessionId: 'switched-session',
      );
      final c = const SwitchTenantResponse(
        accessToken: 'different',
        refreshToken: 'switched-refresh-token',
        sessionId: 'switched-session',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const SwitchTenantResponse(
        accessToken: 'switched-access-token',
        refreshToken: 'switched-refresh-token',
        sessionId: 'switched-session',
      );
      final roundTripped = SwitchTenantResponse.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
