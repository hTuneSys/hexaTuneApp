// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/config/env.dart';

void main() {
  group('Env', () {
    test('environment defaults to dev', () {
      expect(Env.environment, isNotEmpty);
    });

    test('isDev returns true when environment is dev', () {
      // Compile-time const defaults to 'dev' when no dart-define is provided
      expect(Env.isDev, isTrue);
    });

    test('isTest returns false in default mode', () {
      expect(Env.isTest, isFalse);
    });

    test('isStage returns false in default mode', () {
      expect(Env.isStage, isFalse);
    });

    test('isProd returns false in default mode', () {
      expect(Env.isProd, isFalse);
    });

    test('apiBaseUrl has a default value', () {
      expect(Env.apiBaseUrl, isA<String>());
    });

    test('googleOAuthServerClientId has a default value', () {
      expect(Env.googleOAuthServerClientId, isA<String>());
    });

    test('appleSignInServiceId has a default value', () {
      expect(Env.appleSignInServiceId, isA<String>());
    });

    test('appleSignInRedirectUrl has a default value', () {
      expect(Env.appleSignInRedirectUrl, isA<String>());
    });
  });
}
