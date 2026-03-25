// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
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
import 'package:hexatuneapp/src/core/rest/formula/models/formula_detail_response.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/update_formula_item_quantity_request.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/update_formula_request.dart';
import 'package:hexatuneapp/src/core/rest/inventory/inventory_repository.dart';
import 'package:hexatuneapp/src/core/rest/inventory/models/inventory_response.dart';
import 'package:hexatuneapp/src/pages/shared/app_snack_bar.dart';
import 'package:hexatuneapp/src/core/network/api_error_handler.dart';
import 'package:hexatuneapp/src/pages/shared/app_bottom_bar.dart';

/// Tracks an item in the edit page — either existing or newly added.
class _EditItem {
  _EditItem({
    required this.inventoryId,
    required this.inventoryName,
    required this.quantity,
    this.existingItemId,
    this.originalQuantity,
    this.isNew = false,
  });

  final String inventoryId;
  final String inventoryName;
  int quantity;
  final String? existingItemId;
  final int? originalQuantity;
  final bool isNew;
}

/// Page for editing an existing formula with its items.
class FormulaEditPage extends StatefulWidget {
  const FormulaEditPage({required this.formulaId, super.key});

  final String formulaId;

  @override
  State<FormulaEditPage> createState() => _FormulaEditPageState();
}

