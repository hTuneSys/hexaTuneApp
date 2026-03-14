// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/auth/models/link_google_provider_request.dart';

void main() {
  group('LinkGoogleProviderRequest', () {
    test('can be created with required fields', () {
      final result = const LinkGoogleProviderRequest(
        idToken: 'google-link-token',
      );
      expect(result.idToken, 'google-link-token');
    });

    test('serializes to JSON correctly', () {
      final result = const LinkGoogleProviderRequest(
        idToken: 'google-link-token',
      );
      final json = result.toJson();
      expect(json['idToken'], 'google-link-token');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{'idToken': 'google-link-token'};
      final result = LinkGoogleProviderRequest.fromJson(json);
      expect(result.idToken, 'google-link-token');
    });

    test('equality works correctly', () {
      final a = const LinkGoogleProviderRequest(idToken: 'google-link-token');
      final b = const LinkGoogleProviderRequest(idToken: 'google-link-token');
      final c = const LinkGoogleProviderRequest(idToken: 'different');
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const LinkGoogleProviderRequest(
        idToken: 'google-link-token',
      );
      final roundTripped = LinkGoogleProviderRequest.fromJson(
        original.toJson(),
      );
      expect(roundTripped, equals(original));
    });
  });
}
