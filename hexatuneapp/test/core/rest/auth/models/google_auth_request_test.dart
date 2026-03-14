// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/auth/models/google_auth_request.dart';

void main() {
  group('GoogleAuthRequest', () {
    test('can be created with required fields', () {
      final result = const GoogleAuthRequest(idToken: 'google-id-token');
      expect(result.idToken, 'google-id-token');
    });

    test('serializes to JSON correctly', () {
      final result = const GoogleAuthRequest(idToken: 'google-id-token');
      final json = result.toJson();
      expect(json['idToken'], 'google-id-token');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{'idToken': 'google-id-token'};
      final result = GoogleAuthRequest.fromJson(json);
      expect(result.idToken, 'google-id-token');
    });

    test('equality works correctly', () {
      final a = const GoogleAuthRequest(idToken: 'google-id-token');
      final b = const GoogleAuthRequest(idToken: 'google-id-token');
      final c = const GoogleAuthRequest(idToken: 'different');
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const GoogleAuthRequest(idToken: 'google-id-token');
      final roundTripped = GoogleAuthRequest.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