class _FormulaEditPageState extends State<FormulaEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _labelInputCtrl = TextEditingController();
  final _inventorySearchCtrl = TextEditingController();
  final List<String> _labels = [];
  final _labelFocusNode = FocusNode();
  List<String> _availableLabels = [];
  final List<_EditItem> _items = [];
  final Set<String> _removedItemIds = {};
  List<InventoryResponse> _allInventories = [];
  List<InventoryResponse> _filteredInventories = [];
  FormulaDetailResponse? _formula;
  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _showInventorySuggestions = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadLabels();
  }

  @override
  void dispose() {
    _labelFocusNode.dispose();
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _labelInputCtrl.dispose();
    _inventorySearchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadLabels() async {
    try {
      final labels = await getIt<FormulaRepository>().listLabels();
      if (mounted) setState(() => _availableLabels = labels);
    } catch (_) {}
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

      // Build inventory name lookup
      final invMap = <String, String>{};
      for (final inv in inventories) {
        invMap[inv.id] = inv.name;
      }

      final editItems = detail.items
          .map(
            (item) => _EditItem(
              inventoryId: item.inventoryId,
              inventoryName: invMap[item.inventoryId] ?? item.inventoryId,
              quantity: item.quantity,
              existingItemId: item.id,
              originalQuantity: item.quantity,
            ),
          )
          .toList();

      if (mounted) {
        setState(() {
          _formula = detail;
          _nameCtrl.text = detail.name;
          _labels
            ..clear()
            ..addAll(detail.labels);
          _items
            ..clear()
            ..addAll(editItems);
          _allInventories = inventories;
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

  int get _totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);

  void _filterInventories(String query) {
    final addedIds = _items.map((i) => i.inventoryId).toSet();
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
    if (_items.any((i) => i.inventoryId == inv.id)) return;
    setState(() {
      _items.add(
        _EditItem(
          inventoryId: inv.id,
          inventoryName: inv.name,
          quantity: 1,
          isNew: true,
        ),
      );
      _inventorySearchCtrl.clear();
      _showInventorySuggestions = false;
    });
  }

  void _removeItem(int index) {
    final item = _items[index];
    if (item.existingItemId != null) {
      _removedItemIds.add(item.existingItemId!);
    }
    setState(() => _items.removeAt(index));
  }

  void _updateQuantity(int index, int quantity) {
    if (quantity < 1) return;
    final otherTotal = _totalQuantity - _items[index].quantity;
    if (otherTotal + quantity > FormulaConstants.maxTotalQuantity) return;
    setState(() => _items[index].quantity = quantity);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final l10n = AppLocalizations.of(context)!;
    try {
      final repo = getIt<FormulaRepository>();

      // Update formula metadata
      await repo.update(
        widget.formulaId,
        UpdateFormulaRequest(
          name: _nameCtrl.text.trim(),
          labels: _labels.isEmpty ? null : _labels,
        ),
      );

      // Remove deleted items
      for (final itemId in _removedItemIds) {
        await repo.removeItem(widget.formulaId, itemId);
      }

      // Add new items
      final newItems = _items.where((i) => i.isNew).toList();
      if (newItems.isNotEmpty) {
        await repo.addItems(
          widget.formulaId,
          AddFormulaItemsRequest(
            items: newItems
                .map(
                  (i) => AddFormulaItemEntry(
                    inventoryId: i.inventoryId,
                    quantity: i.quantity,
                  ),
                )
                .toList(),
          ),
        );
      }

      // Update changed quantities on existing items
      for (final item in _items) {
        if (!item.isNew &&
            item.existingItemId != null &&
            item.quantity != item.originalQuantity &&
            !_removedItemIds.contains(item.existingItemId)) {
          await repo.updateItemQuantity(
            widget.formulaId,
            item.existingItemId!,
            UpdateFormulaItemQuantityRequest(quantity: item.quantity),
          );
        }
      }

      if (mounted) {
        AppSnackBar.success(context, message: l10n.formulaUpdated);
        context.pop(true);
      }
    } catch (e) {
      getIt<LogService>().devLog(
        'Update formula failed: $e',
        category: LogCategory.ui,
      );
      if (mounted) {
        AppSnackBar.error(context, message: _formatError(e));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.formulaDeleteConfirm(_formula?.name ?? '')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              elevation: 1,
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _isSubmitting = true);
    try {
      await getIt<FormulaRepository>().delete(widget.formulaId);
      if (mounted) {
        AppSnackBar.success(context, message: l10n.formulaDeleted);
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        ApiErrorHandler.handle(context, e);
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String _formatError(Object error) {
    if (error is DioException) {
      if (error.response?.statusCode == 409) {
        return AppLocalizations.of(context)!.formulaInventoryDuplicate;
      }
    }
    return error.toString();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.formulaEdit)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                16 + AppBottomBar.scrollPadding,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.formulaName,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Material(
                      elevation: 1,
                      borderRadius: BorderRadius.circular(12),
                      color: theme.colorScheme.surfaceContainerLow,
                      child: TextFormField(
                        controller: _nameCtrl,
                        decoration: InputDecoration(
                          hintText: l10n.formulaNameHint,
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? l10n.formulaNameRequired
                            : null,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.formulaDescription,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Material(
                      elevation: 1,
                      borderRadius: BorderRadius.circular(12),
                      color: theme.colorScheme.surfaceContainerLow,
                      child: TextFormField(
                        controller: _descCtrl,
                        decoration: InputDecoration(
                          hintText: l10n.formulaDescriptionHint,
                        ),
                        maxLines: 3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.formulaLabels,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RawAutocomplete<String>(
                      textEditingController: _labelInputCtrl,
                      focusNode: _labelFocusNode,
                      optionsBuilder: (textEditingValue) {
                        final filtered = _availableLabels
                            .where((l) => !_labels.contains(l))
                            .where(
                              (l) =>
                                  textEditingValue.text.isEmpty ||
                                  l.toLowerCase().contains(
                                    textEditingValue.text.toLowerCase(),
                                  ),
                            )
                            .toList();
                        return filtered;
                      },
                      onSelected: (String selection) {
                        if (!_labels.contains(selection)) {
                          setState(() => _labels.add(selection));
                        }
                        _labelInputCtrl.clear();
                      },
                      fieldViewBuilder:
                          (context, controller, focusNode, onFieldSubmitted) {
                            return Material(
                              elevation: 1,
                              borderRadius: BorderRadius.circular(12),
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerLow,
                              child: TextField(
                                controller: controller,
                                focusNode: focusNode,
                                decoration: InputDecoration(
                                  hintText: l10n.formulaAddLabel,
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: _addLabel,
                                  ),
                                ),
                                onSubmitted: (_) => _addLabel(),
                              ),
                            );
                          },
                      optionsViewBuilder: (context, onSelected, options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(12),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 200),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: options.length,
                                itemBuilder: (context, index) {
                                  final option = options.elementAt(index);
                                  return ListTile(
                                    title: Text(option),
                                    onTap: () => onSelected(option),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
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
                    Text(
                      l10n.formulaAddInventory,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Material(
                      elevation: 1,
                      borderRadius: BorderRadius.circular(12),
                      color: theme.colorScheme.surfaceContainerLow,
                      child: TextField(
                        controller: _inventorySearchCtrl,
                        decoration: InputDecoration(
                          hintText: l10n.formulaSearchInventory,
                          prefixIcon: const Icon(Icons.search),
                        ),
                        onChanged: _filterInventories,
                      ),
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
                    if (_items.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      ..._items.asMap().entries.map((entry) {
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
                                  item.inventoryName,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: theme.colorScheme.outline,
                                ),
                                onPressed: () => _removeItem(i),
                                visualDensity: VisualDensity.compact,
                              ),
                              Text(
                                l10n.formulaItemCount,
                                style: theme.textTheme.bodySmall,
                              ),
                              const SizedBox(width: 4),
                              SizedBox(
                                width: 48,
                                child: Material(
                                  elevation: 1,
                                  borderRadius: BorderRadius.circular(12),
                                  color: theme.colorScheme.surfaceContainerLow,
                                  child: TextField(
                                    controller: TextEditingController(
                                      text: '${item.quantity}',
                                    ),
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(
                                      isDense: true,
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
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: _isSubmitting ? null : _delete,
                            style: FilledButton.styleFrom(
                              elevation: 1,
                              backgroundColor: theme.colorScheme.error,
                              minimumSize: const Size.fromHeight(48),
                            ),
                            child: Text(l10n.delete),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: FilledButton(
                            onPressed: _isSubmitting ? null : _save,
                            style: FilledButton.styleFrom(
                              elevation: 1,
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
                                : Text(l10n.save),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
