// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:convert';

/// Parses PASETO v4.public token payloads without verifying signatures.
///
/// Signature verification is the backend's responsibility.
/// This parser extracts the JSON claims embedded in the token
/// for client-side expiry checks and metadata access.
class PasetoParser {
  PasetoParser._();

  static const _prefix = 'v4.public.';

  // Ed25519 signature length in bytes.
  static const _signatureLength = 64;

  /// Extract claims from a PASETO v4.public token.
  ///
  /// Returns null if the token format is invalid or unparseable.
  static Map<String, dynamic>? parseClaims(String token) {
    if (!token.startsWith(_prefix)) return null;

    final withoutPrefix = token.substring(_prefix.length);
    // Split on '.' to handle optional footer.
    final parts = withoutPrefix.split('.');
    final payloadStr = parts[0];

    try {
      final decoded = base64Url.decode(base64Url.normalize(payloadStr));
      if (decoded.length <= _signatureLength) return null;

      // Message is everything except the trailing 64-byte signature.
      final messageBytes =
          decoded.sublist(0, decoded.length - _signatureLength);
      final jsonStr = utf8.decode(messageBytes);
      return json.decode(jsonStr) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// Extract the expiry [DateTime] from a PASETO token's `exp` claim.
  ///
  /// Returns null if the token is invalid or has no `exp` claim.
  static DateTime? parseExpiry(String token) {
    final claims = parseClaims(token);
    if (claims == null) return null;
    final exp = claims['exp'] as String?;
    if (exp == null) return null;
    return DateTime.tryParse(exp);
  }
}
