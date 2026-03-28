// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'generate_harmonics_request.freezed.dart';
part 'generate_harmonics_request.g.dart';

/// Request model for generating a harmonic packet sequence.
@freezed
abstract class GenerateHarmonicsRequest with _$GenerateHarmonicsRequest {
  const factory GenerateHarmonicsRequest({
    /// The generation type (Monaural, Binaural, Magnetic, Photonic, Quantal).
    required String generationType,

    /// The source type (Flow, Formula, Inventory).
    required String sourceType,

    /// The source identifier. For Formula/Flow this is the formula/flow ID.
    /// For Inventory this is a client-generated tracking UUID.
    required String sourceId,

    /// Optional list of inventory IDs. Required when sourceType is Inventory.
    /// Maximum 10 items; duplicates are deduplicated server-side.
    List<String>? inventoryIds,
  }) = _GenerateHarmonicsRequest;

  factory GenerateHarmonicsRequest.fromJson(Map<String, dynamic> json) =>
      _$GenerateHarmonicsRequestFromJson(json);
}
