// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/auth/models/re_auth_request.dart';

void main() {
  group('ReAuthRequest', () {
    test('can be created with required fields', () {
      final result = const ReAuthRequest(password: 'password123');
      expect(result.password, 'password123');
    });

    test('serializes to JSON correctly', () {
      final result = const ReAuthRequest(password: 'password123');
      final json = result.toJson();
      expect(json['password'], 'password123');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{'password': 'password123'};
      final result = ReAuthRequest.fromJson(json);
      expect(result.password, 'password123');
    });

    test('equality works correctly', () {
      final a = const ReAuthRequest(password: 'password123');
      final b = const ReAuthRequest(password: 'password123');
      final c = const ReAuthRequest(password: 'different');
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const ReAuthRequest(password: 'password123');
      final roundTripped = ReAuthRequest.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
