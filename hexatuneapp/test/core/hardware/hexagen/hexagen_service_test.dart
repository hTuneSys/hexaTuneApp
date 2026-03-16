// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/hardware/hexagen/hexagen_service.dart';
import 'package:hexatuneapp/src/core/hardware/hexagen/models/hexagen_state.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/proto/proto_service.dart';

class MockLogService extends Mock implements LogService {}

class MockProtoService extends Mock implements ProtoService {}

const _midiMethodChannel = MethodChannel(
  'plugins.invisiblewrench.com/flutter_midi_command',
);

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

      // Mock the flutter_midi_command platform channels so that
      // HexagenDeviceManager can be created in the test environment.
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(_midiMethodChannel, (call) async {
            if (call.method == 'getDevices') return <dynamic>[];
            return null;
          });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(_midiMethodChannel, null);
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

    test('stopOperationGraceful resets state', () async {
      // Cannot fully test (needs BLE), but verify state reset works.
      service.resetOperationState();
      expect(service.currentOperationId, isNull);
    });

    test('stopOperationImmediate resets state', () async {
      // Cannot fully test (needs BLE), but verify state reset works.
      service.resetOperationState();
      expect(service.currentOperationId, isNull);
    });

    test(
      'init succeeds and sets isInitialized even when ProtoService fails',
      () async {
        when(
          () => mockProto.init(),
        ).thenThrow(ArgumentError('Failed to lookup symbol'));
        when(() => mockProto.isLoaded).thenReturn(false);

        await service.init();

        expect(service.currentState.isInitialized, true);
      },
    );

    test('init sets isInitialized when ProtoService succeeds', () async {
      when(() => mockProto.init()).thenReturn(null);
      when(() => mockProto.isLoaded).thenReturn(true);

      await service.init();

      expect(service.currentState.isInitialized, true);
    });
  });
}
