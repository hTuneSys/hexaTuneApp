// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/wallet/models/coin_package_response.dart';

void main() {
  group('CoinPackageResponse', () {
    final fullJson = <String, dynamic>{
      'id': 'pkg-001',
      'name': 'Starter Pack',
      'coins': 100,
      'priceCents': 999,
      'currency': 'USD',
      'sortOrder': 1,
      'appleProductId': 'com.hexatune.coins100',
      'googleProductId': 'coins_100',
      'stripePriceId': 'price_abc123',
    };

    test('can be created with required fields only', () {
      const result = CoinPackageResponse(
        id: 'pkg-001',
        name: 'Starter Pack',
        coins: 100,
        priceCents: 999,
        currency: 'USD',
        sortOrder: 1,
      );
      expect(result.id, 'pkg-001');
      expect(result.name, 'Starter Pack');
      expect(result.coins, 100);
      expect(result.priceCents, 999);
      expect(result.currency, 'USD');
      expect(result.sortOrder, 1);
      expect(result.appleProductId, isNull);
      expect(result.googleProductId, isNull);
      expect(result.stripePriceId, isNull);
    });

    test('can be created with all fields', () {
      const result = CoinPackageResponse(
        id: 'pkg-001',
        name: 'Starter Pack',
        coins: 100,
        priceCents: 999,
        currency: 'USD',
        sortOrder: 1,
        appleProductId: 'com.hexatune.coins100',
        googleProductId: 'coins_100',
        stripePriceId: 'price_abc123',
      );
      expect(result.appleProductId, 'com.hexatune.coins100');
      expect(result.googleProductId, 'coins_100');
      expect(result.stripePriceId, 'price_abc123');
    });

    test('serializes to JSON correctly', () {
      const result = CoinPackageResponse(
        id: 'pkg-001',
        name: 'Starter Pack',
        coins: 100,
        priceCents: 999,
        currency: 'USD',
        sortOrder: 1,
        appleProductId: 'com.hexatune.coins100',
        googleProductId: 'coins_100',
        stripePriceId: 'price_abc123',
      );
      final json = result.toJson();
      expect(json['id'], 'pkg-001');
      expect(json['name'], 'Starter Pack');
      expect(json['coins'], 100);
      expect(json['priceCents'], 999);
      expect(json['currency'], 'USD');
      expect(json['sortOrder'], 1);
      expect(json['appleProductId'], 'com.hexatune.coins100');
      expect(json['googleProductId'], 'coins_100');
      expect(json['stripePriceId'], 'price_abc123');
    });

    test('serializes to JSON with null optional fields', () {
      const result = CoinPackageResponse(
        id: 'pkg-001',
        name: 'Basic',
        coins: 50,
        priceCents: 499,
        currency: 'EUR',
        sortOrder: 2,
      );
      final json = result.toJson();
      expect(json['appleProductId'], isNull);
      expect(json['googleProductId'], isNull);
      expect(json['stripePriceId'], isNull);
    });

    test('deserializes from JSON correctly', () {
      final result = CoinPackageResponse.fromJson(fullJson);
      expect(result.id, 'pkg-001');
      expect(result.name, 'Starter Pack');
      expect(result.coins, 100);
      expect(result.priceCents, 999);
      expect(result.currency, 'USD');
      expect(result.sortOrder, 1);
      expect(result.appleProductId, 'com.hexatune.coins100');
      expect(result.googleProductId, 'coins_100');
      expect(result.stripePriceId, 'price_abc123');
    });

    test('deserializes from JSON with missing optional fields', () {
      final json = <String, dynamic>{
        'id': 'pkg-002',
        'name': 'Basic',
        'coins': 50,
        'priceCents': 499,
        'currency': 'EUR',
        'sortOrder': 2,
      };
      final result = CoinPackageResponse.fromJson(json);
      expect(result.id, 'pkg-002');
      expect(result.appleProductId, isNull);
      expect(result.googleProductId, isNull);
      expect(result.stripePriceId, isNull);
    });

    test('equality works correctly', () {
      const a = CoinPackageResponse(
        id: 'pkg-001',
        name: 'Starter',
        coins: 100,
        priceCents: 999,
        currency: 'USD',
        sortOrder: 1,
      );
      const b = CoinPackageResponse(
        id: 'pkg-001',
        name: 'Starter',
        coins: 100,
        priceCents: 999,
        currency: 'USD',
        sortOrder: 1,
      );
      const c = CoinPackageResponse(
        id: 'pkg-002',
        name: 'Pro',
        coins: 500,
        priceCents: 4999,
        currency: 'USD',
        sortOrder: 2,
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('round-trip serialization preserves data', () {
      const original = CoinPackageResponse(
        id: 'pkg-001',
        name: 'Starter Pack',
        coins: 100,
        priceCents: 999,
        currency: 'USD',
        sortOrder: 1,
        appleProductId: 'com.hexatune.coins100',
        googleProductId: 'coins_100',
        stripePriceId: 'price_abc123',
      );
      final roundTripped = CoinPackageResponse.fromJson(original.toJson());
      expect(roundTripped, equals(original));
    });
  });
}
