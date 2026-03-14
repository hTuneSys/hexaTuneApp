// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/account/models/account_response.dart';
import 'package:hexatuneapp/src/core/rest/account/models/profile_response.dart';
import 'package:hexatuneapp/src/core/rest/account/models/update_profile_request.dart';

void main() {
  group('AccountResponse', () {
    test('fromJson creates instance with all fields', () {
      final json = {
        'id': 'acc-001',
        'status': 'active',
        'createdAt': '2025-01-01T00:00:00Z',
        'updatedAt': '2025-01-02T00:00:00Z',
        'lockedAt': '2025-01-03T00:00:00Z',
        'suspendedAt': '2025-01-04T00:00:00Z',
      };
      final response = AccountResponse.fromJson(json);
      expect(response.id, 'acc-001');
      expect(response.status, 'active');
      expect(response.lockedAt, '2025-01-03T00:00:00Z');
      expect(response.suspendedAt, '2025-01-04T00:00:00Z');
    });

    test('toJson produces correct keys', () {
      const response = AccountResponse(
        id: 'acc-001',
        status: 'active',
        createdAt: '2025-01-01T00:00:00Z',
        updatedAt: '2025-01-02T00:00:00Z',
      );
      final json = response.toJson();
      expect(json['id'], 'acc-001');
      expect(json['status'], 'active');
      expect(json['createdAt'], '2025-01-01T00:00:00Z');
    });

    test('optional fields default to null', () {
      final json = {
        'id': 'acc-001',
        'status': 'active',
        'createdAt': '2025-01-01T00:00:00Z',
        'updatedAt': '2025-01-02T00:00:00Z',
      };
      final response = AccountResponse.fromJson(json);
      expect(response.lockedAt, isNull);
      expect(response.suspendedAt, isNull);
    });
  });

  group('ProfileResponse', () {
    test('fromJson creates instance', () {
      final json = {
        'accountId': 'acc-001',
        'displayName': 'Test User',
        'avatarUrl': 'https://example.com/avatar.png',
        'bio': 'A bio',
        'updatedAt': '2025-01-01T00:00:00Z',
      };
      final response = ProfileResponse.fromJson(json);
      expect(response.accountId, 'acc-001');
      expect(response.displayName, 'Test User');
      expect(response.avatarUrl, 'https://example.com/avatar.png');
      expect(response.bio, 'A bio');
    });

    test('toJson produces correct keys', () {
      const response = ProfileResponse(
        accountId: 'acc-001',
        displayName: 'User',
        updatedAt: '2025-01-01T00:00:00Z',
      );
      final json = response.toJson();
      expect(json['accountId'], 'acc-001');
      expect(json['displayName'], 'User');
    });

    test('optional fields default to null', () {
      final json = {
        'accountId': 'acc-001',
        'updatedAt': '2025-01-01T00:00:00Z',
      };
      final response = ProfileResponse.fromJson(json);
      expect(response.displayName, isNull);
      expect(response.avatarUrl, isNull);
      expect(response.bio, isNull);
    });
  });

  group('UpdateProfileRequest', () {
    test('fromJson creates instance', () {
      final json = {
        'displayName': 'New Name',
        'avatarUrl': 'https://example.com/new.png',
        'bio': 'New bio',
      };
      final request = UpdateProfileRequest.fromJson(json);
      expect(request.displayName, 'New Name');
      expect(request.avatarUrl, 'https://example.com/new.png');
      expect(request.bio, 'New bio');
    });

    test('toJson produces correct keys', () {
      const request = UpdateProfileRequest(displayName: 'Name', bio: 'Bio');
      final json = request.toJson();
      expect(json['displayName'], 'Name');
      expect(json['bio'], 'Bio');
    });

    test('all fields are optional', () {
      const request = UpdateProfileRequest();
      expect(request.displayName, isNull);
      expect(request.avatarUrl, isNull);
      expect(request.bio, isNull);
    });
  });
}
