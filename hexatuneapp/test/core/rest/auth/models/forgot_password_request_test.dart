// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/auth/models/forgot_password_request.dart';

void main() {
  group('ForgotPasswordRequest', () {
    test('can be created with required fields', () {
      final result = const ForgotPasswordRequest(email: 'user@example.com');
      expect(result.email, 'user@example.com');
    });

    test('serializes to JSON correctly', () {
      final result = const ForgotPasswordRequest(email: 'user@example.com');
      final json = result.toJson();
      expect(json['email'], 'user@example.com');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{'email': 'user@example.com'};
      final result = ForgotPasswordRequest.fromJson(json);
      expect(result.email, 'user@example.com');
    });

    test('equality works correctly', () {
      final a = const ForgotPasswordRequest(email: 'user@example.com');
      final b = const ForgotPasswordRequest(email: 'user@example.com');
      final c = const ForgotPasswordRequest(email: 'different');
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const ForgotPasswordRequest(email: 'user@example.com');
      final roundTripped = ForgotPasswordRequest.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
