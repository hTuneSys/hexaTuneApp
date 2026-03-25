// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';
import 'package:hexatuneapp/src/core/rest/formula/formula_repository.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/formula_detail_response.dart';
import 'package:hexatuneapp/src/core/rest/inventory/inventory_repository.dart';
import 'package:hexatuneapp/src/core/rest/inventory/models/inventory_response.dart';
import 'package:hexatuneapp/src/core/network/api_error_handler.dart';
import 'package:hexatuneapp/src/pages/shared/app_bottom_bar.dart';

/// Read-only page for viewing a formula's details and its items.
class FormulaViewPage extends StatefulWidget {
  const FormulaViewPage({required this.formulaId, super.key});

  final String formulaId;

  @override
  State<FormulaViewPage> createState() => _FormulaViewPageState();
}

class _FormulaViewPageState extends State<FormulaViewPage> {
  bool _isLoading = true;
  FormulaDetailResponse? _formula;
  Map<String, String> _inventoryNames = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final formulaRepo = getIt<FormulaRepository>();
      final invRepo = getIt<InventoryRepository>();
      final results = await Future.wait([
        formulaRepo.getById(widget.formulaId),
        invRepo.list(params: const PaginationParams(limit: 100)),
      ]);
      final detail = results[0] as FormulaDetailResponse;
      final invResp = results[1];
      final inventories = (invResp as dynamic).data as List<InventoryResponse>;

      final nameMap = <String, String>{};
      for (final inv in inventories) {
        nameMap[inv.id] = inv.name;
      }

      if (mounted) {
        setState(() {
          _formula = detail;
          _inventoryNames = nameMap;
          _isLoading = false;
        });
      }
    } catch (e) {
      getIt<LogService>().devLog(
        'Failed to load formula: $e',
        category: LogCategory.ui,
      );
      if (mounted) {
        ApiErrorHandler.handle(context, e);
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.formulaView)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _formula == null
          ? Center(
              child: Text(
                l10n.formulaEmptyTitle,
                style: theme.textTheme.bodyLarge,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                16 + AppBottomBar.scrollPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.formulaName,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        _formula!.name,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.formulaDescription,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        '—',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.formulaLabels,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_formula!.labels.isEmpty)
                    Text(
                      l10n.formulaNoLabels,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: _formula!.labels
                          .map((l) => Chip(label: Text(l), onDeleted: null))
                          .toList(),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.formulaAddedInventory,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_formula!.items.isEmpty)
                    Text(
                      '—',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    )
                  else
                    ..._formula!.items.map((item) {
                      final name =
                          _inventoryNames[item.inventoryId] ?? item.inventoryId;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              l10n.formulaItemCount,
                              style: theme.textTheme.bodySmall,
                            ),
                            const SizedBox(width: 4),
                            Container(
                              width: 48,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: theme.colorScheme.outline,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${item.quantity}',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
    );
  }
}
