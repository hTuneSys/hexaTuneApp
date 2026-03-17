// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/payment/models/iap_product.dart';
import 'package:hexatuneapp/src/core/payment/models/iap_status.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/apple_purchase_request.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/coin_package_response.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/google_purchase_request.dart';
import 'package:hexatuneapp/src/core/rest/wallet/wallet_repository.dart';

/// Service that manages in-app purchases via native stores (App Store / Play Store)
/// and verifies them with the backend.
@singleton
class IapService {
  IapService(this._logService, this._walletRepository);

  final LogService _logService;
  final WalletRepository _walletRepository;

  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  final _statusController = StreamController<IapStatus>.broadcast();
  final _productsController = StreamController<List<IapProduct>>.broadcast();

  /// Stream of purchase status changes.
  Stream<IapStatus> get statusStream => _statusController.stream;

  /// Stream of available products.
  Stream<List<IapProduct>> get productsStream => _productsController.stream;

  List<IapProduct> _products = [];

  /// Currently loaded products.
  List<IapProduct> get products => List.unmodifiable(_products);

  IapStatus _status = IapStatus.idle;

  /// Current purchase status.
  IapStatus get status => _status;

  bool _available = false;

  /// Whether the native store is available.
  bool get isAvailable => _available;

  String? _lastError;

  /// Last error message, if any.
  String? get lastError => _lastError;

  @PostConstruct()
  void init() {
    final stream = InAppPurchase.instance.purchaseStream;
    _purchaseSubscription = stream.listen(
      _onPurchaseUpdated,
      onDone: () => _purchaseSubscription?.cancel(),
      onError: (Object error) {
        _logService.error(
          'Purchase stream error: $error',
          category: LogCategory.payment,
        );
      },
    );
    _logService.info('IapService initialized', category: LogCategory.payment);
  }

  /// Loads coin packages from backend, queries native store for pricing,
  /// and emits merged [IapProduct] list.
  Future<List<IapProduct>> loadProducts() async {
    _setStatus(IapStatus.loading);

    _available = await InAppPurchase.instance.isAvailable();
    if (!_available) {
      _logService.warning(
        'In-app purchases not available on this device',
        category: LogCategory.payment,
      );
      _setStatus(IapStatus.unavailable);
      return [];
    }

    final packages = await _walletRepository.listPackages();
    _logService.debug(
      'Loaded ${packages.length} packages from backend',
      category: LogCategory.payment,
    );

    final productIds = _extractProductIds(packages);
    if (productIds.isEmpty) {
      _logService.warning(
        'No product IDs for ${defaultTargetPlatform.name}',
        category: LogCategory.payment,
      );
      _products = [];
      _productsController.add(_products);
      _setStatus(IapStatus.idle);
      return [];
    }

    final response = await InAppPurchase.instance.queryProductDetails(
      productIds,
    );

    if (response.notFoundIDs.isNotEmpty) {
      _logService.warning(
        'Store products not found: ${response.notFoundIDs}',
        category: LogCategory.payment,
      );
    }

    if (response.error != null) {
      _logService.error(
        'Store query error: ${response.error!.message}',
        category: LogCategory.payment,
      );
    }

    _products = mergeProducts(packages, response.productDetails);
    _productsController.add(_products);
    _logService.info(
      'Loaded ${_products.length} store products',
      category: LogCategory.payment,
    );
    _setStatus(IapStatus.idle);
    return _products;
  }

