// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'formula_response.freezed.dart';
part 'formula_response.g.dart';

/// Response model for formula endpoints.
@freezed
abstract class FormulaResponse with _$FormulaResponse {
  const factory FormulaResponse({
    required String id,
    required String name,
    required List<String> labels,
    required String createdAt,
    required String updatedAt,
  }) = _FormulaResponse;

  factory FormulaResponse.fromJson(Map<String, dynamic> json) =>
      _$FormulaResponseFromJson(json);
}
