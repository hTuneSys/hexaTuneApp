// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/wallet/models/apple_purchase_request.dart';

void main() {
  group('ApplePurchaseRequest', () {
    final fullJson = <String, dynamic>{
      'packageId': 'pkg-001',
      'transactionId': 'txn-abc-123',
    };

    test('can be created with required fields', () {
      const result = ApplePurchaseRequest(
        packageId: 'pkg-001',
        transactionId: 'txn-abc-123',
      );
      expect(result.packageId, 'pkg-001');
      expect(result.transactionId, 'txn-abc-123');
    });

    test('serializes to JSON correctly', () {
      const result = ApplePurchaseRequest(
        packageId: 'pkg-001',
        transactionId: 'txn-abc-123',
      );
      final json = result.toJson();
      expect(json['packageId'], 'pkg-001');
      expect(json['transactionId'], 'txn-abc-123');
    });

    test('deserializes from JSON correctly', () {
      final result = ApplePurchaseRequest.fromJson(fullJson);
      expect(result.packageId, 'pkg-001');
      expect(result.transactionId, 'txn-abc-123');
    });

    test('equality works correctly', () {
      const a = ApplePurchaseRequest(
        packageId: 'pkg-001',
        transactionId: 'txn-abc',
      );
      const b = ApplePurchaseRequest(
        packageId: 'pkg-001',
        transactionId: 'txn-abc',
      );
      const c = ApplePurchaseRequest(
        packageId: 'pkg-002',
        transactionId: 'txn-xyz',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      const original = ApplePurchaseRequest(
        packageId: 'pkg-001',
        transactionId: 'txn-abc-123',
      );
      final roundTripped = ApplePurchaseRequest.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
