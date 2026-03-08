// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_formula_request.freezed.dart';
part 'create_formula_request.g.dart';

/// Request model for creating a formula.
@freezed
abstract class CreateFormulaRequest with _$CreateFormulaRequest {
  const factory CreateFormulaRequest({
    required String name,
    List<String>? labels,
  }) = _CreateFormulaRequest;

  factory CreateFormulaRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateFormulaRequestFromJson(json);
}
