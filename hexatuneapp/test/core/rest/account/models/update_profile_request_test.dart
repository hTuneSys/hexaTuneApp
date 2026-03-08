// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/account/models/update_profile_request.dart';

void main() {
  group('UpdateProfileRequest', () {
    test('can be created with optional fields', () {
      const result = UpdateProfileRequest(
        displayName: 'New Name',
        avatarUrl: 'https://example.com/new.png',
        bio: 'Updated bio',
      );
      expect(result.displayName, 'New Name');
      expect(result.avatarUrl, 'https://example.com/new.png');
      expect(result.bio, 'Updated bio');
    });

    test('can be created with no fields', () {
      const result = UpdateProfileRequest();
      expect(result.displayName, isNull);
      expect(result.avatarUrl, isNull);
      expect(result.bio, isNull);
    });

    test('serializes to JSON correctly', () {
      const result = UpdateProfileRequest(displayName: 'Test');
      final json = result.toJson();
      expect(json['displayName'], 'Test');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'displayName': 'Test',
        'avatarUrl': 'https://example.com/avatar.png',
      };
      final result = UpdateProfileRequest.fromJson(json);
      expect(result.displayName, 'Test');
      expect(result.avatarUrl, 'https://example.com/avatar.png');
      expect(result.bio, isNull);
    });

    test('equality works correctly', () {
      const a = UpdateProfileRequest(displayName: 'Same');
      const b = UpdateProfileRequest(displayName: 'Same');
      const c = UpdateProfileRequest(displayName: 'Different');
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      const original = UpdateProfileRequest(
        displayName: 'Round Trip',
        bio: 'Test bio',
      );
      final roundTripped = UpdateProfileRequest.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
