// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/network/api_exception.dart';

void main() {
  group('ApiException', () {
    group('NetworkException', () {
      test('has default message', () {
        const ex = ApiException.network();
        expect(ex.message, 'No network connection');
        expect(ex, isA<NetworkException>());
      });

      test('accepts custom message', () {
        const ex = ApiException.network(message: 'WiFi disconnected');
        expect(ex.message, 'WiFi disconnected');
      });
    });

    group('TimeoutException', () {
      test('has default message', () {
        const ex = ApiException.timeout();
        expect(ex.message, 'Request timed out');
        expect(ex, isA<TimeoutException>());
      });
    });

    group('UnauthorizedException', () {
      test('has default message', () {
        const ex = ApiException.unauthorized();
        expect(ex.message, 'Authentication required');
        expect(ex, isA<UnauthorizedException>());
      });
    });

    group('ForbiddenException', () {
      test('has default message and null error code', () {
        const ex = ApiException.forbidden();
        expect(ex.message, 'Access denied');
        expect(ex, isA<ForbiddenException>());
        expect((ex as ForbiddenException).errorCode, isNull);
      });

      test('carries error code for reauth', () {
        const ex = ApiException.forbidden(errorCode: 'reauth_required');
        expect((ex as ForbiddenException).errorCode, 'reauth_required');
      });

      test('carries error code for device approval', () {
        const ex = ApiException.forbidden(
          errorCode: 'device_approval_required',
        );
        expect(
          (ex as ForbiddenException).errorCode,
          'device_approval_required',
        );
      });
    });

    group('ServerException', () {
      test('has default message', () {
        const ex = ApiException.server();
        expect(ex.message, 'Server error');
        expect(ex, isA<ServerException>());
        expect((ex as ServerException).statusCode, isNull);
      });

      test('carries status code', () {
        const ex = ApiException.server(statusCode: 503);
        expect((ex as ServerException).statusCode, 503);
      });
    });

    group('CancelledException', () {
      test('has default message', () {
        const ex = ApiException.cancelled();
        expect(ex.message, 'Request cancelled');
        expect(ex, isA<CancelledException>());
      });
    });

    group('BadRequestException', () {
      test('has default message', () {
        const ex = ApiException.badRequest();
        expect(ex.message, 'Bad request');
        expect(ex, isA<BadRequestException>());
        expect((ex as BadRequestException).errors, isNull);
      });

      test('carries validation errors', () {
        const ex = ApiException.badRequest(errors: {'email': 'invalid format'});
        expect((ex as BadRequestException).errors, {'email': 'invalid format'});
      });
    });

    group('NotFoundException', () {
      test('has default message', () {
        const ex = ApiException.notFound();
        expect(ex.message, 'Resource not found');
        expect(ex, isA<NotFoundException>());
      });
    });

    group('ConflictException', () {
      test('has default message', () {
        const ex = ApiException.conflict();
        expect(ex.message, 'Resource conflict');
        expect(ex, isA<ConflictException>());
      });
    });

    group('RateLimitedException', () {
      test('has default message', () {
        const ex = ApiException.rateLimited();
        expect(ex.message, 'Too many requests');
        expect(ex, isA<RateLimitedException>());
      });
    });

    group('UnknownApiException', () {
      test('has default message', () {
        const ex = ApiException.unknown();
        expect(ex.message, 'An unexpected error occurred');
        expect(ex, isA<UnknownApiException>());
        expect((ex as UnknownApiException).error, isNull);
      });

      test('carries original error', () {
        final original = StateError('boom');
        final ex = ApiException.unknown(error: original);
        expect((ex as UnknownApiException).error, original);
      });
    });

    group('toString', () {
      test('includes message', () {
        const ex = ApiException.timeout();
        expect(ex.toString(), 'ApiException: Request timed out');
      });
    });

    group('sealed class switch', () {
      test('allows exhaustive switch', () {
        const ApiException ex = ApiException.network();
        final result = switch (ex) {
          NetworkException() => 'network',
          TimeoutException() => 'timeout',
          UnauthorizedException() => 'unauthorized',
          ForbiddenException() => 'forbidden',
          ServerException() => 'server',
          CancelledException() => 'cancelled',
          BadRequestException() => 'badRequest',
          NotFoundException() => 'notFound',
          ConflictException() => 'conflict',
          RateLimitedException() => 'rateLimited',
          UnknownApiException() => 'unknown',
        };
        expect(result, 'network');
      });
    });
  });
}
