// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/device/models/approval_request_response_dto.dart';

void main() {
  group('ApprovalRequestResponseDto', () {
    test('can be created with required fields', () {
      final result = const ApprovalRequestResponseDto(
        requestId: 'req-001',
        accountId: 'acc-001',
        requestingDeviceId: 'device-req',
        operationType: 'data_export',
        status: 'pending',
        createdAt: '2026-01-01T00:00:00Z',
        expiresAt: '2026-01-02T00:00:00Z',
        isExpired: false,
      );
      expect(result.requestId, 'req-001');
      expect(result.accountId, 'acc-001');
      expect(result.requestingDeviceId, 'device-req');
      expect(result.operationType, 'data_export');
      expect(result.status, 'pending');
      expect(result.createdAt, '2026-01-01T00:00:00Z');
      expect(result.expiresAt, '2026-01-02T00:00:00Z');
      expect(result.isExpired, false);
    });

    test('serializes to JSON correctly', () {
      final result = const ApprovalRequestResponseDto(
        requestId: 'req-001',
        accountId: 'acc-001',
        requestingDeviceId: 'device-req',
        operationType: 'data_export',
        status: 'pending',
        createdAt: '2026-01-01T00:00:00Z',
        expiresAt: '2026-01-02T00:00:00Z',
        isExpired: false,
      );
      final json = result.toJson();
      expect(json['requestId'], 'req-001');
      expect(json['accountId'], 'acc-001');
      expect(json['requestingDeviceId'], 'device-req');
      expect(json['operationType'], 'data_export');
      expect(json['status'], 'pending');
      expect(json['createdAt'], '2026-01-01T00:00:00Z');
      expect(json['expiresAt'], '2026-01-02T00:00:00Z');
      expect(json['isExpired'], false);
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'requestId': 'req-001',
        'accountId': 'acc-001',
        'requestingDeviceId': 'device-req',
        'operationType': 'data_export',
        'status': 'pending',
        'createdAt': '2026-01-01T00:00:00Z',
        'expiresAt': '2026-01-02T00:00:00Z',
        'isExpired': false,
      };
      final result = ApprovalRequestResponseDto.fromJson(json);
      expect(result.requestId, 'req-001');
      expect(result.accountId, 'acc-001');
      expect(result.requestingDeviceId, 'device-req');
      expect(result.operationType, 'data_export');
      expect(result.status, 'pending');
      expect(result.createdAt, '2026-01-01T00:00:00Z');
      expect(result.expiresAt, '2026-01-02T00:00:00Z');
      expect(result.isExpired, false);
    });

    test('equality works correctly', () {
      final a = const ApprovalRequestResponseDto(
        requestId: 'req-001',
        accountId: 'acc-001',
        requestingDeviceId: 'device-req',
        operationType: 'data_export',
        status: 'pending',
        createdAt: '2026-01-01T00:00:00Z',
        expiresAt: '2026-01-02T00:00:00Z',
        isExpired: false,
      );
      final b = const ApprovalRequestResponseDto(
        requestId: 'req-001',
        accountId: 'acc-001',
        requestingDeviceId: 'device-req',
        operationType: 'data_export',
        status: 'pending',
        createdAt: '2026-01-01T00:00:00Z',
        expiresAt: '2026-01-02T00:00:00Z',
        isExpired: false,
      );
      final c = const ApprovalRequestResponseDto(
        requestId: 'different',
        accountId: 'acc-001',
        requestingDeviceId: 'device-req',
        operationType: 'data_export',
        status: 'pending',
        createdAt: '2026-01-01T00:00:00Z',
        expiresAt: '2026-01-02T00:00:00Z',
        isExpired: false,
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const ApprovalRequestResponseDto(
        requestId: 'req-001',
        accountId: 'acc-001',
        requestingDeviceId: 'device-req',
        operationType: 'data_export',
        status: 'pending',
        createdAt: '2026-01-01T00:00:00Z',
        expiresAt: '2026-01-02T00:00:00Z',
        isExpired: false,
      );
      final roundTripped = ApprovalRequestResponseDto.fromJson(
        original.toJson(),
      );
      expect(roundTripped, equals(original));
    });
  });
}
