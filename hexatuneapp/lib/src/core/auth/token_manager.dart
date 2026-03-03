// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/storage/secure_storage_service.dart';

/// Manages PASETO access and refresh tokens.
///
/// Tokens are stored as opaque strings in [SecureStorageService].
/// The backend is responsible for validation and claims.
@singleton
class TokenManager {
  TokenManager(this._secureStorage, this._logService);

  final SecureStorageService _secureStorage;
  final LogService _logService;

  String? _cachedAccessToken;
  String? _cachedRefreshToken;
  String? _cachedSessionId;
  String? _cachedExpiresAt;

  /// Load tokens from secure storage into memory.
  Future<void> loadTokens() async {
    _cachedAccessToken = await _secureStorage.getAccessToken();
    _cachedRefreshToken = await _secureStorage.getRefreshToken();
    _cachedSessionId = await _secureStorage.getSessionId();
    _cachedExpiresAt = await _secureStorage.getExpiresAt();
    _logService.debug(
      'Tokens loaded — access: ${_cachedAccessToken != null}, '
      'refresh: ${_cachedRefreshToken != null}, '
      'session: $_cachedSessionId',
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

    _logService.debug('Tokens saved', category: LogCategory.auth);
  }

  /// Clear all tokens (on logout or refresh failure).
  Future<void> clearTokens() async {
    _cachedAccessToken = null;
    _cachedRefreshToken = null;
    _cachedSessionId = null;
    _cachedExpiresAt = null;
    await _secureStorage.clearTokens();
    _logService.debug('Tokens cleared', category: LogCategory.auth);
  }

  /// Current access token, or null if not logged in.
  String? get accessToken => _cachedAccessToken;

  /// Current refresh token, or null if not available.
  String? get refreshToken => _cachedRefreshToken;

  /// Current session ID from the last login/refresh.
  String? get sessionId => _cachedSessionId;

  /// Token expiry timestamp string from the last login/refresh.
  String? get expiresAt => _cachedExpiresAt;

  /// Whether any access token is currently held.
  bool get hasToken => _cachedAccessToken != null;
}
