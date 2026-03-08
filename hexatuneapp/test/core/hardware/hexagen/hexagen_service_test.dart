// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/hardware/hexagen/hexagen_service.dart';
import 'package:hexatuneapp/src/core/hardware/hexagen/models/hexagen_state.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/proto/proto_service.dart';

class MockLogService extends Mock implements LogService {}

class MockProtoService extends Mock implements ProtoService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HexagenService', () {
    late MockLogService mockLog;
    late MockProtoService mockProto;
    late HexagenService service;

    setUp(() {
      mockLog = MockLogService();
      mockProto = MockProtoService();
      service = HexagenService(mockLog, mockProto);
    });

    tearDown(() {
      service.dispose();
    });

    test('can be instantiated', () {
      expect(service, isNotNull);
    });

    test('initial state is disconnected', () {
      expect(service.currentState, const HexagenState());
      expect(service.isConnected, false);
    });

    test('state stream is a broadcast stream', () {
      expect(service.state.isBroadcast, true);
    });

    test('generateId produces sequential IDs from 1 to 9999', () {
      expect(service.generateId(), 1);
      expect(service.generateId(), 2);
      expect(service.generateId(), 3);
    });

    test('generateId wraps around at 9999', () {
      for (int i = 0; i < 9998; i++) {
        service.generateId();
      }
      expect(service.generateId(), 9999);
      expect(service.generateId(), 1);
    });

    test('currentOperationId is initially null', () {
      expect(service.currentOperationId, isNull);
    });

    test('resetOperationState clears all operation fields', () {
      service.resetOperationState();
      expect(service.currentOperationId, isNull);
      expect(service.currentOperationStatus, isNull);
      expect(service.currentGeneratingStepId, isNull);
    });
  });
}
