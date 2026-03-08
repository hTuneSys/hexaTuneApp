// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_response.freezed.dart';
part 'inventory_response.g.dart';

/// Response model for inventory endpoints.
@freezed
abstract class InventoryResponse with _$InventoryResponse {
  const factory InventoryResponse({
    required String id,
    required String categoryId,
    required String name,
    required List<String> labels,
    required bool imageUploaded,
    required String createdAt,
    required String updatedAt,
    String? description,
  }) = _InventoryResponse;

  factory InventoryResponse.fromJson(Map<String, dynamic> json) =>
      _$InventoryResponseFromJson(json);
}
