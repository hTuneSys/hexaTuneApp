// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/rest/wallet/wallet_repository.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/initiate_purchase_request.dart';
import 'package:hexatuneapp/src/core/rest/wallet/models/mobile_purchase_request.dart';

/// Dummy page for testing wallet endpoints.
class DummyWalletPage extends StatefulWidget {
  const DummyWalletPage({super.key});

  @override
  State<DummyWalletPage> createState() => _DummyWalletPageState();
}

class _DummyWalletPageState extends State<DummyWalletPage> {
  final _packageIdCtrl = TextEditingController();
  final _receiptDataCtrl = TextEditingController();
  String? _resultText;
  bool _isLoading = false;

  @override
  void dispose() {
    _packageIdCtrl.dispose();
    _receiptDataCtrl.dispose();
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
        padding: const EdgeInsets.all(16),
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

          // Packages
          Text('Coin Packages', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.shopping_bag),
            label: const Text('List Packages'),
            onPressed: _isLoading
                ? null
                : () => _run('List Packages', () async {
                    final repo = getIt<WalletRepository>();
                    final packages = await repo.listPackages();
                    if (packages.isEmpty) return 'No packages available';
                    return packages
                        .map(
                          (p) =>
                              '${p.name} (${p.id})\n'
                              '  ${p.coins} coins — '
                              '${p.priceCents} cents ${p.currency}',
                        )
                        .join('\n\n');
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

          // Purchase
          Text('Purchase', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _packageIdCtrl,
            decoration: const InputDecoration(
              labelText: 'Package ID',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _receiptDataCtrl,
            decoration: const InputDecoration(
              labelText: 'Receipt Data (Apple/Google)',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () => _run('Apple Purchase', () async {
                        final repo = getIt<WalletRepository>();
                        await repo.purchaseApple(
                          MobilePurchaseRequest(
                            packageId: _packageIdCtrl.text.trim(),
                            receiptData: _receiptDataCtrl.text.trim(),
                          ),
                        );
                        return 'Apple purchase recorded';
                      }),
                child: const Text('Apple'),
              ),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () => _run('Google Purchase', () async {
                        final repo = getIt<WalletRepository>();
                        await repo.purchaseGoogle(
                          MobilePurchaseRequest(
                            packageId: _packageIdCtrl.text.trim(),
                            receiptData: _receiptDataCtrl.text.trim(),
                          ),
                        );
                        return 'Google purchase recorded';
                      }),
                child: const Text('Google'),
              ),
              OutlinedButton(
                onPressed: _isLoading
                    ? null
                    : () => _run('Stripe Checkout', () async {
                        final repo = getIt<WalletRepository>();
                        final result = await repo.purchaseStripe(
                          InitiatePurchaseRequest(
                            packageId: _packageIdCtrl.text.trim(),
                          ),
                        );
                        return 'Session: ${result.sessionId}\n'
                            'URL: ${result.checkoutUrl ?? 'N/A'}';
                      }),
                child: const Text('Stripe'),
              ),
            ],
          ),
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
