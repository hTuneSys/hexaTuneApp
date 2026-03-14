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
        appId: 'com.hexatune.app',
      );
      expect(result.token, 'push-token-abc');
      expect(result.platform, 'android');
      expect(result.appId, 'com.hexatune.app');
    });

    test('serializes to JSON correctly', () {
      final result = const RegisterPushTokenRequest(
        token: 'push-token-abc',
        platform: 'android',
        appId: 'com.hexatune.app',
      );
      final json = result.toJson();
      expect(json['token'], 'push-token-abc');
      expect(json['platform'], 'android');
      expect(json['appId'], 'com.hexatune.app');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'token': 'push-token-abc',
        'platform': 'android',
        'appId': 'com.hexatune.app',
      };
      final result = RegisterPushTokenRequest.fromJson(json);
      expect(result.token, 'push-token-abc');
      expect(result.platform, 'android');
      expect(result.appId, 'com.hexatune.app');
    });

    test('equality works correctly', () {
      final a = const RegisterPushTokenRequest(
        token: 'push-token-abc',
        platform: 'android',
        appId: 'com.hexatune.app',
      );
      final b = const RegisterPushTokenRequest(
        token: 'push-token-abc',
        platform: 'android',
        appId: 'com.hexatune.app',
      );
      final c = const RegisterPushTokenRequest(
        token: 'different',
        platform: 'android',
        appId: 'com.hexatune.app',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const RegisterPushTokenRequest(
        token: 'push-token-abc',
        platform: 'android',
        appId: 'com.hexatune.app',
      );
      final roundTripped = RegisterPushTokenRequest.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
