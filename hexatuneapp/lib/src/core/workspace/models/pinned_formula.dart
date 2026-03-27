// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'pinned_formula.freezed.dart';
part 'pinned_formula.g.dart';

/// A formula that the user has pinned to their workspace for quick access.
@freezed
abstract class PinnedFormula with _$PinnedFormula {
  const factory PinnedFormula({required String id, required String name}) =
      _PinnedFormula;

  factory PinnedFormula.fromJson(Map<String, dynamic> json) =>
      _$PinnedFormulaFromJson(json);
}
