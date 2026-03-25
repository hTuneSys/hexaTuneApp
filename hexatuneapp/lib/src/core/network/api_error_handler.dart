// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/network/api_error_type.dart';
import 'package:hexatuneapp/src/core/network/api_exception.dart';
import 'package:hexatuneapp/src/core/router/route_names.dart';
import 'package:hexatuneapp/src/pages/shared/app_snack_bar.dart';

/// Centralized API error handler.
///
/// Maps [ApiException] error types to localized messages and performs
/// navigation for special cases (e.g. email-not-verified → OTP page).
abstract final class ApiErrorHandler {
  /// Handles an API error by showing a localized snackbar or navigating.
  ///
  /// Pass [email] when calling from login/reauth so that
  /// `email-not-verified` errors redirect to the OTP verification page.
  static void handle(BuildContext context, Object error, {String? email}) {
    final exception = _extractException(error);
    if (exception == null) {
      final l10n = AppLocalizations.of(context)!;
      AppSnackBar.error(context, message: l10n.errorUnknown);
      return;
    }

    // Special case: email not verified → navigate to OTP page.
    if (exception.errorType == ApiErrorType.emailNotVerified &&
        email != null &&
        email.isNotEmpty) {
      final l10n = AppLocalizations.of(context)!;
      AppSnackBar.info(context, message: l10n.errorEmailNotVerified);
      context.go(
        '${RouteNames.verifyEmail}?email=${Uri.encodeComponent(email)}',
      );
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final message = resolveMessage(l10n, exception);
    AppSnackBar.error(context, message: message);
  }

  /// Resolves a localized error message for the given [ApiException].
  ///
  /// Priority:
  /// 1. Match [ApiException.errorType] to a specific l10n key
  /// 2. Fall back to exception-subtype generic l10n message
  /// 3. Last resort: use [ApiException.message] (API detail text)
  static String resolveMessage(AppLocalizations l10n, ApiException e) {
    // 1. Try error type URI mapping.
    final typed = _mapErrorType(l10n, e.errorType);
    if (typed != null) return typed;

    // 2. Fall back to exception subtype.
    return _mapExceptionType(l10n, e);
  }

  // ── Private helpers ──────────────────────────────────────────────────────

  static ApiException? _extractException(Object error) {
    if (error is ApiException) return error;
    if (error is DioException && error.error is ApiException) {
      return error.error! as ApiException;
    }
    return null;
  }

  static String? _mapErrorType(AppLocalizations l10n, String? errorType) {
    if (errorType == null) return null;
    return switch (errorType) {
      ApiErrorType.unauthorized => l10n.errorUnauthorized,
      ApiErrorType.forbidden => l10n.errorForbidden,
      ApiErrorType.notFound => l10n.errorNotFound,
      ApiErrorType.badRequest => l10n.errorBadRequest,
      ApiErrorType.validationFailed => l10n.errorValidationFailed,
      ApiErrorType.conflict => l10n.errorConflict,
      ApiErrorType.internalError => l10n.errorInternalError,
      ApiErrorType.tooManyAttempts => l10n.errorTooManyAttempts,
      ApiErrorType.accountLocked => l10n.errorAccountLocked,
      ApiErrorType.accountSuspended => l10n.errorAccountSuspended,
      ApiErrorType.emailNotVerified => l10n.errorEmailNotVerified,
      ApiErrorType.emailAlreadyExists => l10n.errorEmailAlreadyExists,
      ApiErrorType.emailAlreadyVerified => l10n.errorEmailAlreadyVerified,
      ApiErrorType.providerAlreadyLinked => l10n.errorProviderAlreadyLinked,
      ApiErrorType.passwordResetTokenInvalid => l10n.errorPasswordResetInvalid,
      ApiErrorType.passwordResetMaxAttempts =>
        l10n.errorPasswordResetMaxAttempts,
      ApiErrorType.verificationTokenInvalid => l10n.errorVerificationInvalid,
      ApiErrorType.verificationMaxAttempts => l10n.errorVerificationMaxAttempts,
      _ => null,
    };
  }

  static String _mapExceptionType(AppLocalizations l10n, ApiException e) =>
      switch (e) {
        NetworkException() => l10n.errorNetwork,
        TimeoutException() => l10n.errorTimeout,
        UnauthorizedException() => l10n.errorUnauthorized,
        ForbiddenException() => l10n.errorForbidden,
        ServerException() => l10n.errorInternalError,
        BadRequestException() => l10n.errorBadRequest,
        NotFoundException() => l10n.errorNotFound,
        ConflictException() => l10n.errorConflict,
        RateLimitedException() => l10n.errorRateLimited,
        CancelledException() => e.message,
        UnknownApiException() => l10n.errorUnknown,
      };
}
