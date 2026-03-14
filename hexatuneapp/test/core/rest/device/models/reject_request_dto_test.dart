// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/device/models/reject_request_dto.dart';

void main() {
  group('RejectRequestDto', () {
    test('can be created with required fields', () {
      final result = const RejectRequestDto(rejectingDeviceId: 'device-reject');
      expect(result.rejectingDeviceId, 'device-reject');
    });

    test('serializes to JSON correctly', () {
      final result = const RejectRequestDto(rejectingDeviceId: 'device-reject');
      final json = result.toJson();
      expect(json['rejectingDeviceId'], 'device-reject');
    });

    test('deserializes from JSON correctly', () {
      final json = <String, dynamic>{'rejectingDeviceId': 'device-reject'};
      final result = RejectRequestDto.fromJson(json);
      expect(result.rejectingDeviceId, 'device-reject');
    });

    test('equality works correctly', () {
      final a = const RejectRequestDto(rejectingDeviceId: 'device-reject');
      final b = const RejectRequestDto(rejectingDeviceId: 'device-reject');
      final c = const RejectRequestDto(rejectingDeviceId: 'different');
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      final original = const RejectRequestDto(
        rejectingDeviceId: 'device-reject',
      );
      final roundTripped = RejectRequestDto.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
