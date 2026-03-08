// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'link_apple_provider_request.freezed.dart';
part 'link_apple_provider_request.g.dart';

/// Request body for POST /api/v1/auth/providers/apple/link.
@freezed
abstract class LinkAppleProviderRequest with _$LinkAppleProviderRequest {
  const factory LinkAppleProviderRequest({required String idToken}) =
      _LinkAppleProviderRequest;

  factory LinkAppleProviderRequest.fromJson(Map<String, dynamic> json) =>
      _$LinkAppleProviderRequestFromJson(json);
}
