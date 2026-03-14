// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/auth/models/link_email_provider_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/link_google_provider_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/link_apple_provider_request.dart';
import 'package:hexatuneapp/src/core/rest/auth/models/provider_response.dart';

void main() {
  group('LinkEmailProviderRequest', () {
    test('fromJson creates instance', () {
      final json = {
        'email': 'user@example.com',
        'password': 'SecurePassword123!',
      };
      final request = LinkEmailProviderRequest.fromJson(json);
      expect(request.email, 'user@example.com');
      expect(request.password, 'SecurePassword123!');
    });

    test('toJson produces correct keys', () {
      const request = LinkEmailProviderRequest(
        email: 'test@test.com',
        password: 'pass123',
      );
      final json = request.toJson();
      expect(json['email'], 'test@test.com');
      expect(json['password'], 'pass123');
    });

    test('round-trip preserves values', () {
      const original = LinkEmailProviderRequest(email: 'e', password: 'p');
      final restored = LinkEmailProviderRequest.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('LinkGoogleProviderRequest', () {
    test('fromJson creates instance', () {
      final json = {'idToken': 'google-jwt-token'};
      final request = LinkGoogleProviderRequest.fromJson(json);
      expect(request.idToken, 'google-jwt-token');
    });

    test('toJson produces correct keys', () {
      const request = LinkGoogleProviderRequest(idToken: 'tok');
      final json = request.toJson();
      expect(json['idToken'], 'tok');
    });

    test('round-trip preserves values', () {
      const original = LinkGoogleProviderRequest(idToken: 'g');
      final restored = LinkGoogleProviderRequest.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('LinkAppleProviderRequest', () {
    test('fromJson creates instance', () {
      final json = {'idToken': 'apple-jwt-token'};
      final request = LinkAppleProviderRequest.fromJson(json);
      expect(request.idToken, 'apple-jwt-token');
    });

    test('toJson produces correct keys', () {
      const request = LinkAppleProviderRequest(idToken: 'tok');
      final json = request.toJson();
      expect(json['idToken'], 'tok');
    });

    test('round-trip preserves values', () {
      const original = LinkAppleProviderRequest(idToken: 'a');
      final restored = LinkAppleProviderRequest.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('ProviderResponse', () {
    test('fromJson with all fields', () {
      final json = {
        'providerType': 'google',
        'linkedAt': '2025-06-01T12:00:00Z',
        'email': 'user@gmail.com',
      };
      final response = ProviderResponse.fromJson(json);
      expect(response.providerType, 'google');
      expect(response.linkedAt, '2025-06-01T12:00:00Z');
      expect(response.email, 'user@gmail.com');
    });

    test('fromJson with optional email absent', () {
      final json = {
        'providerType': 'apple',
        'linkedAt': '2025-06-01T12:00:00Z',
      };
      final response = ProviderResponse.fromJson(json);
      expect(response.providerType, 'apple');
      expect(response.email, isNull);
    });

    test('toJson produces correct keys', () {
      const response = ProviderResponse(
        providerType: 'email',
        linkedAt: '2025-01-01T00:00:00Z',
        email: 'user@example.com',
      );
      final json = response.toJson();
      expect(json['providerType'], 'email');
      expect(json['linkedAt'], '2025-01-01T00:00:00Z');
      expect(json['email'], 'user@example.com');
    });

    test('round-trip preserves values', () {
      const original = ProviderResponse(providerType: 'google', linkedAt: 'l');
      final restored = ProviderResponse.fromJson(original.toJson());
      expect(restored, original);
    });
  });
}
