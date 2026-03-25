// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';
import 'package:hexatuneapp/src/core/rest/formula/formula_constants.dart';
import 'package:hexatuneapp/src/core/rest/formula/formula_repository.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/add_formula_item_entry.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/add_formula_items_request.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/create_formula_request.dart';
import 'package:hexatuneapp/src/core/rest/inventory/inventory_repository.dart';
import 'package:hexatuneapp/src/core/rest/inventory/models/inventory_response.dart';

/// Local model for inventory items being added to a formula before creation.
class _PendingItem {
  _PendingItem({required this.inventory});

  final InventoryResponse inventory;
  int quantity = 1;
}

/// Page for creating a new formula with inventory items.
class FormulaCreatePage extends StatefulWidget {
  const FormulaCreatePage({super.key});

  @override
  State<FormulaCreatePage> createState() => _FormulaCreatePageState();
}

class _FormulaCreatePageState extends State<FormulaCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _labelInputCtrl = TextEditingController();
  final _inventorySearchCtrl = TextEditingController();
  final List<String> _labels = [];
  final List<_PendingItem> _pendingItems = [];
  List<InventoryResponse> _allInventories = [];
  List<InventoryResponse> _filteredInventories = [];
  bool _isSubmitting = false;
  bool _showInventorySuggestions = false;

  @override
  void initState() {
    super.initState();
    _loadInventories();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _labelInputCtrl.dispose();
    _inventorySearchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadInventories() async {
    try {
      final invRepo = getIt<InventoryRepository>();
      final resp = await invRepo.list(
        params: const PaginationParams(limit: 100),
      );
      if (mounted) {
        setState(() => _allInventories = resp.data);
      }
    } catch (e) {
      getIt<LogService>().devLog(
        'Failed to load inventories: $e',
        category: LogCategory.ui,
      );
    }
  }

  void _addLabel() {
    final label = _labelInputCtrl.text.trim();
    if (label.isNotEmpty && !_labels.contains(label)) {
      setState(() => _labels.add(label));
      _labelInputCtrl.clear();
    }
  }

  void _removeLabel(String label) {
    setState(() => _labels.remove(label));
  }

  int get _totalQuantity =>
      _pendingItems.fold(0, (sum, item) => sum + item.quantity);

  void _filterInventories(String query) {
    final addedIds = _pendingItems.map((i) => i.inventory.id).toSet();
    final q = query.toLowerCase();
    setState(() {
      _filteredInventories = _allInventories
          .where(
            (inv) =>
                !addedIds.contains(inv.id) &&
                inv.name.toLowerCase().contains(q),
          )
          .toList();
      _showInventorySuggestions =
          query.isNotEmpty && _filteredInventories.isNotEmpty;
    });
  }

  void _addInventoryItem(InventoryResponse inv) {
    if (_pendingItems.any((i) => i.inventory.id == inv.id)) return;
    setState(() {
      _pendingItems.add(_PendingItem(inventory: inv));
      _inventorySearchCtrl.clear();
      _showInventorySuggestions = false;
    });
  }

  void _removeInventoryItem(int index) {
    setState(() => _pendingItems.removeAt(index));
  }

  void _updateQuantity(int index, int quantity) {
    if (quantity < 1) return;
    final otherTotal = _totalQuantity - _pendingItems[index].quantity;
    if (otherTotal + quantity > FormulaConstants.maxTotalQuantity) return;
    setState(() => _pendingItems[index].quantity = quantity);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final l10n = AppLocalizations.of(context)!;
    try {
      final repo = getIt<FormulaRepository>();
      final formula = await repo.create(
        CreateFormulaRequest(
          name: _nameCtrl.text.trim(),
          labels: _labels.isEmpty ? null : _labels,
        ),
      );

      if (_pendingItems.isNotEmpty) {
        await repo.addItems(
          formula.id,
          AddFormulaItemsRequest(
            items: _pendingItems
                .asMap()
                .entries
                .map(
                  (e) => AddFormulaItemEntry(
                    inventoryId: e.value.inventory.id,
                    quantity: e.value.quantity,
                    sortOrder: e.key,
                  ),
                )
                .toList(),
          ),
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.formulaCreated),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        context.pop(true);
      }
    } catch (e) {
      getIt<LogService>().devLog(
        'Create formula failed: $e',
        category: LogCategory.ui,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.formulaCreate)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.formulaName, style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  hintText: l10n.formulaNameHint,
                  border: const OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? l10n.formulaNameRequired
                    : null,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              Text(l10n.formulaDescription, style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descCtrl,
                decoration: InputDecoration(
                  hintText: l10n.formulaDescriptionHint,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Text(l10n.formulaLabels, style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              TextField(
                controller: _labelInputCtrl,
                decoration: InputDecoration(
                  hintText: l10n.formulaAddLabel,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addLabel,
                  ),
                ),
                onSubmitted: (_) => _addLabel(),
              ),
              if (_labels.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: _labels
                      .map(
                        (label) => Chip(
                          label: Text(label),
                          onDeleted: () => _removeLabel(label),
                        ),
                      )
                      .toList(),
                ),
              ],
              const SizedBox(height: 16),
              Text(l10n.formulaAddInventory, style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              TextField(
                controller: _inventorySearchCtrl,
                decoration: InputDecoration(
                  hintText: l10n.formulaSearchInventory,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: _filterInventories,
              ),
              if (_showInventorySuggestions)
                Container(
                  constraints: const BoxConstraints(maxHeight: 150),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.outline),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredInventories.length,
                    itemBuilder: (ctx, i) {
                      final inv = _filteredInventories[i];
                      return ListTile(
                        dense: true,
                        leading: Icon(
                          Icons.inventory_2_outlined,
                          color: theme.colorScheme.primary,
                        ),
                        title: Text(inv.name),
                        onTap: () => _addInventoryItem(inv),
                      );
                    },
                  ),
                ),
              if (_pendingItems.isNotEmpty) ...[
                const SizedBox(height: 8),
                ..._pendingItems.asMap().entries.map((entry) {
                  final i = entry.key;
                  final item = entry.value;
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
                            item.inventory.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: theme.colorScheme.outline,
                          ),
                          onPressed: () => _removeInventoryItem(i),
                          visualDensity: VisualDensity.compact,
                        ),
                        Text(
                          l10n.formulaItemCount,
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(width: 4),
                        SizedBox(
                          width: 48,
                          child: TextField(
                            controller: TextEditingController(
                              text: '${item.quantity}',
                            ),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 8,
                              ),
                            ),
                            onChanged: (v) {
                              final qty = int.tryParse(v);
                              if (qty != null) _updateQuantity(i, qty);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isSubmitting ? null : _submit,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: _isSubmitting
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.colorScheme.onPrimary,
                        ),
                      )
                    : Text(l10n.create),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
