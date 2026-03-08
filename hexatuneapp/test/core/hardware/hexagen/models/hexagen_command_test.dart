// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/hardware/hexagen/models/hexagen_command.dart';

void main() {
  group('ATCommandType', () {
    test('has all expected values', () {
      expect(ATCommandType.values, hasLength(6));
      expect(ATCommandType.values, contains(ATCommandType.version));
      expect(ATCommandType.values, contains(ATCommandType.freq));
      expect(ATCommandType.values, contains(ATCommandType.setRgb));
      expect(ATCommandType.values, contains(ATCommandType.reset));
      expect(ATCommandType.values, contains(ATCommandType.fwUpdate));
      expect(ATCommandType.values, contains(ATCommandType.operation));
    });
  });

  group('CommandStatus', () {
    test('has all expected values', () {
      expect(CommandStatus.values, hasLength(4));
      expect(CommandStatus.values, contains(CommandStatus.pending));
      expect(CommandStatus.values, contains(CommandStatus.success));
      expect(CommandStatus.values, contains(CommandStatus.error));
      expect(CommandStatus.values, contains(CommandStatus.timeout));
    });
  });

  group('DeviceStatus', () {
    test('has all expected values', () {
      expect(DeviceStatus.values, hasLength(2));
      expect(DeviceStatus.values, contains(DeviceStatus.available));
      expect(DeviceStatus.values, contains(DeviceStatus.generating));
    });
  });

  group('SentCommand', () {
    test('creates with required fields', () {
      final now = DateTime.now();
      final cmd = SentCommand(1, 'AT+VERSION?', now, CommandStatus.pending);
      expect(cmd.id, 1);
      expect(cmd.command, 'AT+VERSION?');
      expect(cmd.sentAt, now);
      expect(cmd.status, CommandStatus.pending);
      expect(cmd.errorCode, isNull);
    });

    test('supports error code', () {
      final cmd = SentCommand(
        2,
        'AT+FREQ=2#440#1000',
        DateTime.now(),
        CommandStatus.error,
        errorCode: 'E001001',
      );
      expect(cmd.errorCode, 'E001001');
      expect(cmd.status, CommandStatus.error);
    });

    test('status is mutable for tracking updates', () {
      final cmd = SentCommand(
        1,
        'AT+RESET=1',
        DateTime.now(),
        CommandStatus.pending,
      );
      cmd.status = CommandStatus.success;
      expect(cmd.status, CommandStatus.success);
    });
  });
}
