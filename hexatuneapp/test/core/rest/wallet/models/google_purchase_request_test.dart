// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/wallet/models/google_purchase_request.dart';

void main() {
  group('GooglePurchaseRequest', () {
    final fullJson = <String, dynamic>{
      'packageId': 'pkg-001',
      'purchaseToken': 'token-abc-123',
    };

    test('can be created with required fields', () {
      const result = GooglePurchaseRequest(
        packageId: 'pkg-001',
        purchaseToken: 'token-abc-123',
      );
      expect(result.packageId, 'pkg-001');
      expect(result.purchaseToken, 'token-abc-123');
    });

    test('serializes to JSON correctly', () {
      const result = GooglePurchaseRequest(
        packageId: 'pkg-001',
        purchaseToken: 'token-abc-123',
      );
      final json = result.toJson();
      expect(json['packageId'], 'pkg-001');
      expect(json['purchaseToken'], 'token-abc-123');
    });

    test('deserializes from JSON correctly', () {
      final result = GooglePurchaseRequest.fromJson(fullJson);
      expect(result.packageId, 'pkg-001');
      expect(result.purchaseToken, 'token-abc-123');
    });

    test('equality works correctly', () {
      const a = GooglePurchaseRequest(
        packageId: 'pkg-001',
        purchaseToken: 'token-abc',
      );
      const b = GooglePurchaseRequest(
        packageId: 'pkg-001',
        purchaseToken: 'token-abc',
      );
      const c = GooglePurchaseRequest(
        packageId: 'pkg-002',
        purchaseToken: 'token-xyz',
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      const original = GooglePurchaseRequest(
        packageId: 'pkg-001',
        purchaseToken: 'token-abc-123',
      );
      final roundTripped = GooglePurchaseRequest.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
