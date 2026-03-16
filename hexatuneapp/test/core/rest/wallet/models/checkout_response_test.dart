// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/wallet/models/checkout_response.dart';

void main() {
  group('CheckoutResponse', () {
    final fullJson = <String, dynamic>{
      'sessionId': 'cs_abc123',
      'checkoutUrl': 'https://checkout.stripe.com/pay/abc',
    };

    test('can be created with required fields only', () {
      const result = CheckoutResponse(sessionId: 'cs_abc123');
      expect(result.sessionId, 'cs_abc123');
      expect(result.checkoutUrl, isNull);
    });

    test('can be created with all fields', () {
      const result = CheckoutResponse(
        sessionId: 'cs_abc123',
        checkoutUrl: 'https://checkout.stripe.com/pay/abc',
      );
      expect(result.sessionId, 'cs_abc123');
      expect(result.checkoutUrl, 'https://checkout.stripe.com/pay/abc');
    });

    test('serializes to JSON correctly', () {
      const result = CheckoutResponse(
        sessionId: 'cs_abc123',
        checkoutUrl: 'https://checkout.stripe.com/pay/abc',
      );
      final json = result.toJson();
      expect(json['sessionId'], 'cs_abc123');
      expect(json['checkoutUrl'], 'https://checkout.stripe.com/pay/abc');
    });

    test('deserializes from JSON correctly', () {
      final result = CheckoutResponse.fromJson(fullJson);
      expect(result.sessionId, 'cs_abc123');
      expect(result.checkoutUrl, 'https://checkout.stripe.com/pay/abc');
    });

    test('deserializes from JSON with null optional field', () {
      final json = <String, dynamic>{'sessionId': 'cs_abc123'};
      final result = CheckoutResponse.fromJson(json);
      expect(result.sessionId, 'cs_abc123');
      expect(result.checkoutUrl, isNull);
    });

    test('equality works correctly', () {
      const a = CheckoutResponse(
        sessionId: 'cs_abc123',
        checkoutUrl: 'https://checkout.stripe.com/pay/abc',
      );
      const b = CheckoutResponse(
        sessionId: 'cs_abc123',
        checkoutUrl: 'https://checkout.stripe.com/pay/abc',
      );
      const c = CheckoutResponse(sessionId: 'cs_different');
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      const original = CheckoutResponse(
        sessionId: 'cs_abc123',
        checkoutUrl: 'https://checkout.stripe.com/pay/abc',
      );
      final roundTripped = CheckoutResponse.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
