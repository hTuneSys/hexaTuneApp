// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/device/models/register_push_token_request.dart';
import 'package:hexatuneapp/src/core/device/models/create_approval_request_dto.dart';
import 'package:hexatuneapp/src/core/device/models/approve_request_dto.dart';
import 'package:hexatuneapp/src/core/device/models/reject_request_dto.dart';
import 'package:hexatuneapp/src/core/device/models/approval_request_response_dto.dart';

void main() {
  group('RegisterPushTokenRequest', () {
    test('fromJson creates instance', () {
      final json = {'token': 'push-tok-abc', 'platform': 'ios'};
      final request = RegisterPushTokenRequest.fromJson(json);
      expect(request.token, 'push-tok-abc');
      expect(request.platform, 'ios');
    });

    test('toJson produces correct keys', () {
      const request = RegisterPushTokenRequest(
        token: 'push-tok-abc',
        platform: 'android',
      );
      final json = request.toJson();
      expect(json['token'], 'push-tok-abc');
      expect(json['platform'], 'android');
    });

    test('round-trip preserves values', () {
      const original = RegisterPushTokenRequest(
        token: 't',
        platform: 'p',
      );
      final restored = RegisterPushTokenRequest.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('CreateApprovalRequestDto', () {
    test('fromJson with all fields', () {
      final json = {
        'requestingDeviceId': 'dev-001',
        'operationType': 'login',
        'operationMetadata': {'key': 'value'},
      };
      final dto = CreateApprovalRequestDto.fromJson(json);
      expect(dto.requestingDeviceId, 'dev-001');
      expect(dto.operationType, 'login');
      expect(dto.operationMetadata, {'key': 'value'});
    });

    test('fromJson without optional operationMetadata', () {
      final json = {
        'requestingDeviceId': 'dev-002',
        'operationType': 'transfer',
      };
      final dto = CreateApprovalRequestDto.fromJson(json);
      expect(dto.requestingDeviceId, 'dev-002');
      expect(dto.operationType, 'transfer');
      expect(dto.operationMetadata, isNull);
    });

    test('toJson produces correct keys', () {
      const dto = CreateApprovalRequestDto(
        requestingDeviceId: 'dev-001',
        operationType: 'login',
        operationMetadata: {'ip': '1.2.3.4'},
      );
      final json = dto.toJson();
      expect(json['requestingDeviceId'], 'dev-001');
      expect(json['operationType'], 'login');
      expect(json['operationMetadata'], {'ip': '1.2.3.4'});
    });

    test('round-trip preserves values', () {
      const original = CreateApprovalRequestDto(
        requestingDeviceId: 'd',
        operationType: 'o',
      );
      final restored =
          CreateApprovalRequestDto.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('ApproveRequestDto', () {
    test('fromJson creates instance', () {
      final json = {'approvingDeviceId': 'dev-approve'};
      final dto = ApproveRequestDto.fromJson(json);
      expect(dto.approvingDeviceId, 'dev-approve');
    });

    test('toJson produces correct keys', () {
      const dto = ApproveRequestDto(approvingDeviceId: 'dev-approve');
      final json = dto.toJson();
      expect(json['approvingDeviceId'], 'dev-approve');
    });

    test('round-trip preserves values', () {
      const original = ApproveRequestDto(approvingDeviceId: 'a');
      final restored = ApproveRequestDto.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('RejectRequestDto', () {
    test('fromJson creates instance', () {
      final json = {'rejectingDeviceId': 'dev-reject'};
      final dto = RejectRequestDto.fromJson(json);
      expect(dto.rejectingDeviceId, 'dev-reject');
    });

    test('toJson produces correct keys', () {
      const dto = RejectRequestDto(rejectingDeviceId: 'dev-reject');
      final json = dto.toJson();
      expect(json['rejectingDeviceId'], 'dev-reject');
    });

    test('round-trip preserves values', () {
      const original = RejectRequestDto(rejectingDeviceId: 'r');
      final restored = RejectRequestDto.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('ApprovalRequestResponseDto', () {
    test('fromJson with all fields', () {
      final json = {
        'requestId': 'req-001',
        'accountId': 'acc-001',
        'requestingDeviceId': 'dev-001',
        'operationType': 'login',
        'status': 'pending',
        'createdAt': '2025-01-01T00:00:00Z',
        'expiresAt': '2025-01-02T00:00:00Z',
        'isExpired': false,
        'approvingDeviceId': 'dev-002',
        'approvedAt': '2025-01-01T12:00:00Z',
        'rejectedAt': null,
        'operationMetadata': {'reason': 'test'},
      };
      final dto = ApprovalRequestResponseDto.fromJson(json);
      expect(dto.requestId, 'req-001');
      expect(dto.accountId, 'acc-001');
      expect(dto.requestingDeviceId, 'dev-001');
      expect(dto.operationType, 'login');
      expect(dto.status, 'pending');
      expect(dto.createdAt, '2025-01-01T00:00:00Z');
      expect(dto.expiresAt, '2025-01-02T00:00:00Z');
      expect(dto.isExpired, false);
      expect(dto.approvingDeviceId, 'dev-002');
      expect(dto.approvedAt, '2025-01-01T12:00:00Z');
      expect(dto.rejectedAt, isNull);
      expect(dto.operationMetadata, {'reason': 'test'});
    });

    test('fromJson with only required fields', () {
      final json = {
        'requestId': 'req-002',
        'accountId': 'acc-002',
        'requestingDeviceId': 'dev-003',
        'operationType': 'transfer',
        'status': 'approved',
        'createdAt': '2025-01-01T00:00:00Z',
        'expiresAt': '2025-01-02T00:00:00Z',
        'isExpired': true,
      };
      final dto = ApprovalRequestResponseDto.fromJson(json);
      expect(dto.requestId, 'req-002');
      expect(dto.isExpired, true);
      expect(dto.approvingDeviceId, isNull);
      expect(dto.approvedAt, isNull);
      expect(dto.rejectedAt, isNull);
      expect(dto.operationMetadata, isNull);
    });

    test('toJson produces correct keys', () {
      const dto = ApprovalRequestResponseDto(
        requestId: 'req-001',
        accountId: 'acc-001',
        requestingDeviceId: 'dev-001',
        operationType: 'login',
        status: 'pending',
        createdAt: '2025-01-01T00:00:00Z',
        expiresAt: '2025-01-02T00:00:00Z',
        isExpired: false,
      );
      final json = dto.toJson();
      expect(json['requestId'], 'req-001');
      expect(json['accountId'], 'acc-001');
      expect(json['requestingDeviceId'], 'dev-001');
      expect(json['operationType'], 'login');
      expect(json['status'], 'pending');
      expect(json['createdAt'], '2025-01-01T00:00:00Z');
      expect(json['expiresAt'], '2025-01-02T00:00:00Z');
      expect(json['isExpired'], false);
    });

    test('round-trip preserves values', () {
      const original = ApprovalRequestResponseDto(
        requestId: 'r',
        accountId: 'a',
        requestingDeviceId: 'd',
        operationType: 'o',
        status: 's',
        createdAt: 'c',
        expiresAt: 'e',
        isExpired: false,
        approvingDeviceId: 'ad',
        operationMetadata: {'k': 'v'},
      );
      final restored =
          ApprovalRequestResponseDto.fromJson(original.toJson());
      expect(restored, original);
    });
  });
}
