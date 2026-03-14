// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'package_response.freezed.dart';
part 'package_response.g.dart';

/// Response model for package endpoints.
@freezed
abstract class PackageResponse with _$PackageResponse {
  const factory PackageResponse({
    required String id,
    required String name,
    required String description,
    required List<String> labels,
    required bool imageUploaded,
    required String createdAt,
    required String updatedAt,
  }) = _PackageResponse;

  factory PackageResponse.fromJson(Map<String, dynamic> json) =>
      _$PackageResponseFromJson(json);
}
