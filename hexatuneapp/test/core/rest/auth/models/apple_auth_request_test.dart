// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/auth/models/apple_auth_request.dart';

void main() {
  group('AppleAuthRequest', () {
    test('can be created with required fields', () {
      final result = const AppleAuthRequest(idToken: 'apple-id-token');
      expect(result.idToken, 'apple-id-token');
    });

    test('serializes to JSON correctly', () {
      final result = const AppleAuthRequest(idToken: 'apple-id-token');
      final json = result.toJson();
      expect(json['idToken'], 'apple-id-token');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{'idToken': 'apple-id-token'};
      final result = AppleAuthRequest.fromJson(json);
      expect(result.idToken, 'apple-id-token');
    });

    test('equality works correctly', () {
      final a = const AppleAuthRequest(idToken: 'apple-id-token');
      final b = const AppleAuthRequest(idToken: 'apple-id-token');
      final c = const AppleAuthRequest(idToken: 'different');
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const AppleAuthRequest(idToken: 'apple-id-token');
      final roundTripped = AppleAuthRequest.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
