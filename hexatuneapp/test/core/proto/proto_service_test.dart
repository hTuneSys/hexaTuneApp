// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/proto/proto_service.dart';

class MockLogService extends Mock implements LogService {}

void main() {
  group('ProtoService', () {
    late MockLogService mockLog;
    late ProtoService service;

    setUp(() {
      mockLog = MockLogService();
      service = ProtoService(mockLog);
    });

    test('can be instantiated', () {
      expect(service, isNotNull);
    });

    test('isLoaded is false before init', () {
      expect(service.isLoaded, false);
    });

    test('proto getter throws StateError before init', () {
      expect(() => service.proto, throwsStateError);
    });
  });
}
