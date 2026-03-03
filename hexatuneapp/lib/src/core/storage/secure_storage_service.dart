// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/config/env.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';

/// Wrapper around [FlutterSecureStorage] for sensitive data
/// such as auth tokens and device identifiers.
@singleton
class SecureStorageService {
  SecureStorageService(this._logService);

  final LogService _logService;

  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keySessionId = 'session_id';
  static const _keyExpiresAt = 'expires_at';
  static const _keyDeviceId = 'device_id';

  late final FlutterSecureStorage _storage;

  @PostConstruct()
  void init() {
    _storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    );
  }

  // --- Auth Tokens ---

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _keyAccessToken, value: token);
    _devLogWrite(_keyAccessToken, token.length);
  }

  Future<String?> getAccessToken() async {
    final value = await _storage.read(key: _keyAccessToken);
    _devLogRead(_keyAccessToken, value != null);
    return value;
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _keyRefreshToken, value: token);
    _devLogWrite(_keyRefreshToken, token.length);
  }

  Future<String?> getRefreshToken() async {
    final value = await _storage.read(key: _keyRefreshToken);
    _devLogRead(_keyRefreshToken, value != null);
    return value;
  }

  Future<void> saveSessionId(String sessionId) async {
    await _storage.write(key: _keySessionId, value: sessionId);
    _devLogWrite(_keySessionId, sessionId.length);
  }

  Future<String?> getSessionId() async {
    final value = await _storage.read(key: _keySessionId);
    _devLogRead(_keySessionId, value != null);
    return value;
  }

  Future<void> saveExpiresAt(String expiresAt) async {
    await _storage.write(key: _keyExpiresAt, value: expiresAt);
    _devLogWrite(_keyExpiresAt, expiresAt.length);
  }

  Future<String?> getExpiresAt() async {
    final value = await _storage.read(key: _keyExpiresAt);
    _devLogRead(_keyExpiresAt, value != null);
    return value;
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyRefreshToken);
    await _storage.delete(key: _keySessionId);
    await _storage.delete(key: _keyExpiresAt);
    if (Env.isDev) {
      _logService.devLog(
        '🗑 Storage: cleared all auth tokens',
        category: LogCategory.storage,
      );
    }
  }

  // --- Device ID ---

  Future<void> saveDeviceId(String deviceId) async {
    await _storage.write(key: _keyDeviceId, value: deviceId);
    _devLogWrite(_keyDeviceId, deviceId.length);
  }

  Future<String?> getDeviceId() async {
    final value = await _storage.read(key: _keyDeviceId);
    _devLogRead(_keyDeviceId, value != null);
    return value;
  }

  // --- Generic ---

  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
    _devLogWrite(key, value.length);
  }

  Future<String?> read(String key) async {
    final value = await _storage.read(key: key);
    _devLogRead(key, value != null);
    return value;
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
    if (Env.isDev) {
      _logService.devLog(
        '🗑 Storage: deleted key=$key',
        category: LogCategory.storage,
      );
    }
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
    if (Env.isDev) {
      _logService.devLog(
        '🗑 Storage: cleared ALL data',
        category: LogCategory.storage,
      );
    }
  }

  void _devLogWrite(String key, int valueLength) {
    if (Env.isDev) {
      _logService.devLog(
        '💾 Storage: write key=$key, valueLength=$valueLength',
        category: LogCategory.storage,
      );
    }
  }

  void _devLogRead(String key, bool found) {
    if (Env.isDev) {
      _logService.devLog(
        '📖 Storage: read key=$key, found=$found',
        category: LogCategory.storage,
      );
    }
  }
}
