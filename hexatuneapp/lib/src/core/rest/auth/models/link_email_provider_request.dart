// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'link_email_provider_request.freezed.dart';
part 'link_email_provider_request.g.dart';

/// Request body for POST /api/v1/auth/providers/email/link.
@freezed
abstract class LinkEmailProviderRequest with _$LinkEmailProviderRequest {
  const factory LinkEmailProviderRequest({
    required String email,
    required String password,
  }) = _LinkEmailProviderRequest;

  factory LinkEmailProviderRequest.fromJson(Map<String, dynamic> json) =>
      _$LinkEmailProviderRequestFromJson(json);
}
