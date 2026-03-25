// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

/// Typed API exception hierarchy.
///
/// Each variant carries a user-facing [message] and, where applicable,
/// the HTTP [statusCode], underlying [error], or backend [traceId].
sealed class ApiException implements Exception {
  const ApiException({required this.message, this.errorType, this.traceId});

  final String message;

  /// RFC 7807 error type URI from ProblemDetails (e.g. `not-found`).
  final String? errorType;

  /// Backend trace ID from RFC 7807 ProblemDetails, if available.
  final String? traceId;

  /// No network connection.
  const factory ApiException.network({
    String message,
    String? errorType,
    String? traceId,
  }) = NetworkException;

  /// Request timed out.
  const factory ApiException.timeout({
    String message,
    String? errorType,
    String? traceId,
  }) = TimeoutException;

  /// Authentication required (HTTP 401).
  const factory ApiException.unauthorized({
    String message,
    String? errorType,
    String? traceId,
  }) = UnauthorizedException;

  /// Access denied or special action required (HTTP 403).
  const factory ApiException.forbidden({
    String message,
    String? errorCode,
    String? errorType,
    String? traceId,
  }) = ForbiddenException;

  /// Server error (HTTP 5xx).
  const factory ApiException.server({
    String message,
    int? statusCode,
    String? errorType,
    String? traceId,
  }) = ServerException;

  /// Request cancelled by the caller.
  const factory ApiException.cancelled({
    String message,
    String? errorType,
    String? traceId,
  }) = CancelledException;

  /// Bad request with validation errors (HTTP 400/422).
  const factory ApiException.badRequest({
    String message,
    Map<String, dynamic>? errors,
    String? errorType,
    String? traceId,
  }) = BadRequestException;

  /// Resource not found (HTTP 404).
  const factory ApiException.notFound({
    String message,
    String? errorType,
    String? traceId,
  }) = NotFoundException;

  /// Resource conflict (HTTP 409).
  const factory ApiException.conflict({
    String message,
    String? errorType,
    String? traceId,
  }) = ConflictException;

  /// Rate limited (HTTP 429).
  const factory ApiException.rateLimited({
    String message,
    String? errorType,
    String? traceId,
  }) = RateLimitedException;

  /// Catch-all for unmapped errors.
  const factory ApiException.unknown({
    String message,
    Object? error,
    String? errorType,
    String? traceId,
  }) = UnknownApiException;

  @override
  String toString() => 'ApiException: $message';
}

class NetworkException extends ApiException {
  const NetworkException({
    super.message = 'No network connection',
    super.errorType,
    super.traceId,
  });
}

class TimeoutException extends ApiException {
  const TimeoutException({
    super.message = 'Request timed out',
    super.errorType,
    super.traceId,
  });
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException({
    super.message = 'Authentication required',
    super.errorType,
    super.traceId,
  });
}

class ForbiddenException extends ApiException {
  const ForbiddenException({
    super.message = 'Access denied',
    this.errorCode,
    super.errorType,
    super.traceId,
  });

  /// Backend-specific error code (e.g. "reauth_required",
  /// "device_approval_required").
  final String? errorCode;
}

class ServerException extends ApiException {
  const ServerException({
    super.message = 'Server error',
    this.statusCode,
    super.errorType,
    super.traceId,
  });

  final int? statusCode;
}

class CancelledException extends ApiException {
  const CancelledException({
    super.message = 'Request cancelled',
    super.errorType,
    super.traceId,
  });
}

class BadRequestException extends ApiException {
  const BadRequestException({
    super.message = 'Bad request',
    this.errors,
    super.errorType,
    super.traceId,
  });

  final Map<String, dynamic>? errors;
}

class NotFoundException extends ApiException {
  const NotFoundException({
    super.message = 'Resource not found',
    super.errorType,
    super.traceId,
  });
}

class ConflictException extends ApiException {
  const ConflictException({
    super.message = 'Resource conflict',
    super.errorType,
    super.traceId,
  });
}

class RateLimitedException extends ApiException {
  const RateLimitedException({
    super.message = 'Too many requests',
    super.errorType,
    super.traceId,
  });
}

class UnknownApiException extends ApiException {
  const UnknownApiException({
    super.message = 'An unexpected error occurred',
    this.error,
    super.errorType,
    super.traceId,
  });

  final Object? error;
}
