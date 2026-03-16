// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/wallet/models/initiate_purchase_request.dart';

void main() {
  group('InitiatePurchaseRequest', () {
    final fullJson = <String, dynamic>{'packageId': 'pkg-001'};

    test('can be created with required fields', () {
      const result = InitiatePurchaseRequest(packageId: 'pkg-001');
      expect(result.packageId, 'pkg-001');
    });

    test('serializes to JSON correctly', () {
      const result = InitiatePurchaseRequest(packageId: 'pkg-001');
      final json = result.toJson();
      expect(json['packageId'], 'pkg-001');
    });

    test('deserializes from JSON correctly', () {
      final result = InitiatePurchaseRequest.fromJson(fullJson);
      expect(result.packageId, 'pkg-001');
    });

    test('equality works correctly', () {
      const a = InitiatePurchaseRequest(packageId: 'pkg-001');
      const b = InitiatePurchaseRequest(packageId: 'pkg-001');
      const c = InitiatePurchaseRequest(packageId: 'pkg-002');
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      const original = InitiatePurchaseRequest(packageId: 'pkg-001');
      final roundTripped = InitiatePurchaseRequest.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
