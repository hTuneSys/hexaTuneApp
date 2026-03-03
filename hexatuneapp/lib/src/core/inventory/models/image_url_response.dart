// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_url_response.freezed.dart';
part 'image_url_response.g.dart';

/// Response model for GET /api/v1/inventories/{id}/image.
@freezed
abstract class ImageUrlResponse with _$ImageUrlResponse {
  const factory ImageUrlResponse({
    required String url,
  }) = _ImageUrlResponse;

  factory ImageUrlResponse.fromJson(Map<String, dynamic> json) =>
      _$ImageUrlResponseFromJson(json);
}
