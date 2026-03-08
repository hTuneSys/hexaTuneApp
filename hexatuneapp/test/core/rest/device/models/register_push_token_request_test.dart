// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/device/models/register_push_token_request.dart';

void main() {
  group('RegisterPushTokenRequest', () {
    test('can be created with required fields', () {
      final result = const RegisterPushTokenRequest(
        token: 'push-token-abc',
        platform: 'android',
      );
      expect(result.token, 'push-token-abc');
      expect(result.platform, 'android');
    });

    test('serializes to JSON correctly', () {
      final result = const RegisterPushTokenRequest(
        token: 'push-token-abc',
        platform: 'android',
      );
      final json = result.toJson();
      expect(json['token'], 'push-token-abc');
      expect(json['platform'], 'android');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'token': 'push-token-abc',
        'platform': 'android',
      };
      final result = RegisterPushTokenRequest.fromJson(json);
      expect(result.token, 'push-token-abc');
      expect(result.platform, 'android');
    });

    test('equality works correctly', () {
      final a = const RegisterPushTokenRequest(
        token: 'push-token-abc',
        platform: 'android',
      );
      final b = const RegisterPushTokenRequest(
        token: 'push-token-abc',
        platform: 'android',
      );
      final c = const RegisterPushTokenRequest(
        token: 'different',
        platform: 'android',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const RegisterPushTokenRequest(
        token: 'push-token-abc',
        platform: 'android',
      );
      final roundTripped = RegisterPushTokenRequest.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
