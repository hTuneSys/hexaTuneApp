// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/permission/permission_service.dart';

class MockLogService extends Mock implements LogService {}

void main() {
  group('PermissionService', () {
    test('can be instantiated with LogService', () {
      final logService = MockLogService();
      final service = PermissionService(logService);
      expect(service, isNotNull);
    });
  });
}
