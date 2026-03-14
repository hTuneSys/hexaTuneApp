// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/hardware/hexagen/models/hexagen_command.dart';
import 'package:hexatuneapp/src/core/hardware/hexagen/proto/at_response.dart';

void main() {
  group('ATResponseType', () {
    test('has all expected values', () {
      expect(ATResponseType.values, hasLength(6));
    });
  });

  group('ATResponse', () {
    test('version getter returns first param', () {
      final resp = ATResponse(
        type: ATResponseType.version,
        id: '0',
        params: ['1.2.3'],
      );
      expect(resp.version, '1.2.3');
    });

    test('version getter returns empty for no params', () {
      final resp = ATResponse(
        type: ATResponseType.version,
        id: '0',
        params: [],
      );
      expect(resp.version, '');
    });

    test('errorCode getter returns first param', () {
      final resp = ATResponse(
        type: ATResponseType.error,
        id: '1',
        params: ['E001001'],
      );
      expect(resp.errorCode, 'E001001');
    });

    test('status getter parses AVAILABLE', () {
      final resp = ATResponse(
        type: ATResponseType.status,
        id: '0',
        params: ['AVAILABLE'],
      );
      expect(resp.status, DeviceStatus.available);
    });

    test('status getter defaults to generating', () {
      final resp = ATResponse(
        type: ATResponseType.status,
        id: '0',
        params: ['GENERATING'],
      );
      expect(resp.status, DeviceStatus.generating);
    });

    group('operationStatus', () {
      test('returns COMPLETED when second param is COMPLETED', () {
        final resp = ATResponse(
          type: ATResponseType.operation,
          id: '1',
          params: ['PREPARE', 'COMPLETED'],
        );
        expect(resp.operationStatus, 'COMPLETED');
      });

      test('returns first param when no COMPLETED', () {
        final resp = ATResponse(
          type: ATResponseType.operation,
          id: '1',
          params: ['GENERATING', '5'],
        );
        expect(resp.operationStatus, 'GENERATING');
      });

      test('returns empty for no params', () {
        final resp = ATResponse(
          type: ATResponseType.operation,
          id: '1',
          params: [],
        );
        expect(resp.operationStatus, '');
      });
    });

    group('operationStepId', () {
      test('parses step ID during GENERATING', () {
        final resp = ATResponse(
          type: ATResponseType.operation,
          id: '1',
          params: ['GENERATING', '42'],
        );
        expect(resp.operationStepId, 42);
      });

      test('returns null when not GENERATING', () {
        final resp = ATResponse(
          type: ATResponseType.operation,
          id: '1',
          params: ['PREPARE', 'COMPLETED'],
        );
        expect(resp.operationStepId, isNull);
      });
    });

    group('freqCompleted', () {
      test('returns true when third param is COMPLETED', () {
        final resp = ATResponse(
          type: ATResponseType.freq,
          id: '5',
          params: ['440', '1000', 'COMPLETED'],
        );
        expect(resp.freqCompleted, true);
      });

      test('returns false with insufficient params', () {
        final resp = ATResponse(
          type: ATResponseType.freq,
          id: '5',
          params: ['440'],
        );
        expect(resp.freqCompleted, false);
      });

      test('returns false for non-freq type', () {
        final resp = ATResponse(
          type: ATResponseType.done,
          id: '5',
          params: ['440', '1000', 'COMPLETED'],
        );
        expect(resp.freqCompleted, false);
      });
    });

    group('operationCompleted', () {
      test('returns true when COMPLETED in params', () {
        final resp = ATResponse(
          type: ATResponseType.operation,
          id: '1',
          params: ['GENERATE', 'COMPLETED'],
        );
        expect(resp.operationCompleted, true);
      });

      test('returns false when no COMPLETED', () {
        final resp = ATResponse(
          type: ATResponseType.operation,
          id: '1',
          params: ['GENERATING', '5'],
        );
        expect(resp.operationCompleted, false);
      });
    });
  });
}
