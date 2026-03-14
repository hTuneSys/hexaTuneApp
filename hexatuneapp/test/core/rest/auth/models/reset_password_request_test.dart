// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/auth/models/reset_password_request.dart';

void main() {
  group('ResetPasswordRequest', () {
    test('can be created with required fields', () {
      final result = const ResetPasswordRequest(
        email: 'user@example.com',
        code: '123456',
        newPassword: 'newPassword123',
      );
      expect(result.email, 'user@example.com');
      expect(result.code, '123456');
      expect(result.newPassword, 'newPassword123');
    });

    test('serializes to JSON correctly', () {
      final result = const ResetPasswordRequest(
        email: 'user@example.com',
        code: '123456',
        newPassword: 'newPassword123',
      );
      final json = result.toJson();
      expect(json['email'], 'user@example.com');
      expect(json['code'], '123456');
      expect(json['newPassword'], 'newPassword123');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'email': 'user@example.com',
        'code': '123456',
        'newPassword': 'newPassword123',
      };
      final result = ResetPasswordRequest.fromJson(json);
      expect(result.email, 'user@example.com');
      expect(result.code, '123456');
      expect(result.newPassword, 'newPassword123');
    });

    test('equality works correctly', () {
      final a = const ResetPasswordRequest(
        email: 'user@example.com',
        code: '123456',
        newPassword: 'newPassword123',
      );
      final b = const ResetPasswordRequest(
        email: 'user@example.com',
        code: '123456',
        newPassword: 'newPassword123',
      );
      final c = const ResetPasswordRequest(
        email: 'different',
        code: '123456',
        newPassword: 'newPassword123',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const ResetPasswordRequest(
        email: 'user@example.com',
        code: '123456',
        newPassword: 'newPassword123',
      );
      final roundTripped = ResetPasswordRequest.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
