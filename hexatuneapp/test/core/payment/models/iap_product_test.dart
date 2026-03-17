// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/payment/models/iap_product.dart';

void main() {
  group('IapProduct', () {
    const product = IapProduct(
      packageId: 'pkg-001',
      name: 'Starter Pack',
      coins: 100,
      storeProductId: 'com.hexatune.coins100',
      price: r'$0.99',
      rawPrice: 0.99,
      currencyCode: 'USD',
    );

    test('creates with required fields', () {
      expect(product.packageId, 'pkg-001');
      expect(product.name, 'Starter Pack');
      expect(product.coins, 100);
      expect(product.storeProductId, 'com.hexatune.coins100');
      expect(product.price, r'$0.99');
      expect(product.rawPrice, 0.99);
      expect(product.currencyCode, 'USD');
    });

    test('serializes to JSON', () {
      final json = product.toJson();

      expect(json['packageId'], 'pkg-001');
      expect(json['name'], 'Starter Pack');
      expect(json['coins'], 100);
      expect(json['storeProductId'], 'com.hexatune.coins100');
      expect(json['price'], r'$0.99');
      expect(json['rawPrice'], 0.99);
      expect(json['currencyCode'], 'USD');
    });

    test('deserializes from JSON', () {
      final json = {
        'packageId': 'pkg-002',
        'name': 'Pro Pack',
        'coins': 500,
        'storeProductId': 'com.hexatune.coins500',
        'price': r'$4.99',
        'rawPrice': 4.99,
        'currencyCode': 'USD',
      };

      final result = IapProduct.fromJson(json);

      expect(result.packageId, 'pkg-002');
      expect(result.name, 'Pro Pack');
      expect(result.coins, 500);
      expect(result.storeProductId, 'com.hexatune.coins500');
      expect(result.price, r'$4.99');
      expect(result.rawPrice, 4.99);
      expect(result.currencyCode, 'USD');
    });

    test('equality works', () {
      const same = IapProduct(
        packageId: 'pkg-001',
        name: 'Starter Pack',
        coins: 100,
        storeProductId: 'com.hexatune.coins100',
        price: r'$0.99',
        rawPrice: 0.99,
        currencyCode: 'USD',
      );

      expect(product, same);
    });

    test('inequality works', () {
      const other = IapProduct(
        packageId: 'pkg-002',
        name: 'Other',
        coins: 200,
        storeProductId: 'other',
        price: r'$1.99',
        rawPrice: 1.99,
        currencyCode: 'EUR',
      );

      expect(product, isNot(other));
    });

    test('copyWith creates modified copy', () {
      final modified = product.copyWith(coins: 200, name: 'Updated');

      expect(modified.packageId, 'pkg-001');
      expect(modified.name, 'Updated');
      expect(modified.coins, 200);
      expect(modified.storeProductId, 'com.hexatune.coins100');
    });

    test('toString contains class info', () {
      expect(product.toString(), contains('IapProduct'));
    });
  });
}
