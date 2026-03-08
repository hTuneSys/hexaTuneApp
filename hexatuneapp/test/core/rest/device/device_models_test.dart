// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/device/models/approval_request_response_dto.dart';
import 'package:hexatuneapp/src/core/rest/device/models/approve_request_dto.dart';
import 'package:hexatuneapp/src/core/rest/device/models/create_approval_request_dto.dart';
import 'package:hexatuneapp/src/core/rest/device/models/register_push_token_request.dart';
import 'package:hexatuneapp/src/core/rest/device/models/reject_request_dto.dart';

void main() {
  group('RegisterPushTokenRequest', () {
    test('fromJson creates instance', () {
      final json = {'token': 'fcm-123', 'platform': 'android'};
      final request = RegisterPushTokenRequest.fromJson(json);
      expect(request.token, 'fcm-123');
      expect(request.platform, 'android');
    });

    test('toJson produces correct keys', () {
      const request = RegisterPushTokenRequest(
        token: 'fcm-123',
        platform: 'ios',
      );
      final json = request.toJson();
      expect(json['token'], 'fcm-123');
      expect(json['platform'], 'ios');
    });
  });

  group('ApproveRequestDto', () {
    test('fromJson creates instance', () {
      final json = {'approvingDeviceId': 'dev-002'};
      final dto = ApproveRequestDto.fromJson(json);
      expect(dto.approvingDeviceId, 'dev-002');
    });

    test('toJson produces correct keys', () {
      const dto = ApproveRequestDto(approvingDeviceId: 'dev-002');
      expect(dto.toJson()['approvingDeviceId'], 'dev-002');
    });
  });

  group('RejectRequestDto', () {
    test('fromJson creates instance', () {
      final json = {'rejectingDeviceId': 'dev-003'};
      final dto = RejectRequestDto.fromJson(json);
      expect(dto.rejectingDeviceId, 'dev-003');
    });

    test('toJson produces correct keys', () {
      const dto = RejectRequestDto(rejectingDeviceId: 'dev-003');
      expect(dto.toJson()['rejectingDeviceId'], 'dev-003');
    });
  });

  group('CreateApprovalRequestDto', () {
    test('fromJson creates instance with all fields', () {
      final json = {
        'requestingDeviceId': 'dev-001',
        'operationType': 'sensitive_action',
        'operationMetadata': {'key': 'value'},
      };
      final dto = CreateApprovalRequestDto.fromJson(json);
      expect(dto.requestingDeviceId, 'dev-001');
      expect(dto.operationType, 'sensitive_action');
      expect(dto.operationMetadata, {'key': 'value'});
    });

    test('operationMetadata is optional', () {
      const dto = CreateApprovalRequestDto(
        requestingDeviceId: 'dev-001',
        operationType: 'action',
      );
      expect(dto.operationMetadata, isNull);
    });
  });

  group('ApprovalRequestResponseDto', () {
    test('fromJson creates instance with all fields', () {
      final json = {
        'requestId': 'req-001',
        'accountId': 'acc-001',
        'requestingDeviceId': 'dev-001',
        'operationType': 'sensitive_action',
        'status': 'approved',
        'createdAt': '2025-01-01T00:00:00Z',
        'expiresAt': '2025-01-01T01:00:00Z',
        'isExpired': false,
        'approvingDeviceId': 'dev-002',
        'approvedAt': '2025-01-01T00:30:00Z',
        'operationMetadata': {'key': 'value'},
      };
      final dto = ApprovalRequestResponseDto.fromJson(json);
      expect(dto.requestId, 'req-001');
      expect(dto.status, 'approved');
      expect(dto.approvingDeviceId, 'dev-002');
      expect(dto.approvedAt, '2025-01-01T00:30:00Z');
      expect(dto.isExpired, false);
    });

    test('optional fields default to null', () {
      final json = {
        'requestId': 'req-001',
        'accountId': 'acc-001',
        'requestingDeviceId': 'dev-001',
        'operationType': 'action',
        'status': 'pending',
        'createdAt': '2025-01-01T00:00:00Z',
        'expiresAt': '2025-01-01T01:00:00Z',
        'isExpired': false,
      };
      final dto = ApprovalRequestResponseDto.fromJson(json);
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
        operationType: 'action',
        status: 'pending',
        createdAt: '2025-01-01T00:00:00Z',
        expiresAt: '2025-01-01T01:00:00Z',
        isExpired: false,
      );
      final json = dto.toJson();
      expect(json['requestId'], 'req-001');
      expect(json['status'], 'pending');
      expect(json['isExpired'], false);
    });
  });
}
