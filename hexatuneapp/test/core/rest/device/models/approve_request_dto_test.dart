// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/device/models/approve_request_dto.dart';

void main() {
  group('ApproveRequestDto', () {
    test('can be created with required fields', () {
      final result = const ApproveRequestDto(
        approvingDeviceId: 'device-approve',
      );
      expect(result.approvingDeviceId, 'device-approve');
    });

    test('serializes to JSON correctly', () {
      final result = const ApproveRequestDto(
        approvingDeviceId: 'device-approve',
      );
      final json = result.toJson();
      expect(json['approvingDeviceId'], 'device-approve');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{'approvingDeviceId': 'device-approve'};
      final result = ApproveRequestDto.fromJson(json);
      expect(result.approvingDeviceId, 'device-approve');
    });

    test('equality works correctly', () {
      final a = const ApproveRequestDto(approvingDeviceId: 'device-approve');
      final b = const ApproveRequestDto(approvingDeviceId: 'device-approve');
      final c = const ApproveRequestDto(approvingDeviceId: 'different');
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const ApproveRequestDto(
        approvingDeviceId: 'device-approve',
      );
      final roundTripped = ApproveRequestDto.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
