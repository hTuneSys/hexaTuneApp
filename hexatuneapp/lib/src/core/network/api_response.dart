// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

/// Generic wrapper for API call results.
///
/// Usage:
/// ```dart
/// final result = await someApiCall();
/// switch (result) {
///   case ApiSuccess(:final data):
///     // handle data
///   case ApiError(:final exception):
///     // handle error
/// }
/// ```
sealed class ApiResponse<T> {
  const ApiResponse();

  const factory ApiResponse.success(T data) = ApiSuccess<T>;

  const factory ApiResponse.error(String message, {Object? exception}) =
      ApiError<T>;
}

class ApiSuccess<T> extends ApiResponse<T> {
  const ApiSuccess(this.data);

  final T data;
}

class ApiError<T> extends ApiResponse<T> {
  const ApiError(this.message, {this.exception});

  final String message;
  final Object? exception;
}
