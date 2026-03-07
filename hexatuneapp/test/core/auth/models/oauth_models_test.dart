// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/auth/models/google_auth_request.dart';
import 'package:hexatuneapp/src/core/auth/models/apple_auth_request.dart';
import 'package:hexatuneapp/src/core/auth/models/oauth_login_response.dart';
import 'package:hexatuneapp/src/core/auth/models/switch_tenant_request.dart';
import 'package:hexatuneapp/src/core/auth/models/switch_tenant_response.dart';
import 'package:hexatuneapp/src/core/auth/models/tenant_membership_response.dart';

void main() {
  group('GoogleAuthRequest', () {
    test('fromJson with all fields', () {
      final json = {'idToken': 'google-jwt-token', 'deviceId': 'device-123'};
      final request = GoogleAuthRequest.fromJson(json);
      expect(request.idToken, 'google-jwt-token');
      expect(request.deviceId, 'device-123');
    });

    test('fromJson with required fields only', () {
      final json = {'idToken': 'google-jwt-token'};
      final request = GoogleAuthRequest.fromJson(json);
      expect(request.idToken, 'google-jwt-token');
      expect(request.deviceId, isNull);
    });

    test('toJson produces correct keys', () {
      const request = GoogleAuthRequest(idToken: 'token', deviceId: 'device');
      final json = request.toJson();
      expect(json['idToken'], 'token');
      expect(json['deviceId'], 'device');
    });

    test('round-trip preserves values', () {
      const original = GoogleAuthRequest(idToken: 'tok');
      final restored = GoogleAuthRequest.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('AppleAuthRequest', () {
    test('fromJson with all fields', () {
      final json = {
        'idToken': 'apple-jwt-token',
        'authorizationCode': 'auth-code-123',
        'deviceId': 'device-456',
      };
      final request = AppleAuthRequest.fromJson(json);
      expect(request.idToken, 'apple-jwt-token');
      expect(request.authorizationCode, 'auth-code-123');
      expect(request.deviceId, 'device-456');
    });

    test('fromJson with required fields only', () {
      final json = {'idToken': 'apple-jwt-token'};
      final request = AppleAuthRequest.fromJson(json);
      expect(request.idToken, 'apple-jwt-token');
      expect(request.authorizationCode, isNull);
      expect(request.deviceId, isNull);
    });

    test('toJson produces correct keys', () {
      const request = AppleAuthRequest(
        idToken: 'token',
        authorizationCode: 'code',
      );
      final json = request.toJson();
      expect(json['idToken'], 'token');
      expect(json['authorizationCode'], 'code');
    });

    test('round-trip preserves values', () {
      const original = AppleAuthRequest(idToken: 'tok');
      final restored = AppleAuthRequest.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('OAuthLoginResponse', () {
    test('fromJson creates instance', () {
      final json = {
        'accessToken': 'at-123',
        'refreshToken': 'rt-456',
        'sessionId': 'sess-789',
        'accountId': 'acc-001',
        'expiresAt': '2026-01-01T00:00:00Z',
        'isNewAccount': true,
      };
      final response = OAuthLoginResponse.fromJson(json);
      expect(response.accessToken, 'at-123');
      expect(response.refreshToken, 'rt-456');
      expect(response.sessionId, 'sess-789');
      expect(response.accountId, 'acc-001');
      expect(response.expiresAt, '2026-01-01T00:00:00Z');
      expect(response.isNewAccount, isTrue);
    });

    test('toJson produces correct keys', () {
      const response = OAuthLoginResponse(
        accessToken: 'at',
        refreshToken: 'rt',
        sessionId: 'sid',
        accountId: 'aid',
        expiresAt: 'exp',
        isNewAccount: false,
      );
      final json = response.toJson();
      expect(json['accessToken'], 'at');
      expect(json['refreshToken'], 'rt');
      expect(json['sessionId'], 'sid');
      expect(json['accountId'], 'aid');
      expect(json['expiresAt'], 'exp');
      expect(json['isNewAccount'], isFalse);
    });

    test('round-trip preserves values', () {
      const original = OAuthLoginResponse(
        accessToken: 'a',
        refreshToken: 'r',
        sessionId: 's',
        accountId: 'acc',
        expiresAt: 'e',
        isNewAccount: true,
      );
      final restored = OAuthLoginResponse.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('SwitchTenantRequest', () {
    test('fromJson creates instance', () {
      final json = {'tenantId': '019c9646-e0ec-7e28-9fce-95a20324e7fb'};
      final request = SwitchTenantRequest.fromJson(json);
      expect(request.tenantId, '019c9646-e0ec-7e28-9fce-95a20324e7fb');
    });

    test('toJson produces correct keys', () {
      const request = SwitchTenantRequest(tenantId: 'tid-123');
      final json = request.toJson();
      expect(json['tenantId'], 'tid-123');
    });

    test('round-trip preserves values', () {
      const original = SwitchTenantRequest(tenantId: 't');
      final restored = SwitchTenantRequest.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('SwitchTenantResponse', () {
    test('fromJson creates instance', () {
      final json = {
        'accessToken': 'new-at',
        'refreshToken': 'new-rt',
        'sessionId': 'new-sid',
      };
      final response = SwitchTenantResponse.fromJson(json);
      expect(response.accessToken, 'new-at');
      expect(response.refreshToken, 'new-rt');
      expect(response.sessionId, 'new-sid');
    });

    test('toJson produces correct keys', () {
      const response = SwitchTenantResponse(
        accessToken: 'a',
        refreshToken: 'r',
        sessionId: 's',
      );
      final json = response.toJson();
      expect(json['accessToken'], 'a');
      expect(json['refreshToken'], 'r');
      expect(json['sessionId'], 's');
    });

    test('round-trip preserves values', () {
      const original = SwitchTenantResponse(
        accessToken: 'a',
        refreshToken: 'r',
        sessionId: 's',
      );
      final restored = SwitchTenantResponse.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('TenantMembershipResponse', () {
    test('fromJson with all fields', () {
      final json = {
        'id': 'mem-001',
        'tenantId': 'tid-001',
        'role': 'owner',
        'status': 'active',
        'isOwner': true,
        'joinedAt': '2025-01-01T00:00:00Z',
      };
      final response = TenantMembershipResponse.fromJson(json);
      expect(response.id, 'mem-001');
      expect(response.tenantId, 'tid-001');
      expect(response.role, 'owner');
      expect(response.status, 'active');
      expect(response.isOwner, isTrue);
      expect(response.joinedAt, '2025-01-01T00:00:00Z');
    });

    test('fromJson with optional fields absent', () {
      final json = {
        'id': 'mem-002',
        'tenantId': 'tid-002',
        'role': 'viewer',
        'status': 'invited',
        'isOwner': false,
      };
      final response = TenantMembershipResponse.fromJson(json);
      expect(response.joinedAt, isNull);
      expect(response.isOwner, isFalse);
    });

    test('toJson produces correct keys', () {
      const response = TenantMembershipResponse(
        id: 'm',
        tenantId: 't',
        role: 'editor',
        status: 'active',
        isOwner: false,
        joinedAt: '2025-01-01T00:00:00Z',
      );
      final json = response.toJson();
      expect(json['id'], 'm');
      expect(json['tenantId'], 't');
      expect(json['role'], 'editor');
      expect(json['status'], 'active');
      expect(json['isOwner'], isFalse);
      expect(json['joinedAt'], '2025-01-01T00:00:00Z');
    });

    test('round-trip preserves values', () {
      const original = TenantMembershipResponse(
        id: 'i',
        tenantId: 't',
        role: 'r',
        status: 's',
        isOwner: true,
      );
      final restored = TenantMembershipResponse.fromJson(original.toJson());
      expect(restored, original);
    });
  });
}
