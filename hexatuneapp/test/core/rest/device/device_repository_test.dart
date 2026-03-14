// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/rest/device/device_repository.dart';
import 'package:hexatuneapp/src/core/rest/device/models/approval_request_response_dto.dart';
import 'package:hexatuneapp/src/core/rest/device/models/approve_request_dto.dart';
import 'package:hexatuneapp/src/core/rest/device/models/create_approval_request_dto.dart';
import 'package:hexatuneapp/src/core/rest/device/models/device_response.dart';
import 'package:hexatuneapp/src/core/rest/device/models/register_push_token_request.dart';
import 'package:hexatuneapp/src/core/rest/device/models/reject_request_dto.dart';
import 'package:hexatuneapp/src/core/rest/device/models/unregister_push_token_request.dart';
import 'package:hexatuneapp/src/core/config/api_endpoints.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_client.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockLogService extends Mock implements LogService {}

void main() {
  group('DeviceRepository', () {
    late Dio dio;
    late DioAdapter dioAdapter;
    late MockApiClient mockApiClient;
    late MockLogService mockLogService;
    late DeviceRepository repository;

    final approvalResponseJson = {
      'requestId': 'req-001',
      'accountId': 'acc-001',
      'requestingDeviceId': 'dev-001',
      'operationType': 'sensitive_action',
      'status': 'pending',
      'createdAt': '2025-01-01T00:00:00Z',
      'expiresAt': '2025-01-01T01:00:00Z',
      'isExpired': false,
    };

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://test.api'));
      dioAdapter = DioAdapter(dio: dio);
      mockApiClient = MockApiClient();
      mockLogService = MockLogService();

      when(() => mockApiClient.dio).thenReturn(dio);
      when(
        () => mockLogService.debug(any(), category: any(named: 'category')),
      ).thenReturn(null);

      repository = DeviceRepository(mockApiClient, mockLogService);
    });

    group('registerPushToken', () {
      test('sends PUT to push-token endpoint', () async {
        const request = RegisterPushTokenRequest(
          token: 'fcm-token-123',
          platform: 'android',
          appId: 'com.hexatune.app',
        );

        dioAdapter.onPut(
          ApiEndpoints.pushToken,
          (server) => server.reply(204, null),
          data: request.toJson(),
        );

        await expectLater(repository.registerPushToken(request), completes);
      });
    });

    group('removePushToken', () {
      test('sends DELETE with body to push-token endpoint', () async {
        const request = UnregisterPushTokenRequest(appId: 'com.hexatune.app');

        dioAdapter.onDelete(
          ApiEndpoints.pushToken,
          (server) => server.reply(204, null),
          data: request.toJson(),
        );

        await expectLater(repository.removePushToken(request), completes);
      });
    });

    group('listDevices', () {
      test('sends GET and returns device list', () async {
        dioAdapter.onGet(
          ApiEndpoints.devices,
          (server) => server.reply(200, [
            {
              'id': 'dev-001',
              'isTrusted': true,
              'userAgent': 'Flutter/3.0',
              'ipAddress': '192.168.1.1',
              'firstSeenAt': '2025-01-01T00:00:00Z',
              'lastSeenAt': '2025-01-02T00:00:00Z',
            },
          ]),
        );

        final result = await repository.listDevices();

        expect(result, hasLength(1));
        expect(result.first, isA<DeviceResponse>());
        expect(result.first.id, 'dev-001');
        expect(result.first.isTrusted, true);
      });
    });

    group('deleteDevice', () {
      test('sends DELETE to device endpoint', () async {
        dioAdapter.onDelete(
          ApiEndpoints.device('dev-001'),
          (server) => server.reply(204, null),
        );

        await expectLater(repository.deleteDevice('dev-001'), completes);
      });
    });

    group('requestApproval', () {
      test('sends POST and returns approval response', () async {
        const request = CreateApprovalRequestDto(
          requestingDeviceId: 'dev-001',
          operationType: 'sensitive_action',
        );

        dioAdapter.onPost(
          ApiEndpoints.deviceApprovalRequest,
          (server) => server.reply(201, approvalResponseJson),
          data: request.toJson(),
        );

        final result = await repository.requestApproval(request);

        expect(result, isA<ApprovalRequestResponseDto>());
        expect(result.requestId, 'req-001');
        expect(result.status, 'pending');
      });
    });

    group('approveRequest', () {
      test('sends POST to approve endpoint and returns response', () async {
        const request = ApproveRequestDto(approvingDeviceId: 'dev-002');

        dioAdapter.onPost(
          ApiEndpoints.deviceApprovalApprove('req-001'),
          (server) => server.reply(200, {
            ...approvalResponseJson,
            'status': 'approved',
            'approvingDeviceId': 'dev-002',
            'approvedAt': '2025-01-01T00:30:00Z',
          }),
          data: request.toJson(),
        );

        final result = await repository.approveRequest('req-001', request);

        expect(result.status, 'approved');
        expect(result.approvingDeviceId, 'dev-002');
      });
    });

    group('rejectRequest', () {
      test('sends POST to reject endpoint and returns response', () async {
        const request = RejectRequestDto(rejectingDeviceId: 'dev-002');

        dioAdapter.onPost(
          ApiEndpoints.deviceApprovalReject('req-001'),
          (server) => server.reply(200, {
            ...approvalResponseJson,
            'status': 'rejected',
            'rejectedAt': '2025-01-01T00:30:00Z',
          }),
          data: request.toJson(),
        );

        final result = await repository.rejectRequest('req-001', request);

        expect(result.status, 'rejected');
        expect(result.rejectedAt, '2025-01-01T00:30:00Z');
      });
    });

    group('checkApprovalStatus', () {
      test('sends GET and returns approval status', () async {
        dioAdapter.onGet(
          ApiEndpoints.deviceApprovalStatus('req-001'),
          (server) => server.reply(200, approvalResponseJson),
        );

        final result = await repository.checkApprovalStatus('req-001');

        expect(result, isA<ApprovalRequestResponseDto>());
        expect(result.requestId, 'req-001');
      });
    });
  });
}
