// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/auth/oauth_service.dart';

void main() {
  group('OAuthService exception types', () {
    test('OAuthCancelledException contains message', () {
      const exception = OAuthCancelledException('User cancelled');
      expect(exception.message, 'User cancelled');
      expect(exception.toString(), contains('OAuthCancelledException'));
      expect(exception.toString(), contains('User cancelled'));
    });

    test('OAuthException contains message', () {
      const exception = OAuthException('Token missing');
      expect(exception.message, 'Token missing');
      expect(exception.toString(), contains('OAuthException'));
      expect(exception.toString(), contains('Token missing'));
    });

    test('OAuthNotAvailableException contains message', () {
      const exception = OAuthNotAvailableException('iOS only');
      expect(exception.message, 'iOS only');
      expect(exception.toString(), contains('OAuthNotAvailableException'));
      expect(exception.toString(), contains('iOS only'));
    });

    test('OAuthCancelledException is an Exception', () {
      const exception = OAuthCancelledException('cancelled');
      expect(exception, isA<Exception>());
    });

    test('OAuthException is an Exception', () {
      const exception = OAuthException('error');
      expect(exception, isA<Exception>());
    });

    test('OAuthNotAvailableException is an Exception', () {
      const exception = OAuthNotAvailableException('unavailable');
      expect(exception, isA<Exception>());
    });
  });

  // NOTE: Full integration tests of OAuthService.signInWithGoogle() and
  // signInWithApple() require platform channels (GoogleSignIn, SignInWithApple)
  // which are not available in the Flutter test environment.
  // These flows are verified via on-device testing.
}
