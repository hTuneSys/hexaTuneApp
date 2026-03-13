// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/auth/models/login_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/login_response.dart';

void main() {
  group('LoginRequest', () {
    test('fromJson creates instance', () {
      final json = {
        'email': 'user@test.com',
        'password': 'pass123',
        'deviceId': 'dev-001',
      };
      final request = LoginRequest.fromJson(json);
      expect(request.email, 'user@test.com');
      expect(request.password, 'pass123');
      expect(request.deviceId, 'dev-001');
    });

    test('toJson uses correct keys', () {
      const request = LoginRequest(
        email: 'user@test.com',
        password: 'pass',
        deviceId: 'dev-001',
      );
      final json = request.toJson();
      expect(json['email'], 'user@test.com');
      expect(json['deviceId'], 'dev-001');
    });

    test('deviceId is optional', () {
      const request = LoginRequest(email: 'user@test.com', password: 'pass');
      expect(request.deviceId, isNull);
    });
  });

  group('LoginResponse', () {
    test('fromJson creates instance', () {
      final json = {
        'accessToken': 'access-tok',
        'refreshToken': 'ref-tok',
        'sessionId': 'sess-001',
        'accountId': 'acc-001',
        'expiresAt': '2025-12-31T23:59:59Z',
      };
      final response = LoginResponse.fromJson(json);
      expect(response.accessToken, 'access-tok');
      expect(response.refreshToken, 'ref-tok');
      expect(response.sessionId, 'sess-001');
      expect(response.accountId, 'acc-001');
      expect(response.expiresAt, '2025-12-31T23:59:59Z');
    });

    test('toJson produces correct keys', () {
      const response = LoginResponse(
        accessToken: 'access-tok',
        refreshToken: 'ref-tok',
        sessionId: 'sess-001',
        accountId: 'acc-001',
        expiresAt: '2025-12-31T23:59:59Z',
      );
      final json = response.toJson();
      expect(json['accessToken'], 'access-tok');
      expect(json['refreshToken'], 'ref-tok');
      expect(json['sessionId'], 'sess-001');
      expect(json['accountId'], 'acc-001');
      expect(json['expiresAt'], '2025-12-31T23:59:59Z');
    });
  });
}
