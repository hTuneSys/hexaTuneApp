// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/device/models/unregister_push_token_request.dart';

void main() {
  group('UnregisterPushTokenRequest', () {
    test('can be created with required fields', () {
      const result = UnregisterPushTokenRequest(appId: 'com.hexatune.app');
      expect(result.appId, 'com.hexatune.app');
    });

    test('serializes to JSON correctly', () {
      const result = UnregisterPushTokenRequest(appId: 'com.hexatune.app');
      final json = result.toJson();
      expect(json['appId'], 'com.hexatune.app');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{'appId': 'com.hexatune.app'};
      final result = UnregisterPushTokenRequest.fromJson(json);
      expect(result.appId, 'com.hexatune.app');
    });

    test('equality works correctly', () {
      const a = UnregisterPushTokenRequest(appId: 'com.hexatune.app');
      const b = UnregisterPushTokenRequest(appId: 'com.hexatune.app');
      const c = UnregisterPushTokenRequest(appId: 'different');
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      const original = UnregisterPushTokenRequest(appId: 'com.hexatune.app');
      final roundTripped = UnregisterPushTokenRequest.fromJson(
        original.toJson(),
      );
      expect(roundTripped, equals(original));
    });
  });
}
