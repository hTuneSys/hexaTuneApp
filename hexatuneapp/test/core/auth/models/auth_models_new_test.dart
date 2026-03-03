// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/auth/models/refresh_request.dart';
import 'package:hexatuneapp/src/core/auth/models/refresh_response.dart';
import 'package:hexatuneapp/src/core/auth/models/re_auth_request.dart';
import 'package:hexatuneapp/src/core/auth/models/re_auth_response.dart';
import 'package:hexatuneapp/src/core/auth/models/create_account_request.dart';
import 'package:hexatuneapp/src/core/auth/models/forgot_password_request.dart';
import 'package:hexatuneapp/src/core/auth/models/reset_password_request.dart';
import 'package:hexatuneapp/src/core/auth/models/verify_email_request.dart';
import 'package:hexatuneapp/src/core/auth/models/resend_verification_request.dart';

void main() {
  group('RefreshRequest', () {
    test('fromJson creates instance', () {
      final json = {'refreshToken': 'ref-tok-123'};
      final request = RefreshRequest.fromJson(json);
      expect(request.refreshToken, 'ref-tok-123');
    });

    test('toJson produces correct keys', () {
      const request = RefreshRequest(refreshToken: 'ref-tok-123');
      final json = request.toJson();
      expect(json['refreshToken'], 'ref-tok-123');
    });

    test('round-trip preserves values', () {
      const original = RefreshRequest(refreshToken: 'tok');
      final restored = RefreshRequest.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('RefreshResponse', () {
    test('fromJson creates instance', () {
      final json = {
        'accessToken': 'access-new',
        'refreshToken': 'refresh-new',
        'sessionId': 'sess-001',
        'expiresAt': '2025-12-31T23:59:59Z',
      };
      final response = RefreshResponse.fromJson(json);
      expect(response.accessToken, 'access-new');
      expect(response.refreshToken, 'refresh-new');
      expect(response.sessionId, 'sess-001');
      expect(response.expiresAt, '2025-12-31T23:59:59Z');
    });

    test('toJson produces correct keys', () {
      const response = RefreshResponse(
        accessToken: 'access-new',
        refreshToken: 'refresh-new',
        sessionId: 'sess-001',
        expiresAt: '2025-12-31T23:59:59Z',
      );
      final json = response.toJson();
      expect(json['accessToken'], 'access-new');
      expect(json['refreshToken'], 'refresh-new');
      expect(json['sessionId'], 'sess-001');
      expect(json['expiresAt'], '2025-12-31T23:59:59Z');
    });

    test('round-trip preserves values', () {
      const original = RefreshResponse(
        accessToken: 'a',
        refreshToken: 'r',
        sessionId: 's',
        expiresAt: 'e',
      );
      final restored = RefreshResponse.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('ReAuthRequest', () {
    test('fromJson creates instance', () {
      final json = {'password': 'secret'};
      final request = ReAuthRequest.fromJson(json);
      expect(request.password, 'secret');
    });

    test('toJson produces correct keys', () {
      const request = ReAuthRequest(password: 'secret');
      final json = request.toJson();
      expect(json['password'], 'secret');
    });

    test('round-trip preserves values', () {
      const original = ReAuthRequest(password: 'pw');
      final restored = ReAuthRequest.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('ReAuthResponse', () {
    test('fromJson creates instance', () {
      final json = {'token': 'reauth-tok', 'expiresAt': '2025-06-01T00:00:00Z'};
      final response = ReAuthResponse.fromJson(json);
      expect(response.token, 'reauth-tok');
      expect(response.expiresAt, '2025-06-01T00:00:00Z');
    });

    test('toJson produces correct keys', () {
      const response = ReAuthResponse(
        token: 'reauth-tok',
        expiresAt: '2025-06-01T00:00:00Z',
      );
      final json = response.toJson();
      expect(json['token'], 'reauth-tok');
      expect(json['expiresAt'], '2025-06-01T00:00:00Z');
    });

    test('round-trip preserves values', () {
      const original = ReAuthResponse(token: 't', expiresAt: 'e');
      final restored = ReAuthResponse.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('CreateAccountRequest', () {
    test('fromJson creates instance', () {
      final json = {'email': 'new@test.com', 'password': 'pass123'};
      final request = CreateAccountRequest.fromJson(json);
      expect(request.email, 'new@test.com');
      expect(request.password, 'pass123');
    });

    test('toJson produces correct keys', () {
      const request = CreateAccountRequest(
        email: 'new@test.com',
        password: 'pass123',
      );
      final json = request.toJson();
      expect(json['email'], 'new@test.com');
      expect(json['password'], 'pass123');
    });

    test('round-trip preserves values', () {
      const original = CreateAccountRequest(email: 'u@t.com', password: 'p');
      final restored = CreateAccountRequest.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('ForgotPasswordRequest', () {
    test('fromJson with email and tenantId', () {
      final json = {'email': 'forgot@test.com', 'tenantId': 'tenant-001'};
      final request = ForgotPasswordRequest.fromJson(json);
      expect(request.email, 'forgot@test.com');
      expect(request.tenantId, 'tenant-001');
    });

    test('fromJson with email only (tenantId optional)', () {
      final json = {'email': 'forgot@test.com'};
      final request = ForgotPasswordRequest.fromJson(json);
      expect(request.email, 'forgot@test.com');
      expect(request.tenantId, isNull);
    });

    test('toJson produces correct keys', () {
      const request = ForgotPasswordRequest(
        email: 'forgot@test.com',
        tenantId: 'tenant-001',
      );
      final json = request.toJson();
      expect(json['email'], 'forgot@test.com');
      expect(json['tenantId'], 'tenant-001');
    });

    test('round-trip preserves values', () {
      const original = ForgotPasswordRequest(email: 'e@t.com');
      final restored = ForgotPasswordRequest.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('ResetPasswordRequest', () {
    test('fromJson creates instance', () {
      final json = {'token': 'reset-tok', 'newPassword': 'newPass123'};
      final request = ResetPasswordRequest.fromJson(json);
      expect(request.token, 'reset-tok');
      expect(request.newPassword, 'newPass123');
    });

    test('toJson produces correct keys', () {
      const request = ResetPasswordRequest(
        token: 'reset-tok',
        newPassword: 'newPass123',
      );
      final json = request.toJson();
      expect(json['token'], 'reset-tok');
      expect(json['newPassword'], 'newPass123');
    });

    test('round-trip preserves values', () {
      const original = ResetPasswordRequest(token: 't', newPassword: 'p');
      final restored = ResetPasswordRequest.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('VerifyEmailRequest', () {
    test('fromJson creates instance', () {
      final json = {'email': 'verify@test.com', 'code': '123456'};
      final request = VerifyEmailRequest.fromJson(json);
      expect(request.email, 'verify@test.com');
      expect(request.code, '123456');
    });

    test('toJson produces correct keys', () {
      const request = VerifyEmailRequest(
        email: 'verify@test.com',
        code: '123456',
      );
      final json = request.toJson();
      expect(json['email'], 'verify@test.com');
      expect(json['code'], '123456');
    });

    test('round-trip preserves values', () {
      const original = VerifyEmailRequest(email: 'e', code: 'c');
      final restored = VerifyEmailRequest.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('ResendVerificationRequest', () {
    test('fromJson creates instance', () {
      final json = {'email': 'resend@test.com'};
      final request = ResendVerificationRequest.fromJson(json);
      expect(request.email, 'resend@test.com');
    });

    test('toJson produces correct keys', () {
      const request = ResendVerificationRequest(email: 'resend@test.com');
      final json = request.toJson();
      expect(json['email'], 'resend@test.com');
    });

    test('round-trip preserves values', () {
      const original = ResendVerificationRequest(email: 'e');
      final restored = ResendVerificationRequest.fromJson(original.toJson());
      expect(restored, original);
    });
  });
}
