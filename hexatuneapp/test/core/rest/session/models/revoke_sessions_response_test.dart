// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/session/models/revoke_sessions_response.dart';

void main() {
  group('RevokeSessionsResponse', () {
    test('can be created with required fields', () {
      final result = const RevokeSessionsResponse(revokedCount: 3);
      expect(result.revokedCount, 3);
    });

    test('serializes to JSON correctly', () {
      final result = const RevokeSessionsResponse(revokedCount: 3);
      final json = result.toJson();
      expect(json['revokedCount'], 3);
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{'revokedCount': 3};
      final result = RevokeSessionsResponse.fromJson(json);
      expect(result.revokedCount, 3);
    });

    test('equality works correctly', () {
      final a = const RevokeSessionsResponse(revokedCount: 3);
      final b = const RevokeSessionsResponse(revokedCount: 3);
      final c = const RevokeSessionsResponse(revokedCount: 999);
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const RevokeSessionsResponse(revokedCount: 3);
      final roundTripped = RevokeSessionsResponse.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
