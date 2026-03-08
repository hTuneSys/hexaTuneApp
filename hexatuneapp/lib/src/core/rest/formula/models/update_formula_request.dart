// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_formula_request.freezed.dart';
part 'update_formula_request.g.dart';

/// Request model for updating a formula.
@freezed
abstract class UpdateFormulaRequest with _$UpdateFormulaRequest {
  const factory UpdateFormulaRequest({String? name, List<String>? labels}) =
      _UpdateFormulaRequest;

  factory UpdateFormulaRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateFormulaRequestFromJson(json);
}
