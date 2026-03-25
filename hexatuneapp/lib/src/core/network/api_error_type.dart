// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

/// Constants for RFC 7807 error type URIs returned by the API.
///
/// Each constant matches the short-form `type` value from ProblemDetails
/// responses (e.g. `not-found`, `email-not-verified`).
abstract final class ApiErrorType {
  // ── Generic ──────────────────────────────────────────────────────────────
  static const unauthorized = 'unauthorized';
  static const forbidden = 'forbidden';
  static const notFound = 'not-found';
  static const badRequest = 'bad-request';
  static const validationFailed = 'validation-failed';
  static const conflict = 'conflict';
  static const internalError = 'internal-error';
  static const tooManyAttempts = 'too-many-attempts';

  // ── Auth / Account ───────────────────────────────────────────────────────
  static const accountLocked = 'account-locked';
  static const accountSuspended = 'account-suspended';
  static const emailNotVerified = 'email-not-verified';
  static const emailAlreadyExists = 'email-already-exists';
  static const emailAlreadyVerified = 'email-already-verified';
  static const providerAlreadyLinked = 'provider-already-linked';

  // ── Password Reset ───────────────────────────────────────────────────────
  static const passwordResetTokenInvalid = 'password-reset-token-invalid';
  static const passwordResetMaxAttempts = 'password-reset-max-attempts';

  // ── Email Verification ───────────────────────────────────────────────────
  static const verificationTokenInvalid = 'verification-token-invalid';
  static const verificationMaxAttempts = 'verification-max-attempts';

  /// Extracts the short-form error type from a raw `type` value.
  ///
  /// If the value is a full URL (e.g. `https://api.hexatune.com/errors/not-found`),
  /// returns the last path segment (`not-found`).
  /// If it's already a short string, returns it as-is.
  static String normalize(String rawType) {
    final uri = Uri.tryParse(rawType);
    if (uri != null && uri.hasScheme && uri.pathSegments.isNotEmpty) {
      return uri.pathSegments.last;
    }
    return rawType;
  }
}
