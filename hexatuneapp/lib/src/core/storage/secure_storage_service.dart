// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

/// Wrapper around [FlutterSecureStorage] for sensitive data
/// such as auth tokens and device identifiers.
@singleton
class SecureStorageService {
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
  }

  Future<String?> getAccessToken() async {
    return _storage.read(key: _keyAccessToken);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _keyRefreshToken, value: token);
  }

  Future<String?> getRefreshToken() async {
    return _storage.read(key: _keyRefreshToken);
  }

  Future<void> saveSessionId(String sessionId) async {
    await _storage.write(key: _keySessionId, value: sessionId);
  }

  Future<String?> getSessionId() async {
    return _storage.read(key: _keySessionId);
  }

  Future<void> saveExpiresAt(String expiresAt) async {
    await _storage.write(key: _keyExpiresAt, value: expiresAt);
  }

  Future<String?> getExpiresAt() async {
    return _storage.read(key: _keyExpiresAt);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyRefreshToken);
    await _storage.delete(key: _keySessionId);
    await _storage.delete(key: _keyExpiresAt);
  }

  // --- Device ID ---

  Future<void> saveDeviceId(String deviceId) async {
    await _storage.write(key: _keyDeviceId, value: deviceId);
  }

  Future<String?> getDeviceId() async {
    return _storage.read(key: _keyDeviceId);
  }

  // --- Generic ---

  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return _storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
