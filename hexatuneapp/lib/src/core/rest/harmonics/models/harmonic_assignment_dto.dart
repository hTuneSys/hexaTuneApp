// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'harmonic_assignment_dto.freezed.dart';
part 'harmonic_assignment_dto.g.dart';

/// A single harmonic assignment in the generation response.
@freezed
abstract class HarmonicAssignmentDto with _$HarmonicAssignmentDto {
  const factory HarmonicAssignmentDto({
    required String inventoryId,
    required int harmonicNumber,
    required String assignedAt,
  }) = _HarmonicAssignmentDto;

  factory HarmonicAssignmentDto.fromJson(Map<String, dynamic> json) =>
      _$HarmonicAssignmentDtoFromJson(json);
}
