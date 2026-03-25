// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/storage/preferences_service.dart';

/// OTP flow types for timer key isolation.
enum OtpFlow { emailVerification, passwordReset, emailProviderLink }

/// Manages OTP expiry timestamps across app restarts using
/// [PreferencesService] for persistence.
@singleton
class OtpTimerService {
  OtpTimerService(this._preferences);

  final PreferencesService _preferences;

  static const _prefix = 'otp_expires_at';

  String _key(OtpFlow flow, String email) =>
      '${_prefix}_${flow.name}_${email.toLowerCase()}';

  /// Persist the absolute expiry timestamp for an OTP.
  Future<void> saveOtpExpiry(
    OtpFlow flow,
    String email,
    int expiresInSeconds,
  ) async {
    final expiresAt = DateTime.now()
        .add(Duration(seconds: expiresInSeconds))
        .toIso8601String();
    await _preferences.setString(_key(flow, email), expiresAt);
  }

  /// Calculate the remaining seconds before the OTP expires.
  /// Returns 0 if no expiry is stored or the OTP has already expired.
  int getRemainingSeconds(OtpFlow flow, String email) {
    final stored = _preferences.getString(_key(flow, email));
    if (stored == null) return 0;
    final expiresAt = DateTime.tryParse(stored);
    if (expiresAt == null) return 0;
    final remaining = expiresAt.difference(DateTime.now()).inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  /// Whether the OTP for the given flow/email has expired (or was never set).
  bool isExpired(OtpFlow flow, String email) =>
      getRemainingSeconds(flow, email) == 0;

  /// Remove the stored OTP expiry.
  Future<void> clearOtpExpiry(OtpFlow flow, String email) async {
    await _preferences.remove(_key(flow, email));
  }
}
