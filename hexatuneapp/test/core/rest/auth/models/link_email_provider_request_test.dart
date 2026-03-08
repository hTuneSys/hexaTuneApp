// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/auth/models/link_email_provider_request.dart';

void main() {
  group('LinkEmailProviderRequest', () {
    test('can be created with required fields', () {
      final result = const LinkEmailProviderRequest(
        email: 'link@example.com',
        password: 'linkPassword123',
      );
      expect(result.email, 'link@example.com');
      expect(result.password, 'linkPassword123');
    });

    test('serializes to JSON correctly', () {
      final result = const LinkEmailProviderRequest(
        email: 'link@example.com',
        password: 'linkPassword123',
      );
      final json = result.toJson();
      expect(json['email'], 'link@example.com');
      expect(json['password'], 'linkPassword123');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'email': 'link@example.com',
        'password': 'linkPassword123',
      };
      final result = LinkEmailProviderRequest.fromJson(json);
      expect(result.email, 'link@example.com');
      expect(result.password, 'linkPassword123');
    });

    test('equality works correctly', () {
      final a = const LinkEmailProviderRequest(
        email: 'link@example.com',
        password: 'linkPassword123',
      );
      final b = const LinkEmailProviderRequest(
        email: 'link@example.com',
        password: 'linkPassword123',
      );
      final c = const LinkEmailProviderRequest(
        email: 'different',
        password: 'linkPassword123',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const LinkEmailProviderRequest(
        email: 'link@example.com',
        password: 'linkPassword123',
      );
      final roundTripped = LinkEmailProviderRequest.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
