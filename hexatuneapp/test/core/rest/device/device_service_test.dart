// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/rest/device/device_service.dart';
import 'package:hexatuneapp/src/core/storage/secure_storage_service.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockLogService extends Mock implements LogService {}

void main() {
  group('DeviceMetadata', () {
    test('can be created with required deviceId only', () {
      const metadata = DeviceMetadata(deviceId: 'dev-001');
      expect(metadata.deviceId, 'dev-001');
      expect(metadata.deviceName, isNull);
      expect(metadata.platform, isNull);
      expect(metadata.osVersion, isNull);
    });

    test('can be created with all fields', () {
      const metadata = DeviceMetadata(
        deviceId: 'dev-001',
        deviceName: 'Test Device',
        platform: 'linux',
        osVersion: '22.04',
      );
      expect(metadata.deviceId, 'dev-001');
      expect(metadata.deviceName, 'Test Device');
      expect(metadata.platform, 'linux');
      expect(metadata.osVersion, '22.04');
    });
  });

  group('DeviceService', () {
    late MockSecureStorageService mockStorage;
    late MockLogService mockLogService;
    late DeviceService service;

    setUp(() {
      mockStorage = MockSecureStorageService();
      mockLogService = MockLogService();
      service = DeviceService(mockStorage, mockLogService);
    });

    group('before initialization', () {
      test('deviceId throws StateError', () {
        expect(() => service.deviceId, throwsStateError);
      });

      test('deviceMetadata throws StateError', () {
        expect(() => service.deviceMetadata, throwsStateError);
      });

      test('platformName returns unknown', () {
        expect(service.platformName, 'unknown');
      });
    });

    group('init', () {
      setUp(() {
        when(
          () => mockLogService.info(any(), category: any(named: 'category')),
        ).thenReturn(null);
      });

      test('loads existing device ID from storage', () async {
        when(
          () => mockStorage.getDeviceId(),
        ).thenAnswer((_) async => 'existing-device-id');

        // init() will succeed loading the ID but may throw during
        // _buildDeviceMetadata due to native plugin dependency.
        // We verify the storage interaction regardless.
        try {
          await service.init();
        } catch (_) {
          // DeviceInfoPlugin may throw in test environment
        }

        verify(() => mockStorage.getDeviceId()).called(1);
        verifyNever(() => mockStorage.saveDeviceId(any()));
      });

      test('generates and saves new device ID when none exists', () async {
        when(() => mockStorage.getDeviceId()).thenAnswer((_) async => null);
        when(() => mockStorage.saveDeviceId(any())).thenAnswer((_) async {});

        try {
          await service.init();
        } catch (_) {
          // DeviceInfoPlugin may throw in test environment
        }

        verify(() => mockStorage.getDeviceId()).called(1);
        verify(() => mockStorage.saveDeviceId(any())).called(1);
      });

      test('generated device ID is a valid UUID v4 format', () async {
        String? savedId;
        when(() => mockStorage.getDeviceId()).thenAnswer((_) async => null);
        when(() => mockStorage.saveDeviceId(any())).thenAnswer((invocation) {
          savedId = invocation.positionalArguments[0] as String;
          return Future<void>.value();
        });

        try {
          await service.init();
        } catch (_) {
          // DeviceInfoPlugin may throw in test environment
        }

        expect(savedId, isNotNull);
        // UUID v4 format: 8-4-4-4-12 hex characters
        expect(
          savedId,
          matches(
            RegExp(
              r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-'
              r'[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
            ),
          ),
        );
      });
    });
  });
}
