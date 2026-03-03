// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:injectable/injectable.dart';
import 'package:talker/talker.dart';

import 'package:hexatuneapp/src/core/log/log_category.dart';

/// Application-wide logging service built on Talker.
@singleton
class LogService {
  late final Talker _talker;

  Talker get talker => _talker;

  /// Initialize the logging system.
  @PostConstruct()
  void init() {
    _talker = Talker(
      settings: TalkerSettings(
        useConsoleLogs: true,
        useHistory: true,
        maxHistoryItems: 1000,
      ),
    );
    info('LogService initialized', category: LogCategory.bootstrap);
  }

  String _formatMessage(String message, {LogCategory? category}) {
    if (category != null) {
      return '[${category.name.toUpperCase()}] $message';
    }
    return message;
  }

  void verbose(String message, {LogCategory? category}) {
    _talker.verbose(_formatMessage(message, category: category));
  }

  void debug(String message, {LogCategory? category}) {
    _talker.debug(_formatMessage(message, category: category));
  }

  void info(String message, {LogCategory? category}) {
    _talker.info(_formatMessage(message, category: category));
  }

  void warning(
    String message, {
    LogCategory? category,
    Object? exception,
    StackTrace? stackTrace,
  }) {
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
    _talker.critical(
      _formatMessage(message, category: category),
      exception,
      stackTrace,
    );
  }
}
