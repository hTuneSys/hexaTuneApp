// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

/// In-memory log entry for debug monitoring.
class DebugLogEntry {
  DebugLogEntry({
    required this.timestamp,
    required this.level,
    required this.message,
  });

  final DateTime timestamp;
  final String level;
  final String message;

  String get formatted {
    final ts = timestamp.toIso8601String().substring(11, 23);
    return '[$ts] [$level] $message';
  }
}

/// Global in-memory log buffer that captures entries regardless of
/// environment. Designed for temporary debug monitoring during testing.
///
/// This is a plain singleton — not part of DI — so it is available
/// before and after the service locator is configured.
class DebugLogBuffer {
  DebugLogBuffer._();

  static final DebugLogBuffer instance = DebugLogBuffer._();

  final List<DebugLogEntry> _entries = [];
  final _controller = StreamController<DebugLogEntry>.broadcast();

  /// All captured entries since app launch (or last clear).
  List<DebugLogEntry> get entries => List.unmodifiable(_entries);

  /// Stream of new entries as they arrive.
  Stream<DebugLogEntry> get stream => _controller.stream;

  /// Number of stored entries.
  int get length => _entries.length;

  /// Add a log entry to the buffer.
  void add(String level, String message) {
    final entry = DebugLogEntry(
      timestamp: DateTime.now(),
      level: level,
      message: message,
    );
    _entries.add(entry);
    if (!_controller.isClosed) {
      _controller.add(entry);
    }
  }

  /// Remove all stored entries.
  void clear() {
    _entries.clear();
  }

  /// All entries as a single copyable string.
  String toClipboardText() {
    return _entries.map((e) => e.formatted).join('\n');
  }

  /// Release resources. Only call on app shutdown.
  void dispose() {
    _controller.close();
    _entries.clear();
  }
}
