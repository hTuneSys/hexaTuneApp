// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/auth/models/refresh_request.dart';

void main() {
  group('RefreshRequest', () {
    test('can be created with required fields', () {
      final result = const RefreshRequest(refreshToken: 'refresh-token-456');
      expect(result.refreshToken, 'refresh-token-456');
    });

    test('serializes to JSON correctly', () {
      final result = const RefreshRequest(refreshToken: 'refresh-token-456');
      final json = result.toJson();
      expect(json['refreshToken'], 'refresh-token-456');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{'refreshToken': 'refresh-token-456'};
      final result = RefreshRequest.fromJson(json);
      expect(result.refreshToken, 'refresh-token-456');
    });

    test('equality works correctly', () {
      final a = const RefreshRequest(refreshToken: 'refresh-token-456');
      final b = const RefreshRequest(refreshToken: 'refresh-token-456');
      final c = const RefreshRequest(refreshToken: 'different');
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const RefreshRequest(refreshToken: 'refresh-token-456');
      final roundTripped = RefreshRequest.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
