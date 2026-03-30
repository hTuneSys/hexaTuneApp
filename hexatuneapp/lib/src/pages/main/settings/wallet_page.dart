// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/api_error_handler.dart';
import 'package:hexatuneapp/src/core/payment/iap_service.dart';
import 'package:hexatuneapp/src/core/payment/models/iap_product.dart';
import 'package:hexatuneapp/src/core/payment/models/iap_status.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/transaction_response.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/wallet_balance_response.dart';
import 'package:hexatuneapp/src/core/rest/wallet/wallet_repository.dart';
import 'package:hexatuneapp/src/core/router/route_names.dart';
import 'package:hexatuneapp/src/pages/shared/app_bottom_bar.dart';
import 'package:hexatuneapp/src/pages/shared/app_snack_bar.dart';

/// Production wallet page with balance, transactions, and store sections.
class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  WalletBalanceResponse? _balance;
  bool _balanceLoading = false;

  final List<TransactionResponse> _transactions = [];
  String? _nextCursor;
  bool _hasMore = false;
  bool _transactionsLoading = false;

  List<IapProduct> _products = [];
  IapStatus _iapStatus = IapStatus.idle;
  bool _productsLoading = false;

  StreamSubscription<IapStatus>? _statusSub;
  StreamSubscription<List<IapProduct>>? _productsSub;

  @override
  void initState() {
    super.initState();
    final iap = getIt<IapService>();
    _statusSub = iap.statusStream.listen((status) {
      if (mounted) setState(() => _iapStatus = status);
    });
    _productsSub = iap.productsStream.listen((products) {
      if (mounted) setState(() => _products = products);
    });
    _loadBalance();
    _loadProducts();
    _loadTransactions();
  }

  @override
  void dispose() {
    _statusSub?.cancel();
    _productsSub?.cancel();
    super.dispose();
  }

  Future<void> _refresh() async {
    await Future.wait([_loadBalance(), _loadProducts(), _loadTransactions()]);
  }

  Future<void> _loadBalance() async {
    setState(() => _balanceLoading = true);
    final log = getIt<LogService>();
    try {
      final repo = getIt<WalletRepository>();
      final balance = await repo.getBalance();
      if (mounted) setState(() => _balance = balance);
      log.devLog('Wallet balance loaded', category: LogCategory.ui);
    } catch (e) {
      log.devLog('Load balance failed: $e', category: LogCategory.ui);
      if (mounted) ApiErrorHandler.handle(context, e);
    } finally {
      if (mounted) setState(() => _balanceLoading = false);
    }
  }

  Future<void> _loadTransactions({bool loadMore = false}) async {
    setState(() => _transactionsLoading = true);
    final log = getIt<LogService>();
    try {
      final repo = getIt<WalletRepository>();
      final params = <String, dynamic>{
        if (loadMore && _nextCursor != null) 'cursor': _nextCursor,
      };
      final resp = await repo.listTransactions(
        params: params.isEmpty ? null : params,
      );
      if (mounted) {
        setState(() {
          if (!loadMore) _transactions.clear();
          _transactions.addAll(resp.data);
          _nextCursor = resp.nextCursor;
          _hasMore = resp.hasMore;
        });
      }
      log.devLog(
        'Transactions loaded: ${resp.data.length}',
        category: LogCategory.ui,
      );
    } catch (e) {
      log.devLog('Load transactions failed: $e', category: LogCategory.ui);
      if (mounted) ApiErrorHandler.handle(context, e);
    } finally {
      if (mounted) setState(() => _transactionsLoading = false);
    }
  }

  Future<void> _loadProducts() async {
    setState(() => _productsLoading = true);
    final log = getIt<LogService>();
    try {
      final iap = getIt<IapService>();
      await iap.loadProducts();
      log.devLog('Store products loaded', category: LogCategory.ui);
    } catch (e) {
      log.devLog('Load products failed: $e', category: LogCategory.ui);
      if (mounted) ApiErrorHandler.handle(context, e);
    } finally {
      if (mounted) setState(() => _productsLoading = false);
    }
  }

  Future<void> _purchase(IapProduct product) async {
    final log = getIt<LogService>();
    final l10n = AppLocalizations.of(context)!;
    try {
      final iap = getIt<IapService>();
      final ok = await iap.purchase(product);
      if (!ok) {
        if (mounted) {
          AppSnackBar.error(
            context,
            message: iap.lastError ?? l10n.walletPurchase,
          );
        }
        return;
      }
      if (mounted) {
        AppSnackBar.success(context, message: l10n.walletPurchaseInitiated);
      }
      log.devLog(
        'Purchase initiated: ${product.name}',
        category: LogCategory.ui,
      );
    } catch (e) {
      log.devLog('Purchase failed: $e', category: LogCategory.ui);
      if (mounted) ApiErrorHandler.handle(context, e);
    }
  }

  bool get _isPurchaseBusy =>
      _iapStatus == IapStatus.pending || _iapStatus == IapStatus.verifying;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(RouteNames.settings),
        ),
        title: Text(l10n.walletTitle),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            16,
            16,
            16,
            16 + AppBottomBar.scrollPadding,
          ),
          children: [
            _buildBalanceSection(l10n, theme),
            const SizedBox(height: 24),
            _buildStoreSection(l10n, theme),
            const SizedBox(height: 24),
            _buildTransactionsSection(l10n, theme),
          ],
        ),
      ),
    );
  }

  // -- Balance section -------------------------------------------------------

  Widget _buildBalanceSection(AppLocalizations l10n, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.walletBalanceSection,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (_balanceLoading && _balance == null)
          const Center(child: CircularProgressIndicator())
        else if (_balance != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.walletBalanceCoins(_balance!.balanceCoins),
                          style: theme.textTheme.headlineSmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildBalanceRow(
                    theme,
                    icon: Icons.arrow_downward,
                    label: l10n.walletPurchased,
                    value: _balance!.totalPurchased.toString(),
                  ),
                  const SizedBox(height: 4),
                  _buildBalanceRow(
                    theme,
                    icon: Icons.arrow_upward,
                    label: l10n.walletSpent,
                    value: _balance!.totalSpent.toString(),
                  ),
                ],
              ),
            ),
          )
        else
          FilledButton.tonalIcon(
            onPressed: _balanceLoading ? null : _loadBalance,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.walletGetBalance),
          ),
      ],
    );
  }

  Widget _buildBalanceRow(
    ThemeData theme, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.outline),
        const SizedBox(width: 8),
        Text(label, style: theme.textTheme.bodyMedium),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // -- Transactions section --------------------------------------------------

  Widget _buildTransactionsSection(AppLocalizations l10n, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.walletTransactionsSection,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (_transactionsLoading && _transactions.isEmpty)
          const Center(child: CircularProgressIndicator())
        else if (_transactions.isEmpty)
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.receipt_long,
                  size: 64,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.walletNoTransactions,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.walletTransactionCount(0),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          )
        else
          ..._transactions.map((tx) => _buildTransactionCard(tx, l10n, theme)),
        if (_hasMore)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextButton(
                onPressed: _transactionsLoading
                    ? null
                    : () => _loadTransactions(loadMore: true),
                child: Text(l10n.walletLoadMore),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTransactionCard(
    TransactionResponse tx,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    tx.transactionType,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                Text(
                  '${tx.amountCoins}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              tx.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildChip(theme, tx.status),
                const Spacer(),
                Text(
                  l10n.walletBalanceAfter(tx.balanceAfter),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(ThemeData theme, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }

  // -- Store section ---------------------------------------------------------

  Widget _buildStoreSection(AppLocalizations l10n, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.walletStoreSection,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (_productsLoading && _products.isEmpty)
          const Center(child: CircularProgressIndicator())
        else if (_products.isEmpty)
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.store_outlined,
                  size: 64,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.walletNoProducts,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          )
        else
          ..._products.map(
            (product) => _buildProductCard(product, l10n, theme),
          ),
      ],
    );
  }

  Widget _buildProductCard(
    IapProduct product,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            Icons.shopping_bag_outlined,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(product.name),
        subtitle: Text(
          l10n.walletBalanceCoins(product.coins),
          style: theme.textTheme.bodySmall,
        ),
        trailing: FilledButton(
          onPressed: _isPurchaseBusy ? null : () => _purchase(product),
          child: Text(product.price),
        ),
      ),
    );
  }
}
