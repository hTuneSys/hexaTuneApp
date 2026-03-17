// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/payment/iap_service.dart';
import 'package:hexatuneapp/src/core/payment/models/iap_status.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/coin_package_response.dart';
import 'package:hexatuneapp/src/core/rest/wallet/wallet_repository.dart';

class MockLogService extends Mock implements LogService {}

class MockWalletRepository extends Mock implements WalletRepository {}

class FakeProductDetails extends Fake implements ProductDetails {
  FakeProductDetails({
    required this.id,
    required this.price,
    required this.rawPrice,
    required this.currencyCode,
  });

  @override
  final String id;
  @override
  final String price;
  @override
  final double rawPrice;
  @override
  final String currencyCode;
}

void main() {
  late MockLogService mockLog;
  late MockWalletRepository mockRepo;
  late IapService service;

  setUp(() {
    mockLog = MockLogService();
    mockRepo = MockWalletRepository();
    service = IapService(mockLog, mockRepo);

    // Stub all log methods
    when(
      () => mockLog.info(any(), category: any(named: 'category')),
    ).thenReturn(null);
    when(
      () => mockLog.debug(any(), category: any(named: 'category')),
    ).thenReturn(null);
    when(
      () => mockLog.warning(any(), category: any(named: 'category')),
    ).thenReturn(null);
    when(
      () => mockLog.error(any(), category: any(named: 'category')),
    ).thenReturn(null);
  });

  group('IapService', () {
    group('extractProductIds', () {
      test('extracts iOS product IDs on iOS platform', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        addTearDown(() {
          debugDefaultTargetPlatformOverride = null;
        });

        const packages = [
          CoinPackageResponse(
            id: 'pkg-001',
            name: 'Starter',
            coins: 100,
            priceCents: 99,
            currency: 'USD',
            sortOrder: 1,
            appleProductId: 'com.hexatune.coins100',
            googleProductId: 'coins_100',
          ),
          CoinPackageResponse(
            id: 'pkg-002',
            name: 'Pro',
            coins: 500,
            priceCents: 499,
            currency: 'USD',
            sortOrder: 2,
            appleProductId: 'com.hexatune.coins500',
          ),
        ];

        final ids = service.extractProductIds(packages);

        expect(ids, {'com.hexatune.coins100', 'com.hexatune.coins500'});
      });

      test('extracts Android product IDs on Android platform', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        addTearDown(() {
          debugDefaultTargetPlatformOverride = null;
        });

        const packages = [
          CoinPackageResponse(
            id: 'pkg-001',
            name: 'Starter',
            coins: 100,
            priceCents: 99,
            currency: 'USD',
            sortOrder: 1,
            appleProductId: 'com.hexatune.coins100',
            googleProductId: 'coins_100',
          ),
          CoinPackageResponse(
            id: 'pkg-002',
            name: 'Pro',
            coins: 500,
            priceCents: 499,
            currency: 'USD',
            sortOrder: 2,
            googleProductId: 'coins_500',
          ),
        ];

        final ids = service.extractProductIds(packages);

        expect(ids, {'coins_100', 'coins_500'});
      });

      test('skips packages without platform product ID', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        addTearDown(() {
          debugDefaultTargetPlatformOverride = null;
        });

        const packages = [
          CoinPackageResponse(
            id: 'pkg-001',
            name: 'Starter',
            coins: 100,
            priceCents: 99,
            currency: 'USD',
            sortOrder: 1,
            googleProductId: 'coins_100',
          ),
        ];

        final ids = service.extractProductIds(packages);

        expect(ids, isEmpty);
      });

      test('returns empty set for empty packages', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        addTearDown(() {
          debugDefaultTargetPlatformOverride = null;
        });

        final ids = service.extractProductIds(const []);

        expect(ids, isEmpty);
      });
    });

    group('mergeProducts', () {
      test('merges backend packages with store products on iOS', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        addTearDown(() {
          debugDefaultTargetPlatformOverride = null;
        });

        const packages = [
          CoinPackageResponse(
            id: 'pkg-001',
            name: 'Starter',
            coins: 100,
            priceCents: 99,
            currency: 'USD',
            sortOrder: 1,
            appleProductId: 'com.hexatune.coins100',
          ),
          CoinPackageResponse(
            id: 'pkg-002',
            name: 'Pro',
            coins: 500,
            priceCents: 499,
            currency: 'USD',
            sortOrder: 2,
            appleProductId: 'com.hexatune.coins500',
          ),
        ];

        final storeProducts = [
          FakeProductDetails(
            id: 'com.hexatune.coins100',
            price: r'$0.99',
            rawPrice: 0.99,
            currencyCode: 'USD',
          ),
          FakeProductDetails(
            id: 'com.hexatune.coins500',
            price: r'$4.99',
            rawPrice: 4.99,
            currencyCode: 'USD',
          ),
        ];

        final result = service.mergeProducts(packages, storeProducts);

        expect(result, hasLength(2));
        expect(result[0].packageId, 'pkg-001');
        expect(result[0].name, 'Starter');
        expect(result[0].coins, 100);
        expect(result[0].storeProductId, 'com.hexatune.coins100');
        expect(result[0].price, r'$0.99');
        expect(result[0].rawPrice, 0.99);
        expect(result[1].packageId, 'pkg-002');
        expect(result[1].rawPrice, 4.99);
      });

      test('merges backend packages with store products on Android', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        addTearDown(() {
          debugDefaultTargetPlatformOverride = null;
        });

        const packages = [
          CoinPackageResponse(
            id: 'pkg-001',
            name: 'Starter',
            coins: 100,
            priceCents: 99,
            currency: 'USD',
            sortOrder: 1,
            googleProductId: 'coins_100',
          ),
        ];

        final storeProducts = [
          FakeProductDetails(
            id: 'coins_100',
            price: r'$0.99',
            rawPrice: 0.99,
            currencyCode: 'USD',
          ),
        ];

        final result = service.mergeProducts(packages, storeProducts);

        expect(result, hasLength(1));
        expect(result[0].storeProductId, 'coins_100');
      });

      test('skips packages with no matching store product', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        addTearDown(() {
          debugDefaultTargetPlatformOverride = null;
        });

        const packages = [
          CoinPackageResponse(
            id: 'pkg-001',
            name: 'Starter',
            coins: 100,
            priceCents: 99,
            currency: 'USD',
            sortOrder: 1,
            appleProductId: 'com.hexatune.coins100',
          ),
        ];

        final result = service.mergeProducts(packages, []);

        expect(result, isEmpty);
      });

      test('sorts results by price ascending', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        addTearDown(() {
          debugDefaultTargetPlatformOverride = null;
        });

        const packages = [
          CoinPackageResponse(
            id: 'pkg-002',
            name: 'Pro',
            coins: 500,
            priceCents: 499,
            currency: 'USD',
            sortOrder: 2,
            appleProductId: 'com.hexatune.coins500',
          ),
          CoinPackageResponse(
            id: 'pkg-001',
            name: 'Starter',
            coins: 100,
            priceCents: 99,
            currency: 'USD',
            sortOrder: 1,
            appleProductId: 'com.hexatune.coins100',
          ),
        ];

        final storeProducts = [
          FakeProductDetails(
            id: 'com.hexatune.coins500',
            price: r'$4.99',
            rawPrice: 4.99,
            currencyCode: 'USD',
          ),
          FakeProductDetails(
            id: 'com.hexatune.coins100',
            price: r'$0.99',
            rawPrice: 0.99,
            currencyCode: 'USD',
          ),
        ];

        final result = service.mergeProducts(packages, storeProducts);

        expect(result, hasLength(2));
        expect(result[0].rawPrice, 0.99);
        expect(result[1].rawPrice, 4.99);
      });

      test('skips packages without platform product ID', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        addTearDown(() {
          debugDefaultTargetPlatformOverride = null;
        });

        const packages = [
          CoinPackageResponse(
            id: 'pkg-001',
            name: 'Starter',
            coins: 100,
            priceCents: 99,
            currency: 'USD',
            sortOrder: 1,
            googleProductId: 'coins_100',
          ),
        ];

        final storeProducts = [
          FakeProductDetails(
            id: 'coins_100',
            price: r'$0.99',
            rawPrice: 0.99,
            currencyCode: 'USD',
          ),
        ];

        final result = service.mergeProducts(packages, storeProducts);

        expect(result, isEmpty);
      });
    });

    group('status', () {
      test('initial status is idle', () {
        expect(service.status, IapStatus.idle);
      });

      test('isAvailable defaults to false', () {
        expect(service.isAvailable, false);
      });

      test('products defaults to empty', () {
        expect(service.products, isEmpty);
      });

      test('lastError defaults to null', () {
        expect(service.lastError, isNull);
      });
    });
  });
}
