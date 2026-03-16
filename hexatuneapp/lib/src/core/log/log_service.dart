// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:injectable/injectable.dart';
import 'package:talker/talker.dart';

import 'package:hexatuneapp/src/core/config/env.dart';
import 'package:hexatuneapp/src/core/log/debug_log_buffer.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';

/// Application-wide logging service built on Talker.
///
/// **All logging is restricted to dev environment only.**
/// In non-dev builds (test, stage, prod) every log method is a no-op,
/// ensuring zero console output and zero processing overhead.
@singleton
class LogService {
  late final Talker _talker;

  /// Exposes the underlying Talker instance for integrations that require
  /// it (e.g. [TalkerDioLogger]). Console output is already disabled in
  /// non-dev environments via [TalkerSettings.useConsoleLogs].
  Talker get talker => _talker;

  /// Initialize the logging system.
  @PostConstruct()
  void init() {
    _talker = Talker(
      settings: TalkerSettings(
        useConsoleLogs: Env.isDev,
        useHistory: Env.isDev,
        maxHistoryItems: 1000,
      ),
    );
    info('LogService initialized', category: LogCategory.bootstrap);
  }

  /// Mask a token for safe console display: first 8 + last 8 characters.
  static String maskToken(String? token) {
    if (token == null) return 'null';
    if (token.length <= 16) return '***';
    return '${token.substring(0, 8)}…${token.substring(token.length - 8)}';
  }

  /// Alias for [debug] kept for backward compatibility.
  void devLog(String message, {LogCategory? category}) {
    _buffer('DEBUG', message, category: category);
    if (!Env.isDev) return;
    _talker.debug(_formatMessage(message, category: category));
  }

  String _formatMessage(String message, {LogCategory? category}) {
    if (category != null) {
      return '[${category.name.toUpperCase()}] $message';
    }
    return message;
  }

  void verbose(String message, {LogCategory? category}) {
    _buffer('VERBOSE', message, category: category);
    if (!Env.isDev) return;
    _talker.verbose(_formatMessage(message, category: category));
  }

  void debug(String message, {LogCategory? category}) {
    _buffer('DEBUG', message, category: category);
    if (!Env.isDev) return;
    _talker.debug(_formatMessage(message, category: category));
  }

  void info(String message, {LogCategory? category}) {
    _buffer('INFO', message, category: category);
    if (!Env.isDev) return;
    _talker.info(_formatMessage(message, category: category));
  }

  void warning(
    String message, {
    LogCategory? category,
    Object? exception,
    StackTrace? stackTrace,
  }) {
    _buffer('WARN', message, category: category, exception: exception);
    if (!Env.isDev) return;
    _talker.warning(
      _formatMessage(message, category: category),
      exception,
      stackTrace,
    );
  }

  void error(
    String message, {
    LogCategory? category,
    Object? exception,
    StackTrace? stackTrace,
  }) {
    _buffer('ERROR', message, category: category, exception: exception);
    if (!Env.isDev) return;
    _talker.error(
      _formatMessage(message, category: category),
      exception,
      stackTrace,
    );
  }

  void critical(
    String message, {
    LogCategory? category,
    Object? exception,
    StackTrace? stackTrace,
  }) {
    _buffer('CRITICAL', message, category: category, exception: exception);
    if (!Env.isDev) return;
    _talker.critical(
      _formatMessage(message, category: category),
      exception,
      stackTrace,
    );
  }

  void _buffer(
    String level,
    String message, {
    LogCategory? category,
    Object? exception,
  }) {
    final formatted = _formatMessage(message, category: category);
    final text = exception != null
        ? '$formatted\n  Exception: $exception'
        : formatted;
    DebugLogBuffer.instance.add(level, text);
  }
}
