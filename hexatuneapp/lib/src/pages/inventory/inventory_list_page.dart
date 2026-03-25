// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/network/pagination_params.dart';
import 'package:hexatuneapp/src/core/rest/category/category_repository.dart';
import 'package:hexatuneapp/src/core/rest/inventory/inventory_repository.dart';
import 'package:hexatuneapp/src/core/rest/inventory/models/inventory_response.dart';
import 'package:hexatuneapp/src/core/router/route_names.dart';
import 'package:hexatuneapp/src/core/network/api_error_handler.dart';
import 'package:hexatuneapp/src/pages/shared/app_bottom_bar.dart';

/// Inventory list page with search, sort, filter, and category-grouped accordion.
class InventoryListPage extends StatefulWidget {
  const InventoryListPage({super.key});

  @override
  State<InventoryListPage> createState() => _InventoryListPageState();
}

class _InventoryListPageState extends State<InventoryListPage> {
  final _searchCtrl = TextEditingController();
  final List<InventoryResponse> _items = [];
  final List<String> _availableLabels = [];
  final Set<String> _selectedLabels = {};
  final Map<String, String> _categoryNames = {};
  String _sortValue = '';
  String? _nextCursor;
  bool _hasMore = false;
  bool _isLoading = false;
  bool _searchExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadLabels();
    _loadCategories();
    _load();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    try {
      final catRepo = getIt<CategoryRepository>();
      final resp = await catRepo.list(
        params: const PaginationParams(limit: 100),
      );
      if (mounted) {
        setState(() {
          for (final cat in resp.data) {
            _categoryNames[cat.id] = cat.name;
          }
        });
      }
    } catch (e) {
      getIt<LogService>().devLog(
        'Failed to load categories: $e',
        category: LogCategory.ui,
      );
    }
  }

  Future<void> _loadLabels() async {
    try {
      final repo = getIt<InventoryRepository>();
      final labels = await repo.listLabels();
      if (mounted) {
        setState(
          () => _availableLabels
            ..clear()
            ..addAll(labels),
        );
      }
    } catch (e) {
      getIt<LogService>().devLog(
        'Failed to load inventory labels: $e',
        category: LogCategory.ui,
      );
    }
  }

  Future<void> _load({bool loadMore = false}) async {
    setState(() => _isLoading = true);
    final log = getIt<LogService>();
    try {
      final repo = getIt<InventoryRepository>();
      final resp = await repo.list(
        params: PaginationParams(
          cursor: loadMore ? _nextCursor : null,
          limit: 20,
          query: _searchCtrl.text.trim().isEmpty
              ? null
              : _searchCtrl.text.trim(),
          labels: _selectedLabels.isEmpty ? null : _selectedLabels.join(','),
          sort: _sortValue.isEmpty ? null : _sortValue,
        ),
      );
      if (mounted) {
        setState(() {
          if (!loadMore) _items.clear();
          _items.addAll(resp.data);
          _nextCursor = resp.pagination.nextCursor;
          _hasMore = resp.pagination.hasMore;
        });
      }
      log.devLog(
        'Inventories loaded: ${resp.data.length}',
        category: LogCategory.ui,
      );
    } catch (e) {
      log.devLog('Load inventories failed: $e', category: LogCategory.ui);
      if (mounted) ApiErrorHandler.handle(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSortSheet() {
    final l10n = AppLocalizations.of(context)!;
    final options = <(String, String)>[
      ('', l10n.inventorySortDefault),
      ('name', l10n.inventorySortNameAsc),
      ('-name', l10n.inventorySortNameDesc),
      ('-created_at', l10n.inventorySortNewest),
      ('created_at', l10n.inventorySortOldest),
    ];
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.inventorySortTitle,
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
            ),
            ...options.map((opt) {
              final selected = opt.$1 == _sortValue;
              return ListTile(
                title: Text(opt.$2),
                leading: Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: selected ? Theme.of(ctx).colorScheme.primary : null,
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() => _sortValue = opt.$1);
                  _load();
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.inventoryFilterTitle,
                  style: Theme.of(ctx).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                if (_availableLabels.isEmpty)
                  Text(
                    l10n.inventoryNoLabels,
                    style: Theme.of(ctx).textTheme.bodyMedium,
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: _availableLabels.map((label) {
                      final selected = _selectedLabels.contains(label);
                      return FilterChip(
                        label: Text(label),
                        selected: selected,
                        onSelected: (val) {
                          setSheetState(() {
                            if (val) {
                              _selectedLabels.add(label);
                            } else {
                              _selectedLabels.remove(label);
                            }
                          });
                          setState(() {});
                          _load();
                        },
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map<String, List<InventoryResponse>> _groupByCategory() {
    final grouped = <String, List<InventoryResponse>>{};
    for (final item in _items) {
      grouped.putIfAbsent(item.categoryId, () => []).add(item);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.inventoryManagement)),
      body: Column(
        children: [
          _buildToolbar(l10n, theme),
          const Divider(height: 1),
          Expanded(child: _buildBody(l10n, theme)),
        ],
      ),
    );
  }

  Widget _buildToolbar(AppLocalizations l10n, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          if (_searchExpanded)
            Expanded(
              child: Material(
                elevation: 1,
                borderRadius: BorderRadius.circular(12),
                color: theme.colorScheme.surfaceContainerLow,
                child: TextField(
                  controller: _searchCtrl,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: l10n.inventorySearchHint,
                    isDense: true,
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        setState(() {
                          _searchExpanded = false;
                          _searchCtrl.clear();
                        });
                        _load();
                      },
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => _load(),
                    ),
                  ),
                  onSubmitted: (_) => _load(),
                ),
              ),
            )
          else ...[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => setState(() => _searchExpanded = true),
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: _showSortSheet,
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(l10n.inventorySortTitle),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: _showFilterSheet,
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(l10n.inventoryFilterTitle),
            ),
            const SizedBox(width: 8),
            FloatingActionButton.small(
              heroTag: 'inventoryAdd',
              shape: const CircleBorder(),
              onPressed: () async {
                final created = await context.push<bool>(
                  RouteNames.inventoryCreate,
                );
                if (created == true) {
                  _loadLabels();
                  _loadCategories();
                  _load();
                }
              },
              child: const Icon(Icons.add),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n, ThemeData theme) {
    if (_isLoading && _items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_isLoading && _items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(l10n.inventoryEmptyTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              l10n.inventoryEmptyHint,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    final grouped = _groupByCategory();
    return RefreshIndicator(
      onRefresh: () async {
        await _loadCategories();
        await _load();
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          0,
          4,
          0,
          4 + AppBottomBar.scrollPadding,
        ),
        children: [
          ...grouped.entries.map(
            (entry) => _CategoryAccordion(
              categoryName: _categoryNames[entry.key] ?? entry.key,
              items: entry.value,
              onEdit: (item) async {
                final updated = await context.push<bool>(
                  RouteNames.inventoryEditFor(item.id),
                );
                if (updated == true) {
                  _loadLabels();
                  _loadCategories();
                  _load();
                }
              },
              onView: (item) =>
                  context.push(RouteNames.inventoryViewFor(item.id)),
            ),
          ),
          if (_hasMore)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: _isLoading ? null : () => _load(loadMore: true),
                  child: Text(l10n.loadMore),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryAccordion extends StatefulWidget {
  const _CategoryAccordion({
    required this.categoryName,
    required this.items,
    required this.onEdit,
    required this.onView,
  });

  final String categoryName;
  final List<InventoryResponse> items;
  final void Function(InventoryResponse) onEdit;
  final void Function(InventoryResponse) onView;

  @override
  State<_CategoryAccordion> createState() => _CategoryAccordionState();
}

class _CategoryAccordionState extends State<_CategoryAccordion> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return ExpansionTile(
      initiallyExpanded: true,
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      collapsedBackgroundColor: theme.colorScheme.surfaceContainerLow,
      leading: Icon(Icons.folder_outlined, color: theme.colorScheme.primary),
      title: Text(
        widget.categoryName,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.inventoryCount(widget.items.length),
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(width: 4),
          AnimatedRotation(
            turns: _expanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 200),
            child: const Icon(Icons.expand_more),
          ),
        ],
      ),
      onExpansionChanged: (val) => setState(() => _expanded = val),
      children: widget.items
          .map(
            (item) => _InventoryListTile(
              item: item,
              onEdit: () => widget.onEdit(item),
              onView: () => widget.onView(item),
            ),
          )
          .toList(),
    );
  }
}

class _InventoryListTile extends StatelessWidget {
  const _InventoryListTile({
    required this.item,
    required this.onEdit,
    required this.onView,
  });

  final InventoryResponse item;
  final VoidCallback onEdit;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      leading: Icon(
        item.imageUploaded ? Icons.image_outlined : Icons.description_outlined,
      ),
      title: Text(item.name),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          switch (value) {
            case 'edit':
              onEdit();
            case 'view':
              onView();
          }
        },
        itemBuilder: (ctx) => [
          PopupMenuItem(
            value: 'edit',
            child: Text(l10n.inventoryEdit_menuItem),
          ),
          PopupMenuItem(
            value: 'view',
            child: Text(l10n.inventoryView_menuItem),
          ),
        ],
      ),
      onTap: onView,
    );
  }
}
