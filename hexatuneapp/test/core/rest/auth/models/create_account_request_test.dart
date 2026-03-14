// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/auth/models/create_account_request.dart';

void main() {
  group('CreateAccountRequest', () {
    test('can be created with required fields', () {
      final result = const CreateAccountRequest(
        email: 'new@example.com',
        password: 'password123',
      );
      expect(result.email, 'new@example.com');
      expect(result.password, 'password123');
    });

    test('serializes to JSON correctly', () {
      final result = const CreateAccountRequest(
        email: 'new@example.com',
        password: 'password123',
      );
      final json = result.toJson();
      expect(json['email'], 'new@example.com');
      expect(json['password'], 'password123');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'email': 'new@example.com',
        'password': 'password123',
      };
      final result = CreateAccountRequest.fromJson(json);
      expect(result.email, 'new@example.com');
      expect(result.password, 'password123');
    });

    test('equality works correctly', () {
      final a = const CreateAccountRequest(
        email: 'new@example.com',
        password: 'password123',
      );
      final b = const CreateAccountRequest(
        email: 'new@example.com',
        password: 'password123',
      );
      final c = const CreateAccountRequest(
        email: 'different',
        password: 'password123',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const CreateAccountRequest(
        email: 'new@example.com',
        password: 'password123',
      );
      final roundTripped = CreateAccountRequest.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
