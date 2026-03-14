// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

/// Application-wide constants.
class AppConstants {
  AppConstants._();

  // --- Network Timeouts ---
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  static const Duration uploadTimeout = Duration(seconds: 60);

  // --- Image Processing ---
  static const double imageAspectRatio = 16.0 / 9.0;
  static const int imageQuality = 85;
  static const int imageMaxWidth = 1920;
  static const int imageMaxHeight = 1080;

  // --- Logging ---
  static const int maxLogHistoryItems = 1000;
}
