// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/payment/iap_service.dart';
import 'package:hexatuneapp/src/core/payment/models/iap_product.dart';
import 'package:hexatuneapp/src/core/payment/models/iap_status.dart';
import 'package:hexatuneapp/src/core/rest/wallet/wallet_repository.dart';
import 'package:hexatuneapp/src/pages/shared/app_bottom_bar.dart';

/// Dummy page for testing wallet and in-app purchase flows.
class DummyWalletPage extends StatefulWidget {
  const DummyWalletPage({super.key});

  @override
  State<DummyWalletPage> createState() => _DummyWalletPageState();
}

class _DummyWalletPageState extends State<DummyWalletPage> {
  String? _resultText;
  bool _isLoading = false;
  List<IapProduct> _products = [];
  IapStatus _iapStatus = IapStatus.idle;
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
  }

  @override
  void dispose() {
    _statusSub?.cancel();
    _productsSub?.cancel();
    super.dispose();
  }

  Future<void> _run(String label, Future<String> Function() action) async {
    setState(() {
      _isLoading = true;
      _resultText = null;
    });
    final log = getIt<LogService>();
    try {
      log.devLog('→ $label', category: LogCategory.ui);
      final result = await action();
      if (mounted) setState(() => _resultText = '✓ $label\n$result');
    } catch (e) {
      log.devLog('✗ $label failed: $e', category: LogCategory.ui);
      if (mounted) setState(() => _resultText = '✗ $label\n$e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          16 + AppBottomBar.scrollPadding,
        ),
        children: [
          // Balance
          Text('Balance', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.account_balance_wallet),
            label: const Text('Get Balance'),
            onPressed: _isLoading
                ? null
                : () => _run('Get Balance', () async {
                    final repo = getIt<WalletRepository>();
                    final balance = await repo.getBalance();
                    return 'Tenant: ${balance.tenantId}\n'
                        'Balance: ${balance.balanceCoins} coins\n'
                        'Purchased: ${balance.totalPurchased}\n'
                        'Spent: ${balance.totalSpent}';
                  }),
          ),
          const Divider(height: 32),

          // Transactions
          Text('Transactions', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.receipt_long),
            label: const Text('List Transactions'),
            onPressed: _isLoading
                ? null
                : () => _run('List Transactions', () async {
                    final repo = getIt<WalletRepository>();
                    final result = await repo.listTransactions();
                    if (result.data.isEmpty) return 'No transactions';
                    final buf = StringBuffer();
                    buf.writeln('${result.data.length} transactions');
                    buf.writeln('Has more: ${result.hasMore}');
                    for (final tx in result.data) {
                      buf.writeln(
                        '\n${tx.transactionType}: ${tx.amountCoins} coins '
                        '(${tx.status})',
                      );
                      buf.writeln('  Balance after: ${tx.balanceAfter}');
                      buf.writeln('  ${tx.description}');
                    }
                    return buf.toString();
                  }),
          ),
          const Divider(height: 32),

          // Store Products
          Text('Store Products', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text('Status: ${_iapStatus.name}', style: theme.textTheme.bodySmall),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Load Products'),
            onPressed: _isLoading
                ? null
                : () => _run('Load Products', () async {
                    final iap = getIt<IapService>();
                    final products = await iap.loadProducts();
                    if (products.isEmpty) {
                      return 'No products available\n'
                          'Store available: ${iap.isAvailable}';
                    }
                    return products
                        .map((p) => '${p.name}: ${p.coins} coins — ${p.price}')
                        .join('\n');
                  }),
          ),
          const SizedBox(height: 8),

          // Product list with buy buttons
          if (_products.isNotEmpty) ...[
            for (final product in _products)
              Card(
                child: ListTile(
                  title: Text(product.name),
                  subtitle: Text('${product.coins} coins'),
                  trailing: ElevatedButton(
                    onPressed:
                        (_isLoading ||
                            _iapStatus == IapStatus.pending ||
                            _iapStatus == IapStatus.verifying)
                        ? null
                        : () => _run('Purchase ${product.name}', () async {
                            final iap = getIt<IapService>();
                            final ok = await iap.purchase(product);
                            if (!ok) {
                              return 'Purchase initiation failed: '
                                  '${iap.lastError ?? "unknown"}';
                            }
                            return 'Purchase initiated — '
                                'waiting for store confirmation';
                          }),
                    child: Text(product.price),
                  ),
                ),
              ),
          ],
          const Divider(height: 32),

          // Result display
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          if (_resultText != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SelectableText(
                  _resultText!,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
