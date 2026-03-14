// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/device/models/create_approval_request_dto.dart';

void main() {
  group('CreateApprovalRequestDto', () {
    test('can be created with required fields', () {
      final result = const CreateApprovalRequestDto(
        requestingDeviceId: 'device-req',
        operationType: 'data_export',
      );
      expect(result.requestingDeviceId, 'device-req');
      expect(result.operationType, 'data_export');
    });

    test('serializes to JSON correctly', () {
      final result = const CreateApprovalRequestDto(
        requestingDeviceId: 'device-req',
        operationType: 'data_export',
      );
      final json = result.toJson();
      expect(json['requestingDeviceId'], 'device-req');
      expect(json['operationType'], 'data_export');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{
        'requestingDeviceId': 'device-req',
        'operationType': 'data_export',
      };
      final result = CreateApprovalRequestDto.fromJson(json);
      expect(result.requestingDeviceId, 'device-req');
      expect(result.operationType, 'data_export');
    });

    test('equality works correctly', () {
      final a = const CreateApprovalRequestDto(
        requestingDeviceId: 'device-req',
        operationType: 'data_export',
      );
      final b = const CreateApprovalRequestDto(
        requestingDeviceId: 'device-req',
        operationType: 'data_export',
      );
      final c = const CreateApprovalRequestDto(
        requestingDeviceId: 'different',
        operationType: 'data_export',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const CreateApprovalRequestDto(
        requestingDeviceId: 'device-req',
        operationType: 'data_export',
      );
      final roundTripped = CreateApprovalRequestDto.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
