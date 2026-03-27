// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:freezed_annotation/freezed_annotation.dart';

part 'provider_response.freezed.dart';
part 'provider_response.g.dart';

/// Response item from GET /api/v1/accounts/me/providers.
@freezed
abstract class ProviderResponse with _$ProviderResponse {
  const factory ProviderResponse({
    required String providerType,
    required String linkedAt,
    String? email,
    bool? emailVerified,
  }) = _ProviderResponse;

  factory ProviderResponse.fromJson(Map<String, dynamic> json) =>
      _$ProviderResponseFromJson(json);
}
