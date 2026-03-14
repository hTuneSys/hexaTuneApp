// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/auth/models/verify_email_request.dart';

void main() {
  group('VerifyEmailRequest', () {
    test('can be created with required fields', () {
      final result = const VerifyEmailRequest(
        email: 'user@example.com',
        code: '654321',
      );
      expect(result.email, 'user@example.com');
      expect(result.code, '654321');
    });

    test('serializes to JSON correctly', () {
      final result = const VerifyEmailRequest(
        email: 'user@example.com',
        code: '654321',
      );
      final json = result.toJson();
      expect(json['email'], 'user@example.com');
      expect(json['code'], '654321');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'email': 'user@example.com',
        'code': '654321',
      };
      final result = VerifyEmailRequest.fromJson(json);
      expect(result.email, 'user@example.com');
      expect(result.code, '654321');
    });

    test('equality works correctly', () {
      final a = const VerifyEmailRequest(
        email: 'user@example.com',
        code: '654321',
      );
      final b = const VerifyEmailRequest(
        email: 'user@example.com',
        code: '654321',
      );
      final c = const VerifyEmailRequest(email: 'different', code: '654321');
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const VerifyEmailRequest(
        email: 'user@example.com',
        code: '654321',
      );
      final roundTripped = VerifyEmailRequest.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
