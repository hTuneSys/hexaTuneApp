// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/hardware/hexagen/models/hexagen_device_error.dart';

void main() {
  group('HexagenDeviceError', () {
    test('has all 10 error codes', () {
      expect(HexagenDeviceError.values, hasLength(10));
    });

    test('each error has a unique code', () {
      final codes = HexagenDeviceError.values.map((e) => e.code).toSet();
      expect(codes, hasLength(10));
    });

    test('error codes follow E001xxx format', () {
      for (final error in HexagenDeviceError.values) {
        expect(error.code, matches(RegExp(r'^E001\d{3}$')));
      }
    });

    test('specific code mappings are correct', () {
      expect(HexagenDeviceError.invalidCommand.code, 'E001001');
      expect(HexagenDeviceError.ddsBusy.code, 'E001002');
      expect(HexagenDeviceError.invalidUtf8.code, 'E001003');
      expect(HexagenDeviceError.invalidSysEx.code, 'E001004');
      expect(HexagenDeviceError.invalidDataLength.code, 'E001005');
      expect(HexagenDeviceError.paramCount.code, 'E001006');
      expect(HexagenDeviceError.paramValue.code, 'E001007');
      expect(HexagenDeviceError.notAQuery.code, 'E001008');
      expect(HexagenDeviceError.unknownCommand.code, 'E001009');
      expect(HexagenDeviceError.operationStepsFull.code, 'E001010');
    });

    group('fromCode', () {
      test('resolves known codes', () {
        expect(
          HexagenDeviceError.fromCode('E001001'),
          HexagenDeviceError.invalidCommand,
        );
        expect(
          HexagenDeviceError.fromCode('E001010'),
          HexagenDeviceError.operationStepsFull,
        );
      });

      test('returns null for unknown code', () {
        expect(HexagenDeviceError.fromCode('E999999'), isNull);
      });

      test('returns null for null input', () {
        expect(HexagenDeviceError.fromCode(null), isNull);
      });

      test('returns null for empty string', () {
        expect(HexagenDeviceError.fromCode(''), isNull);
      });
    });
  });
}
