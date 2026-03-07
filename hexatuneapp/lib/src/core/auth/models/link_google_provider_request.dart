// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'link_google_provider_request.freezed.dart';
part 'link_google_provider_request.g.dart';

/// Request body for POST /api/v1/auth/providers/google/link.
@freezed
abstract class LinkGoogleProviderRequest with _$LinkGoogleProviderRequest {
  const factory LinkGoogleProviderRequest({required String idToken}) =
      _LinkGoogleProviderRequest;

  factory LinkGoogleProviderRequest.fromJson(Map<String, dynamic> json) =>
      _$LinkGoogleProviderRequestFromJson(json);
}
