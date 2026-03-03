// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_exception.dart';

void main() {
  group('LogCategory', () {
    test('all categories are unique', () {
      final names = LogCategory.values.map((e) => e.name).toSet();
      expect(names.length, equals(LogCategory.values.length));
    });
  });

  group('LogService', () {
    late LogService logService;

    setUp(() {
      logService = LogService();
      logService.init();
    });

    test('initializes successfully', () {
      expect(logService.talker, isNotNull);
    });

    test('logs info messages without error', () {
      expect(
        () => logService.info('Test message', category: LogCategory.app),
        returnsNormally,
      );
    });

    test('logs error messages without error', () {
      expect(
        () => logService.error(
          'Error message',
          category: LogCategory.network,
          exception: Exception('test'),
        ),
        returnsNormally,
      );
    });
  });

  group('ApiException', () {
    test('network exception has default message', () {
      const ex = ApiException.network();
      expect(ex.message, 'No network connection');
      expect(ex, isA<NetworkException>());
    });

    test('unauthorized exception has default message', () {
      const ex = ApiException.unauthorized();
      expect(ex.message, 'Authentication required');
      expect(ex, isA<UnauthorizedException>());
    });

    test('forbidden exception carries error code', () {
      const ex = ApiException.forbidden(errorCode: 'reauth_required');
      expect(ex, isA<ForbiddenException>());
      expect((ex as ForbiddenException).errorCode, 'reauth_required');
    });

    test('server exception carries status code', () {
      const ex = ApiException.server(statusCode: 503);
      expect(ex, isA<ServerException>());
      expect((ex as ServerException).statusCode, 503);
    });

    test('toString includes message', () {
      const ex = ApiException.timeout();
      expect(ex.toString(), contains('Request timed out'));
    });
  });
}
