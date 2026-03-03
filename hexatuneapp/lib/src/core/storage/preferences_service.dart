// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Wrapper around [SharedPreferences] for non-sensitive user preferences
/// and application settings.
@singleton
class PreferencesService {
  late final SharedPreferences _prefs;

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- String ---

  Future<bool> setString(String key, String value) {
    return _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  // --- Bool ---

  Future<bool> setBool(String key, {required bool value}) {
    return _prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  // --- Int ---

  Future<bool> setInt(String key, int value) {
    return _prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  // --- Generic ---

  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  Future<bool> remove(String key) {
    return _prefs.remove(key);
  }

  Future<bool> clear() {
    return _prefs.clear();
  }
}
