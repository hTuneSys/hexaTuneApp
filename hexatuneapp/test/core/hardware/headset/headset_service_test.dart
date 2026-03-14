// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/hardware/headset/headset_service.dart';
import 'package:hexatuneapp/src/core/hardware/headset/headset_state.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';

class MockLogService extends Mock implements LogService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HeadsetService', () {
    late MockLogService mockLogService;
    late HeadsetService service;

    setUp(() {
      mockLogService = MockLogService();
      service = HeadsetService(mockLogService);
    });

    tearDown(() {
      service.dispose();
    });

    test('can be instantiated', () {
      expect(service, isNotNull);
    });

    test('initial state has no connections', () {
      expect(service.currentState, const HeadsetState());
      expect(service.isConnected, false);
    });

    test('state stream is a broadcast stream', () {
      final stream = service.state;
      expect(stream.isBroadcast, true);
    });

    test('isConnected reflects currentState.isAnyConnected', () {
      expect(service.isConnected, service.currentState.isAnyConnected);
    });
  });
}
