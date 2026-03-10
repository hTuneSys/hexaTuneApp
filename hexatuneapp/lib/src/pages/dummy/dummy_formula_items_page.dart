// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/rest/formula/formula_constants.dart';
import 'package:hexatuneapp/src/core/rest/formula/formula_repository.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/add_formula_item_entry.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/add_formula_items_request.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/formula_detail_response.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/formula_item_response.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/reorder_entry.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/reorder_formula_items_request.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/update_formula_item_quantity_request.dart';
import 'package:hexatuneapp/src/core/rest/inventory/inventory_repository.dart';
import 'package:hexatuneapp/src/core/rest/inventory/models/inventory_response.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';

/// Dummy page for testing formula item management endpoints.
class DummyFormulaItemsPage extends StatefulWidget {
  const DummyFormulaItemsPage({required this.formulaId, super.key});

  final String formulaId;

  @override
  State<DummyFormulaItemsPage> createState() => _DummyFormulaItemsPageState();
}

class _DummyFormulaItemsPageState extends State<DummyFormulaItemsPage> {
  FormulaDetailResponse? _detail;
  List<FormulaItemResponse> _items = [];
  bool _isLoading = false;
  bool _orderChanged = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _orderChanged = false;
    });
    final log = getIt<LogService>();
    try {
      final repo = getIt<FormulaRepository>();
      final detail = await repo.getById(widget.formulaId);
      if (mounted) {
        setState(() {
          _detail = detail;
          _items = List.of(detail.items)
            ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        });
      }
      log.devLog(
        '✓ Formula detail loaded: ${detail.items.length} items',
        category: LogCategory.ui,
      );
    } catch (e) {
      log.devLog('✗ Load formula detail failed: $e', category: LogCategory.ui);
      if (mounted) _showMessage(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<List<InventoryResponse>> _fetchInventories() async {
    final invRepo = getIt<InventoryRepository>();
    final resp = await invRepo.list(params: const PaginationParams(limit: 100));
    return resp.data;
  }

  Future<void> _addItems() async {
    List<InventoryResponse> inventories = [];
    try {
      inventories = await _fetchInventories();
    } catch (e) {
      if (mounted) {
        _showMessage('Failed to load inventories: $e', isError: true);
      }
      return;
    }
    if (!mounted) return;

    // Filter out inventories already present in formula items (unique rule)
    final existingInvIds = _items.map((i) => i.inventoryId).toSet();
    final availableInventories = inventories
        .where((inv) => !existingInvIds.contains(inv.id))
        .toList();

    if (availableInventories.isEmpty) {
      _showMessage(
        'All inventory items are already added to this formula',
        isError: true,
      );
      return;
    }

    final remaining = FormulaValidation.remainingCapacity(_items);
    if (remaining <= 0) {
      _showMessage(
        'Total quantity limit reached '
        '(${FormulaConstants.maxTotalQuantity})',
        isError: true,
      );
      return;
    }

    String? selectedInventoryId;
    final quantityCtrl = TextEditingController(text: '1');
    final timeMsCtrl = TextEditingController(text: '1000');
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: selectedInventoryId,
                decoration: const InputDecoration(
                  labelText: 'Inventory *',
                  border: OutlineInputBorder(),
                ),
                items: availableInventories
                    .map(
                      (inv) => DropdownMenuItem(
                        value: inv.id,
                        child: Text(inv.name),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  setDialogState(() => selectedInventoryId = val);
                },
                hint: const Text('Select an inventory'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: quantityCtrl,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: const OutlineInputBorder(),
                  helperText: 'Remaining capacity: $remaining',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: timeMsCtrl,
                decoration: const InputDecoration(
                  labelText: 'Time (ms)',
                  border: OutlineInputBorder(),
                  helperText: 'Optional, defaults to 1000ms',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
    if (result != true || selectedInventoryId == null) return;

    final qty = int.tryParse(quantityCtrl.text.trim()) ?? 1;
    if (!FormulaValidation.canAddQuantity(_items, qty)) {
      _showMessage(
        'Cannot add: total quantity would exceed '
        '${FormulaConstants.maxTotalQuantity} '
        '(remaining: $remaining)',
        isError: true,
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final repo = getIt<FormulaRepository>();
      final timeMsValue = int.tryParse(timeMsCtrl.text.trim());
      await repo.addItems(
        widget.formulaId,
        AddFormulaItemsRequest(
          items: [
            AddFormulaItemEntry(
              inventoryId: selectedInventoryId!,
              quantity: qty,
              timeMs: timeMsValue,
            ),
          ],
        ),
      );
      if (mounted) {
        _showMessage('Item added');
        _load();
      }
    } catch (e) {
      if (mounted) _showMessage(_formatError(e), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateQuantity(FormulaItemResponse item) async {
    final maxForItem =
        FormulaValidation.remainingCapacity(_items) + item.quantity;
    final qtyCtrl = TextEditingController(text: '${item.quantity}');
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Update Quantity'),
        content: TextField(
          controller: qtyCtrl,
          decoration: InputDecoration(
            labelText: 'Quantity',
            border: const OutlineInputBorder(),
            helperText: 'Max allowed for this item: $maxForItem',
          ),
          keyboardType: TextInputType.number,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Update'),
          ),
        ],
      ),
    );
    if (result != true) return;

    final qty = int.tryParse(qtyCtrl.text.trim());
    if (qty == null || qty < 1) {
      _showMessage('Quantity must be at least 1', isError: true);
      return;
    }

    if (!FormulaValidation.canUpdateQuantity(_items, item.id, qty)) {
      _showMessage(
        'Cannot update: total quantity would exceed '
        '${FormulaConstants.maxTotalQuantity} '
        '(max for this item: $maxForItem)',
        isError: true,
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final repo = getIt<FormulaRepository>();
      await repo.updateItemQuantity(
        widget.formulaId,
        item.id,
        UpdateFormulaItemQuantityRequest(quantity: qty),
      );
      if (mounted) {
        _showMessage('Quantity updated');
        _load();
      }
    } catch (e) {
      if (mounted) _showMessage(_formatError(e), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _removeItem(FormulaItemResponse item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Item'),
        content: Text('Remove item ${item.id.substring(0, 8)}…?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _isLoading = true);
    try {
      final repo = getIt<FormulaRepository>();
      await repo.removeItem(widget.formulaId, item.id);
      if (mounted) {
        _showMessage('Item removed');
        _load();
      }
    } catch (e) {
      if (mounted) _showMessage(_formatError(e), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveOrder() async {
    setState(() => _isLoading = true);
    try {
      final repo = getIt<FormulaRepository>();
      await repo.reorderItems(
        widget.formulaId,
        ReorderFormulaItemsRequest(
          items: _items
              .asMap()
              .entries
              .map((e) => ReorderEntry(itemId: e.value.id, sortOrder: e.key))
              .toList(),
        ),
      );
      if (mounted) {
        _showMessage('Order saved');
        setState(() => _orderChanged = false);
      }
    } catch (e) {
      if (mounted) _showMessage(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
      ),
    );
  }

  String _formatError(Object error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      if (statusCode == 409) {
        return 'Item already exists in this formula (duplicate)';
      }
      if (statusCode == 400) {
        return 'Invalid input or total quantity exceeds '
            '${FormulaConstants.maxTotalQuantity}';
      }
    }
    return error.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_detail?.name ?? 'Formula Items'),
        actions: [
          if (_orderChanged)
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: 'Save Order',
              onPressed: _isLoading ? null : _saveOrder,
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _load,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItems,
        child: const Icon(Icons.add),
      ),
      body: _isLoading && _detail == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (_detail != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Formula: ${_detail!.name}',
                                style: theme.textTheme.titleMedium,
                              ),
                            ),
                            Text(
                              '${_items.length} items',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Total qty: '
                          '${FormulaValidation.totalQuantity(_items)}'
                          ' / ${FormulaConstants.maxTotalQuantity}'
                          '  (remaining: '
                          '${FormulaValidation.remainingCapacity(_items)})',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color:
                                FormulaValidation.remainingCapacity(_items) <= 0
                                ? theme.colorScheme.error
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: ReorderableListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: _items.length,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) newIndex--;
                        final item = _items.removeAt(oldIndex);
                        _items.insert(newIndex, item);
                        _orderChanged = true;
                      });
                    },
                    itemBuilder: (ctx, i) {
                      final item = _items[i];
                      return Card(
                        key: ValueKey(item.id),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text('${item.sortOrder}'),
                          ),
                          title: Text(
                            'Inventory: ${item.inventoryId.substring(0, 12)}…',
                          ),
                          subtitle: Text(
                            'Qty: ${item.quantity} • ${item.timeMs}ms',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _updateQuantity(item),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _removeItem(item),
                              ),
                              const Icon(Icons.drag_handle),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
