// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'problem_details.freezed.dart';
part 'problem_details.g.dart';

/// RFC 7807 Problem Details error response from the API.
@freezed
abstract class ProblemDetails with _$ProblemDetails {
  const factory ProblemDetails({
    required String type,
    required String title,
    required int status,
    required String detail,
    @JsonKey(name: 'trace_id') String? traceId,
  }) = _ProblemDetails;

  factory ProblemDetails.fromJson(Map<String, dynamic> json) =>
      _$ProblemDetailsFromJson(json);
}
