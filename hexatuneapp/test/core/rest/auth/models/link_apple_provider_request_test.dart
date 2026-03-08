// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/auth/models/link_apple_provider_request.dart';

void main() {
  group('LinkAppleProviderRequest', () {
    test('can be created with required fields', () {
      final result = const LinkAppleProviderRequest(
        idToken: 'apple-link-token',
      );
      expect(result.idToken, 'apple-link-token');
    });

    test('serializes to JSON correctly', () {
      final result = const LinkAppleProviderRequest(
        idToken: 'apple-link-token',
      );
      final json = result.toJson();
      expect(json['idToken'], 'apple-link-token');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{'idToken': 'apple-link-token'};
      final result = LinkAppleProviderRequest.fromJson(json);
      expect(result.idToken, 'apple-link-token');
    });

    test('equality works correctly', () {
      final a = const LinkAppleProviderRequest(idToken: 'apple-link-token');
      final b = const LinkAppleProviderRequest(idToken: 'apple-link-token');
      final c = const LinkAppleProviderRequest(idToken: 'different');
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const LinkAppleProviderRequest(
        idToken: 'apple-link-token',
      );
      final roundTripped = LinkAppleProviderRequest.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
