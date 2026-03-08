// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/hardware/hexagen/models/hexagen_command.dart';
import 'package:hexatuneapp/src/core/hardware/hexagen/proto/at_command.dart';

void main() {
  group('ATCommand', () {
    group('compile', () {
      test('version query compiles to AT+VERSION?', () {
        final cmd = ATCommand.version();
        expect(cmd.compile(), 'AT+VERSION?');
        expect(cmd.isQuery, true);
        expect(cmd.id, 0);
        expect(cmd.type, ATCommandType.version);
      });

      test('operation query compiles to AT+OPERATION?', () {
        final cmd = ATCommand.operationQuery();
        expect(cmd.compile(), 'AT+OPERATION?');
      });

      test('operation prepare compiles correctly', () {
        final cmd = ATCommand.operationPrepare(42);
        expect(cmd.compile(), 'AT+OPERATION=42#PREPARE');
        expect(cmd.id, 42);
      });

      test('operation generate compiles correctly', () {
        final cmd = ATCommand.operationGenerate(7);
        expect(cmd.compile(), 'AT+OPERATION=7#GENERATE');
      });

      test('freq command compiles with parameters', () {
        final cmd = ATCommand.freq(5, 440, 1000);
        expect(cmd.compile(), 'AT+FREQ=5#440#1000');
        expect(cmd.id, 5);
        expect(cmd.type, ATCommandType.freq);
      });

      test('setRgb command compiles with r, g, b', () {
        final cmd = ATCommand.setRgb(3, 255, 128, 0);
        expect(cmd.compile(), 'AT+SETRGB=3#255#128#0');
      });

      test('reset command compiles without params', () {
        final cmd = ATCommand.reset(10);
        expect(cmd.compile(), 'AT+RESET=10');
        expect(cmd.params, isEmpty);
      });

      test('fwUpdate command compiles without params', () {
        final cmd = ATCommand.fwUpdate(1);
        expect(cmd.compile(), 'AT+FWUPDATE=1');
      });
    });

    group('factory constructors', () {
      test('version creates query with id 0', () {
        final cmd = ATCommand.version();
        expect(cmd.id, 0);
        expect(cmd.isQuery, true);
        expect(cmd.params, isEmpty);
      });

      test('freq stores parameters as strings', () {
        final cmd = ATCommand.freq(1, 880, 2000);
        expect(cmd.params, ['880', '2000']);
      });

      test('setRgb stores RGB as string parameters', () {
        final cmd = ATCommand.setRgb(1, 0, 0, 0);
        expect(cmd.params, ['0', '0', '0']);
      });
    });
  });
}
