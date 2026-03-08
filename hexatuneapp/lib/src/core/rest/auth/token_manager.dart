// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/rest/auth/paseto_parser.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/storage/secure_storage_service.dart';

/// Manages PASETO access and refresh tokens.
///
/// Access tokens are PASETO v4.public — their `exp` claim is parsed
/// client-side for proactive refresh before expiry.
/// The `expiresAt` field from login/refresh response refers to the
/// refresh token's expiry.
@singleton
class TokenManager {
  TokenManager(this._secureStorage, this._logService);

  final SecureStorageService _secureStorage;
  final LogService _logService;

  String? _cachedAccessToken;
  String? _cachedRefreshToken;
  String? _cachedSessionId;
  String? _cachedExpiresAt;

  /// Parsed from the PASETO access token's `exp` claim.
  DateTime? _accessExpiresAt;

  /// Parsed from the login/refresh response `expiresAt` field.
  DateTime? _refreshExpiresAt;

  /// Load tokens from secure storage into memory.
  Future<void> loadTokens() async {
    _cachedAccessToken = await _secureStorage.getAccessToken();
    _cachedRefreshToken = await _secureStorage.getRefreshToken();
    _cachedSessionId = await _secureStorage.getSessionId();
    _cachedExpiresAt = await _secureStorage.getExpiresAt();

    // Parse expiry timestamps.
    _parseAccessTokenExpiry();
    _parseRefreshTokenExpiry();

    _logService.debug(
      'Tokens loaded — access: ${_cachedAccessToken != null}, '
      'refresh: ${_cachedRefreshToken != null}, '
      'session: $_cachedSessionId',
      category: LogCategory.auth,
    );
    _logService.devLog(
      'Token details — '
      'access: ${LogService.maskToken(_cachedAccessToken)}, '
      'refresh: ${LogService.maskToken(_cachedRefreshToken)}, '
      'session: $_cachedSessionId, '
      'accessExp: $_accessExpiresAt, '
      'refreshExp: $_refreshExpiresAt',
      category: LogCategory.auth,
    );
  }

  /// Store tokens from a login or refresh response.
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    String? sessionId,
    String? expiresAt,
  }) async {
    _cachedAccessToken = accessToken;
    _cachedRefreshToken = refreshToken;
    await _secureStorage.saveAccessToken(accessToken);
    await _secureStorage.saveRefreshToken(refreshToken);

    if (sessionId != null) {
      _cachedSessionId = sessionId;
      await _secureStorage.saveSessionId(sessionId);
    }
    if (expiresAt != null) {
      _cachedExpiresAt = expiresAt;
      await _secureStorage.saveExpiresAt(expiresAt);
    }

    // Parse expiry timestamps from the new tokens.
    _parseAccessTokenExpiry();
    _parseRefreshTokenExpiry();

    _logService.debug('Tokens saved', category: LogCategory.auth);
    _logService.devLog(
      'Saved tokens — '
      'access: ${LogService.maskToken(accessToken)}, '
      'refresh: ${LogService.maskToken(refreshToken)}, '
      'session: $sessionId, '
      'accessExp: $_accessExpiresAt, '
      'refreshExp: $_refreshExpiresAt',
      category: LogCategory.auth,
    );
  }

  /// Clear all tokens (on logout or refresh failure).
  Future<void> clearTokens() async {
    _cachedAccessToken = null;
    _cachedRefreshToken = null;
    _cachedSessionId = null;
    _cachedExpiresAt = null;
    _accessExpiresAt = null;
    _refreshExpiresAt = null;
    await _secureStorage.clearTokens();
    _logService.debug('Tokens cleared', category: LogCategory.auth);
  }

  /// Current access token, or null if not logged in.
  String? get accessToken => _cachedAccessToken;

  /// Current refresh token, or null if not available.
  String? get refreshToken => _cachedRefreshToken;

  /// Current session ID from the last login/refresh.
  String? get sessionId => _cachedSessionId;

  /// Refresh token expiry timestamp string from the last login/refresh.
  String? get expiresAt => _cachedExpiresAt;

  /// Whether any access token is currently held.
  bool get hasToken => _cachedAccessToken != null;

  /// Whether the access token's PASETO `exp` claim has passed.
  ///
  /// Returns `false` if the expiry could not be parsed (falls back to
  /// server-side 401 detection).
  bool get isAccessTokenExpired {
    if (_accessExpiresAt == null) return false;
    return DateTime.now().toUtc().isAfter(_accessExpiresAt!);
  }

  /// Whether the refresh token's `expiresAt` from the login/refresh
  /// response has passed.
  ///
  /// Returns `false` if the expiry is unknown.
  bool get isRefreshTokenExpired {
    if (_refreshExpiresAt == null) return false;
    return DateTime.now().toUtc().isAfter(_refreshExpiresAt!);
  }

  /// Parsed access token expiry for external inspection.
  DateTime? get accessExpiresAt => _accessExpiresAt;

  /// Parsed refresh token expiry for external inspection.
  DateTime? get refreshExpiresAt => _refreshExpiresAt;

  void _parseAccessTokenExpiry() {
    if (_cachedAccessToken == null) {
      _accessExpiresAt = null;
      return;
    }
    _accessExpiresAt = PasetoParser.parseExpiry(_cachedAccessToken!);
  }

  void _parseRefreshTokenExpiry() {
    if (_cachedExpiresAt == null) {
      _refreshExpiresAt = null;
      return;
    }
    _refreshExpiresAt = DateTime.tryParse(_cachedExpiresAt!)?.toUtc();
  }
}
