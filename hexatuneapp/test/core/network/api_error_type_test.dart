// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/network/api_error_type.dart';

void main() {
  group('ApiErrorType', () {
    group('constants', () {
      test('all 18 constants are distinct', () {
        final all = [
          ApiErrorType.unauthorized,
          ApiErrorType.forbidden,
          ApiErrorType.notFound,
          ApiErrorType.badRequest,
          ApiErrorType.validationFailed,
          ApiErrorType.conflict,
          ApiErrorType.internalError,
          ApiErrorType.tooManyAttempts,
          ApiErrorType.accountLocked,
          ApiErrorType.accountSuspended,
          ApiErrorType.emailNotVerified,
          ApiErrorType.emailAlreadyExists,
          ApiErrorType.emailAlreadyVerified,
          ApiErrorType.providerAlreadyLinked,
          ApiErrorType.passwordResetTokenInvalid,
          ApiErrorType.passwordResetMaxAttempts,
          ApiErrorType.verificationTokenInvalid,
          ApiErrorType.verificationMaxAttempts,
        ];

        expect(all.toSet().length, 18);
      });

      test('constants use kebab-case', () {
        expect(ApiErrorType.emailNotVerified, 'email-not-verified');
        expect(ApiErrorType.tooManyAttempts, 'too-many-attempts');
        expect(
          ApiErrorType.passwordResetTokenInvalid,
          'password-reset-token-invalid',
        );
      });
    });

    group('normalize', () {
      test('returns short form from full URL', () {
        expect(
          ApiErrorType.normalize('https://api.hexatune.com/errors/not-found'),
          'not-found',
        );
      });

      test('returns short form from URL with trailing slash', () {
        expect(
          ApiErrorType.normalize(
            'https://api.hexatune.com/errors/email-not-verified',
          ),
          'email-not-verified',
        );
      });

      test('returns short string as-is', () {
        expect(ApiErrorType.normalize('not-found'), 'not-found');
        expect(
          ApiErrorType.normalize('email-not-verified'),
          'email-not-verified',
        );
      });

      test('handles URL with multiple path segments', () {
        expect(
          ApiErrorType.normalize('https://api.hexatune.com/v2/errors/conflict'),
          'conflict',
        );
      });

      test('handles simple scheme-less string', () {
        expect(ApiErrorType.normalize('bad-request'), 'bad-request');
      });
    });
  });
}
