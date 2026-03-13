// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/auth/models/login_request.dart';

void main() {
  group('LoginRequest', () {
    test('can be created with required fields', () {
      final result = const LoginRequest(
        email: 'user@example.com',
        password: 'password123',
      );
      expect(result.email, 'user@example.com');
      expect(result.password, 'password123');
      expect(result.deviceId, isNull);
    });

    test('serializes to JSON correctly', () {
      final result = const LoginRequest(
        email: 'user@example.com',
        password: 'password123',
      );
      final json = result.toJson();
      expect(json['email'], 'user@example.com');
      expect(json['password'], 'password123');
      expect(json.containsKey('tenantId'), isFalse);
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'email': 'user@example.com',
        'password': 'password123',
      };
      final result = LoginRequest.fromJson(json);
      expect(result.email, 'user@example.com');
      expect(result.password, 'password123');
    });

    test('equality works correctly', () {
      final a = const LoginRequest(
        email: 'user@example.com',
        password: 'password123',
      );
      final b = const LoginRequest(
        email: 'user@example.com',
        password: 'password123',
      );
      final c = const LoginRequest(email: 'different', password: 'password123');
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const LoginRequest(
        email: 'user@example.com',
        password: 'password123',
        deviceId: 'dev-123',
      );
      final roundTripped = LoginRequest.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
