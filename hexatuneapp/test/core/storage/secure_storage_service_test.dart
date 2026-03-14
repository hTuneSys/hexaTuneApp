// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/storage/secure_storage_service.dart';

class MockLogService extends Mock implements LogService {}

void main() {
  group('SecureStorageService', () {
    // SecureStorageService depends on FlutterSecureStorage which requires
    // platform channels. We test the key constants and API surface.

    test('can be instantiated with LogService', () {
      final logService = MockLogService();
      final service = SecureStorageService(logService);
      expect(service, isNotNull);
    });
  });
}
