// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/account/models/account_response.dart';
import 'package:hexatuneapp/src/core/rest/account/models/profile_response.dart';
import 'package:hexatuneapp/src/core/rest/account/models/update_profile_request.dart';

void main() {
  group('AccountResponse', () {
    test('fromJson creates instance', () {
      final json = {
        'id': 'acc-001',
        'status': 'active',
        'createdAt': '2025-01-01T00:00:00Z',
        'updatedAt': '2025-06-01T00:00:00Z',
      };
      final response = AccountResponse.fromJson(json);
      expect(response.id, 'acc-001');
      expect(response.status, 'active');
      expect(response.createdAt, '2025-01-01T00:00:00Z');
      expect(response.updatedAt, '2025-06-01T00:00:00Z');
      expect(response.lockedAt, isNull);
      expect(response.suspendedAt, isNull);
    });

    test('fromJson with optional fields', () {
      final json = {
        'id': 'acc-002',
        'status': 'locked',
        'createdAt': '2025-01-01T00:00:00Z',
        'updatedAt': '2025-06-01T00:00:00Z',
        'lockedAt': '2025-06-01T12:00:00Z',
      };
      final response = AccountResponse.fromJson(json);
      expect(response.status, 'locked');
      expect(response.lockedAt, '2025-06-01T12:00:00Z');
      expect(response.suspendedAt, isNull);
    });

    test('fromJson with suspendedAt', () {
      final json = {
        'id': 'acc-003',
        'status': 'suspended',
        'createdAt': '2025-01-01T00:00:00Z',
        'updatedAt': '2025-06-01T00:00:00Z',
        'suspendedAt': '2025-06-01T12:00:00Z',
      };
      final response = AccountResponse.fromJson(json);
      expect(response.status, 'suspended');
      expect(response.suspendedAt, '2025-06-01T12:00:00Z');
      expect(response.lockedAt, isNull);
    });

    test('toJson produces correct keys', () {
      const response = AccountResponse(
        id: 'acc-001',
        status: 'active',
        createdAt: '2025-01-01T00:00:00Z',
        updatedAt: '2025-06-01T00:00:00Z',
      );
      final json = response.toJson();
      expect(json['id'], 'acc-001');
      expect(json['status'], 'active');
      expect(json['createdAt'], '2025-01-01T00:00:00Z');
      expect(json['updatedAt'], '2025-06-01T00:00:00Z');
      expect(json.containsKey('lockedAt'), isTrue);
      expect(json['lockedAt'], isNull);
    });

    test('round-trip preserves values', () {
      const original = AccountResponse(
        id: 'a',
        status: 's',
        createdAt: 'c',
        updatedAt: 'u',
      );
      final restored = AccountResponse.fromJson(original.toJson());
      expect(restored, original);
    });

    test('round-trip with optional fields', () {
      const original = AccountResponse(
        id: 'a',
        status: 'locked',
        createdAt: 'c',
        updatedAt: 'u',
        lockedAt: '2025-06-01T12:00:00Z',
        suspendedAt: '2025-06-02T12:00:00Z',
      );
      final restored = AccountResponse.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('ProfileResponse', () {
    test('fromJson with all fields', () {
      final json = {
        'accountId': 'acc-001',
        'displayName': 'Test User',
        'avatarUrl': 'https://example.com/avatar.png',
        'bio': 'A bio.',
        'updatedAt': '2025-06-01T00:00:00Z',
      };
      final response = ProfileResponse.fromJson(json);
      expect(response.accountId, 'acc-001');
      expect(response.displayName, 'Test User');
      expect(response.avatarUrl, 'https://example.com/avatar.png');
      expect(response.bio, 'A bio.');
      expect(response.updatedAt, '2025-06-01T00:00:00Z');
    });

    test('fromJson with optional fields absent', () {
      final json = {
        'accountId': 'acc-002',
        'updatedAt': '2025-06-01T00:00:00Z',
      };
      final response = ProfileResponse.fromJson(json);
      expect(response.accountId, 'acc-002');
      expect(response.displayName, isNull);
      expect(response.avatarUrl, isNull);
      expect(response.bio, isNull);
    });

    test('toJson produces correct keys', () {
      const response = ProfileResponse(
        accountId: 'acc-001',
        displayName: 'Name',
        avatarUrl: 'https://example.com/img.png',
        bio: 'Bio text',
        updatedAt: '2025-06-01T00:00:00Z',
      );
      final json = response.toJson();
      expect(json['accountId'], 'acc-001');
      expect(json['displayName'], 'Name');
      expect(json['avatarUrl'], 'https://example.com/img.png');
      expect(json['bio'], 'Bio text');
      expect(json['updatedAt'], '2025-06-01T00:00:00Z');
    });

    test('round-trip preserves values', () {
      const original = ProfileResponse(accountId: 'a', updatedAt: 'u');
      final restored = ProfileResponse.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('UpdateProfileRequest', () {
    test('fromJson with all fields', () {
      final json = {
        'displayName': 'New Name',
        'avatarUrl': 'https://example.com/new.png',
        'bio': 'Updated bio',
      };
      final request = UpdateProfileRequest.fromJson(json);
      expect(request.displayName, 'New Name');
      expect(request.avatarUrl, 'https://example.com/new.png');
      expect(request.bio, 'Updated bio');
    });

    test('fromJson with no fields (all optional)', () {
      final json = <String, dynamic>{};
      final request = UpdateProfileRequest.fromJson(json);
      expect(request.displayName, isNull);
      expect(request.avatarUrl, isNull);
      expect(request.bio, isNull);
    });

    test('toJson produces correct keys', () {
      const request = UpdateProfileRequest(displayName: 'Name', bio: 'Bio');
      final json = request.toJson();
      expect(json['displayName'], 'Name');
      expect(json['bio'], 'Bio');
    });

    test('round-trip preserves values', () {
      const original = UpdateProfileRequest(displayName: 'D');
      final restored = UpdateProfileRequest.fromJson(original.toJson());
      expect(restored, original);
    });
  });
}