  /// Initiates a consumable purchase for the given product.
  Future<bool> purchase(IapProduct product) async {
    if (!_available) {
      _lastError = 'Store not available';
      _setStatus(IapStatus.unavailable);
      return false;
    }

    _setStatus(IapStatus.pending);
    _logService.info(
      'Initiating purchase: ${product.storeProductId}',
      category: LogCategory.payment,
    );

    final storeProducts = await InAppPurchase.instance.queryProductDetails({
      product.storeProductId,
    });

    if (storeProducts.productDetails.isEmpty) {
      _lastError = 'Product not found in store';
      _setStatus(IapStatus.error);
      return false;
    }

    final param = PurchaseParam(
      productDetails: storeProducts.productDetails.first,
    );

    // autoConsume: true so Android consumes immediately, allowing re-purchase.
    // On iOS this parameter has no effect — completePurchase() is still needed.
    return InAppPurchase.instance.buyConsumable(
      purchaseParam: param,
      autoConsume: true,
    );
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchase in purchaseDetailsList) {
      _handlePurchase(purchase);
    }
  }

  Future<void> _handlePurchase(PurchaseDetails purchase) async {
    _logService.debug(
      'Purchase update: ${purchase.productID} — ${purchase.status}',
      category: LogCategory.payment,
    );

    switch (purchase.status) {
      case PurchaseStatus.pending:
        _setStatus(IapStatus.pending);
      case PurchaseStatus.purchased:
        await _verifyAndComplete(purchase);
      case PurchaseStatus.error:
        _lastError = purchase.error?.message ?? 'Unknown purchase error';
        _logService.error(
          'Purchase error: $_lastError',
          category: LogCategory.payment,
        );
        _setStatus(IapStatus.error);
        if (purchase.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchase);
        }
      case PurchaseStatus.canceled:
        _logService.info(
          'Purchase canceled: ${purchase.productID}',
          category: LogCategory.payment,
        );
        _setStatus(IapStatus.canceled);
      case PurchaseStatus.restored:
        if (purchase.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchase);
        }
    }
  }

  Future<void> _verifyAndComplete(PurchaseDetails purchase) async {
    _setStatus(IapStatus.verifying);
    _logService.info(
      'Verifying purchase: ${purchase.productID}',
      category: LogCategory.payment,
    );

    try {
      final product = _products.firstWhere(
        (p) => p.storeProductId == purchase.productID,
      );

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        await _walletRepository.purchaseApple(
          ApplePurchaseRequest(
            packageId: product.packageId,
            transactionId: purchase.purchaseID ?? '',
          ),
        );
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        await _walletRepository.purchaseGoogle(
          GooglePurchaseRequest(
            packageId: product.packageId,
            productId: purchase.productID,
            purchaseToken: purchase.verificationData.serverVerificationData,
          ),
        );
      }

      _logService.info(
        'Purchase verified: ${purchase.productID}',
        category: LogCategory.payment,
      );
      _setStatus(IapStatus.success);

      // Only complete after successful backend verification.
      // On failure, leaving it pending lets the store re-deliver on next launch.
      if (purchase.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchase);
      }
    } catch (e) {
      _lastError = 'Verification failed: $e';
      _logService.error(
        'Purchase verification failed — transaction kept pending for retry: $e',
        category: LogCategory.payment,
      );
      _setStatus(IapStatus.error);
    }
  }

  /// Extracts platform-specific product IDs from backend packages.
  @visibleForTesting
  Set<String> extractProductIds(List<CoinPackageResponse> packages) =>
      _extractProductIds(packages);

  Set<String> _extractProductIds(List<CoinPackageResponse> packages) {
    final ids = <String>{};
    for (final pkg in packages) {
      if (defaultTargetPlatform == TargetPlatform.iOS &&
          pkg.appleProductId != null) {
        ids.add(pkg.appleProductId!);
      } else if (defaultTargetPlatform == TargetPlatform.android &&
          pkg.googleProductId != null) {
        ids.add(pkg.googleProductId!);
      }
    }
    return ids;
  }

  /// Merges backend packages with native store product details.
  @visibleForTesting
  List<IapProduct> mergeProducts(
    List<CoinPackageResponse> packages,
    List<ProductDetails> storeProducts,
  ) {
    final storeMap = <String, ProductDetails>{};
    for (final sp in storeProducts) {
      storeMap[sp.id] = sp;
    }

    final result = <IapProduct>[];
    for (final pkg in packages) {
      final storeId = defaultTargetPlatform == TargetPlatform.iOS
          ? pkg.appleProductId
          : pkg.googleProductId;
      if (storeId == null) continue;

      final store = storeMap[storeId];
      if (store == null) continue;

      result.add(
        IapProduct(
          packageId: pkg.id,
          name: pkg.name,
          coins: pkg.coins,
          storeProductId: storeId,
          price: store.price,
          rawPrice: store.rawPrice,
          currencyCode: store.currencyCode,
        ),
      );
    }

    result.sort((a, b) => a.rawPrice.compareTo(b.rawPrice));
    return result;
  }

  void _setStatus(IapStatus newStatus) {
    _status = newStatus;
    _statusController.add(newStatus);
  }

  void dispose() {
    _purchaseSubscription?.cancel();
    _statusController.close();
    _productsController.close();
  }
}
