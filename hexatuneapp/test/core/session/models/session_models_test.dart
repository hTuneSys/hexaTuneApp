// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/session/models/session_response.dart';
import 'package:hexatuneapp/src/core/session/models/revoke_sessions_response.dart';

void main() {
  group('SessionResponse', () {
    test('fromJson creates instance', () {
      final json = {
        'id': 'sess-001',
        'accountId': 'acc-001',
        'deviceId': 'dev-001',
        'createdAt': '2025-01-01T00:00:00Z',
        'expiresAt': '2025-12-31T23:59:59Z',
      };
      final response = SessionResponse.fromJson(json);
      expect(response.id, 'sess-001');
      expect(response.accountId, 'acc-001');
      expect(response.deviceId, 'dev-001');
      expect(response.createdAt, '2025-01-01T00:00:00Z');
      expect(response.expiresAt, '2025-12-31T23:59:59Z');
    });

    test('toJson produces correct keys', () {
      const response = SessionResponse(
        id: 'sess-001',
        accountId: 'acc-001',
        deviceId: 'dev-001',
        createdAt: '2025-01-01T00:00:00Z',
        expiresAt: '2025-12-31T23:59:59Z',
      );
      final json = response.toJson();
      expect(json['id'], 'sess-001');
      expect(json['accountId'], 'acc-001');
      expect(json['deviceId'], 'dev-001');
      expect(json['createdAt'], '2025-01-01T00:00:00Z');
      expect(json['expiresAt'], '2025-12-31T23:59:59Z');
    });

    test('round-trip preserves values', () {
      const original = SessionResponse(
        id: 's',
        accountId: 'a',
        deviceId: 'd',
        createdAt: 'c',
        expiresAt: 'e',
      );
      final restored = SessionResponse.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('RevokeSessionsResponse', () {
    test('fromJson creates instance', () {
      final json = {'revokedCount': 3};
      final response = RevokeSessionsResponse.fromJson(json);
      expect(response.revokedCount, 3);
    });

    test('toJson produces correct keys', () {
      const response = RevokeSessionsResponse(revokedCount: 5);
      final json = response.toJson();
      expect(json['revokedCount'], 5);
    });

    test('round-trip preserves values', () {
      const original = RevokeSessionsResponse(revokedCount: 0);
      final restored = RevokeSessionsResponse.fromJson(original.toJson());
      expect(restored, original);
    });
  });
}
