// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/wallet/models/mobile_purchase_request.dart';

void main() {
  group('MobilePurchaseRequest', () {
    final fullJson = <String, dynamic>{
      'packageId': 'pkg-001',
      'receiptData': 'receipt-abc-123',
    };

    test('can be created with required fields', () {
      const result = MobilePurchaseRequest(
        packageId: 'pkg-001',
        receiptData: 'receipt-abc-123',
      );
      expect(result.packageId, 'pkg-001');
      expect(result.receiptData, 'receipt-abc-123');
    });

    test('serializes to JSON correctly', () {
      const result = MobilePurchaseRequest(
        packageId: 'pkg-001',
        receiptData: 'receipt-abc-123',
      );
      final json = result.toJson();
      expect(json['packageId'], 'pkg-001');
      expect(json['receiptData'], 'receipt-abc-123');
    });

    test('deserializes from JSON correctly', () {
      final result = MobilePurchaseRequest.fromJson(fullJson);
      expect(result.packageId, 'pkg-001');
      expect(result.receiptData, 'receipt-abc-123');
    });

    test('equality works correctly', () {
      const a = MobilePurchaseRequest(
        packageId: 'pkg-001',
        receiptData: 'receipt-abc',
      );
      const b = MobilePurchaseRequest(
        packageId: 'pkg-001',
        receiptData: 'receipt-abc',
      );
      const c = MobilePurchaseRequest(
        packageId: 'pkg-002',
        receiptData: 'receipt-xyz',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      const original = MobilePurchaseRequest(
        packageId: 'pkg-001',
        receiptData: 'receipt-abc-123',
      );
      final roundTripped = MobilePurchaseRequest.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
