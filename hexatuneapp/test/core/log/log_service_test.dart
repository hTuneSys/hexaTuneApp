// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';

void main() {
  group('LogService', () {
    late LogService logService;

    setUp(() {
      logService = LogService();
      logService.init();
    });

    test('initializes talker instance', () {
      expect(logService.talker, isNotNull);
    });

    test('logs verbose messages', () {
      expect(
        () => logService.verbose('verbose msg', category: LogCategory.app),
        returnsNormally,
      );
    });

    test('logs debug messages', () {
      expect(
        () => logService.debug('debug msg', category: LogCategory.network),
        returnsNormally,
      );
    });

    test('logs info messages', () {
      expect(
        () => logService.info('info msg', category: LogCategory.auth),
        returnsNormally,
      );
    });

    test('logs warning messages with exception', () {
      expect(
        () => logService.warning(
          'warning msg',
          category: LogCategory.storage,
          exception: Exception('test warning'),
        ),
        returnsNormally,
      );
    });

    test('logs error messages with exception and stack trace', () {
      expect(
        () => logService.error(
          'error msg',
          category: LogCategory.network,
          exception: Exception('test error'),
          stackTrace: StackTrace.current,
        ),
        returnsNormally,
      );
    });

    test('logs critical messages', () {
      expect(
        () => logService.critical(
          'critical msg',
          category: LogCategory.bootstrap,
          exception: StateError('critical'),
        ),
        returnsNormally,
      );
    });

    test('devLog is a no-throw alias for debug', () {
      expect(
        () => logService.devLog('dev message', category: LogCategory.app),
        returnsNormally,
      );
    });

    test('logs without category', () {
      expect(() => logService.info('no category'), returnsNormally);
    });

    test('talker history captures logs in dev mode', () {
      logService.info('history test', category: LogCategory.app);
      final history = logService.talker.history;
      expect(history, isNotEmpty);
      expect(
        history.any((r) => r.message?.contains('history test') ?? false),
        isTrue,
      );
    });
  });

  group('LogService.maskToken', () {
    test('returns "null" for null input', () {
      expect(LogService.maskToken(null), equals('null'));
    });

    test('returns "***" for short tokens (<=16 chars)', () {
      expect(LogService.maskToken(''), equals('***'));
      expect(LogService.maskToken('abc'), equals('***'));
      expect(LogService.maskToken('1234567890123456'), equals('***'));
    });

    test('masks middle of long tokens', () {
      const token = '12345678_middle_section_87654321';
      final masked = LogService.maskToken(token);
      expect(masked, startsWith('12345678'));
      expect(masked, endsWith('87654321'));
      expect(masked, contains('…'));
      expect(masked.length, lessThan(token.length));
    });
  });

  group('LogCategory', () {
    test('all categories have unique names', () {
      final names = LogCategory.values.map((c) => c.name).toSet();
      expect(names.length, equals(LogCategory.values.length));
    });

    test('contains expected categories', () {
      expect(LogCategory.values, contains(LogCategory.app));
      expect(LogCategory.values, contains(LogCategory.network));
      expect(LogCategory.values, contains(LogCategory.auth));
      expect(LogCategory.values, contains(LogCategory.storage));
      expect(LogCategory.values, contains(LogCategory.notification));
      expect(LogCategory.values, contains(LogCategory.media));
      expect(LogCategory.values, contains(LogCategory.device));
      expect(LogCategory.values, contains(LogCategory.permission));
      expect(LogCategory.values, contains(LogCategory.router));
      expect(LogCategory.values, contains(LogCategory.bootstrap));
      expect(LogCategory.values, contains(LogCategory.ui));
    });
  });
}
