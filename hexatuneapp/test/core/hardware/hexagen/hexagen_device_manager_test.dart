// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/hardware/hexagen/hexagen_device_manager.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/proto/proto_service.dart';

class MockLogService extends Mock implements LogService {}

class MockProtoService extends Mock implements ProtoService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HexagenDeviceManager', () {
    late MockLogService mockLog;
    late MockProtoService mockProto;
    late HexagenDeviceManager manager;

    setUp(() {
      mockLog = MockLogService();
      mockProto = MockProtoService();
      manager = HexagenDeviceManager(mockLog, mockProto);
    });

    tearDown(() {
      manager.dispose();
    });

    test('can be instantiated', () {
      expect(manager, isNotNull);
    });

    test('connectedId is initially null', () {
      expect(manager.connectedId, isNull);
    });

    test('clearConnection sets connectedId to null', () {
      manager.clearConnection();
      expect(manager.connectedId, isNull);
    });

    test('dispose can be called without error', () {
      expect(() => manager.dispose(), returnsNormally);
    });
  });
}
