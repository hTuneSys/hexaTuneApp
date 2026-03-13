// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/config/api_endpoints.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_client.dart';
import 'package:hexatuneapp/src/core/network/models/paginated_response.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/checkout_response.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/coin_package_response.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/initiate_purchase_request.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/mobile_purchase_request.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/transaction_response.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/wallet_balance_response.dart';

/// Repository for wallet and in-app purchase API calls.
@singleton
class WalletRepository {
  WalletRepository(this._apiClient, this._logService);

  final ApiClient _apiClient;
  final LogService _logService;

  Dio get _dio => _apiClient.dio;

  /// GET /api/v1/wallet/balance
  Future<WalletBalanceResponse> getBalance() async {
    _logService.debug('GET wallet/balance', category: LogCategory.network);
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.walletBalance,
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Wallet balance response body is null',
      );
    }
    return WalletBalanceResponse.fromJson(data);
  }

  /// GET /api/v1/wallet/packages
  Future<List<CoinPackageResponse>> listPackages() async {
    _logService.debug('GET wallet/packages', category: LogCategory.network);
    final response = await _dio.get<List<dynamic>>(ApiEndpoints.walletPackages);
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Wallet packages response body is null',
      );
    }
    return data
        .map((e) => CoinPackageResponse.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /api/v1/wallet/transactions
  Future<PaginatedResponse<TransactionResponse>> listTransactions({
    Map<String, dynamic>? params,
  }) async {
    _logService.debug('GET wallet/transactions', category: LogCategory.network);
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.walletTransactions,
      queryParameters: params,
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Wallet transactions response body is null',
      );
    }
    return PaginatedResponse.fromJson(
      data,
      (item) => TransactionResponse.fromJson(item! as Map<String, dynamic>),
    );
  }

  /// POST /api/v1/wallet/purchase/apple
  Future<void> purchaseApple(MobilePurchaseRequest request) async {
    _logService.debug(
      'POST wallet/purchase/apple',
      category: LogCategory.network,
    );
    await _dio.post(ApiEndpoints.walletPurchaseApple, data: request.toJson());
  }

  /// POST /api/v1/wallet/purchase/google
  Future<void> purchaseGoogle(MobilePurchaseRequest request) async {
    _logService.debug(
      'POST wallet/purchase/google',
      category: LogCategory.network,
    );
    await _dio.post(ApiEndpoints.walletPurchaseGoogle, data: request.toJson());
  }

  /// POST /api/v1/wallet/purchase/stripe
  Future<CheckoutResponse> purchaseStripe(
    InitiatePurchaseRequest request,
  ) async {
    _logService.debug(
      'POST wallet/purchase/stripe',
      category: LogCategory.network,
    );
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.walletPurchaseStripe,
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Stripe checkout response body is null',
      );
    }
    return CheckoutResponse.fromJson(data);
  }
}
