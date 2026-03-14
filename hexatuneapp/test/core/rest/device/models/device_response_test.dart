// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/device/models/device_response.dart';

void main() {
  group('DeviceResponse', () {
    final fullJson = <String, dynamic>{
      'id': 'dev-001',
      'isTrusted': true,
      'userAgent': 'Flutter/3.0',
      'ipAddress': '192.168.1.1',
      'firstSeenAt': '2025-01-01T00:00:00Z',
      'lastSeenAt': '2025-01-02T00:00:00Z',
    };

    test('can be created with required fields', () {
      const result = DeviceResponse(
        id: 'dev-001',
        isTrusted: true,
        userAgent: 'Flutter/3.0',
        ipAddress: '192.168.1.1',
        firstSeenAt: '2025-01-01T00:00:00Z',
        lastSeenAt: '2025-01-02T00:00:00Z',
      );
      expect(result.id, 'dev-001');
      expect(result.isTrusted, true);
      expect(result.userAgent, 'Flutter/3.0');
      expect(result.ipAddress, '192.168.1.1');
    });

    test('serializes to JSON correctly', () {
      const result = DeviceResponse(
        id: 'dev-001',
        isTrusted: false,
        userAgent: 'Test/1.0',
        ipAddress: '10.0.0.1',
        firstSeenAt: '2025-01-01T00:00:00Z',
        lastSeenAt: '2025-01-02T00:00:00Z',
      );
      final json = result.toJson();
      expect(json['id'], 'dev-001');
      expect(json['isTrusted'], false);
      expect(json['userAgent'], 'Test/1.0');
      expect(json['ipAddress'], '10.0.0.1');
    });

    test('deserializes from JSON correctly', () {
      final result = DeviceResponse.fromJson(fullJson);
      expect(result.id, 'dev-001');
      expect(result.isTrusted, true);
      expect(result.userAgent, 'Flutter/3.0');
      expect(result.firstSeenAt, '2025-01-01T00:00:00Z');
      expect(result.lastSeenAt, '2025-01-02T00:00:00Z');
    });

    test('equality works correctly', () {
      const a = DeviceResponse(
        id: 'dev-001',
        isTrusted: true,
        userAgent: 'a',
        ipAddress: '1',
        firstSeenAt: 'f',
        lastSeenAt: 'l',
      );
      const b = DeviceResponse(
        id: 'dev-001',
        isTrusted: true,
        userAgent: 'a',
        ipAddress: '1',
        firstSeenAt: 'f',
        lastSeenAt: 'l',
      );
      const c = DeviceResponse(
        id: 'dev-002',
        isTrusted: false,
        userAgent: 'a',
        ipAddress: '1',
        firstSeenAt: 'f',
        lastSeenAt: 'l',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      const original = DeviceResponse(
        id: 'dev-001',
        isTrusted: true,
        userAgent: 'ua',
        ipAddress: 'ip',
        firstSeenAt: 'f',
        lastSeenAt: 'l',
      );
      final roundTripped = DeviceResponse.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
