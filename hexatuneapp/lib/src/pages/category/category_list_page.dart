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
import 'package:hexatuneapp/src/core/rest/category/models/category_response.dart';
import 'package:hexatuneapp/src/core/router/route_names.dart';
import 'package:hexatuneapp/src/pages/shared/app_snack_bar.dart';
import 'package:hexatuneapp/src/core/network/api_error_handler.dart';

/// Category list page with search, sort, filter, and pagination.
class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  final _searchCtrl = TextEditingController();
  final List<CategoryResponse> _categories = [];
  final List<String> _availableLabels = [];
  final Set<String> _selectedLabels = {};
  String _sortValue = '';
  String? _nextCursor;
  bool _hasMore = false;
  bool _isLoading = false;
  bool _searchExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadLabels();
    _load();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadLabels() async {
    try {
      final repo = getIt<CategoryRepository>();
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
        'Failed to load category labels: $e',
        category: LogCategory.ui,
      );
    }
  }

  Future<void> _load({bool loadMore = false}) async {
    setState(() => _isLoading = true);
    final log = getIt<LogService>();
    try {
      final repo = getIt<CategoryRepository>();
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
          if (!loadMore) _categories.clear();
          _categories.addAll(resp.data);
          _nextCursor = resp.pagination.nextCursor;
          _hasMore = resp.pagination.hasMore;
        });
      }
      log.devLog(
        'Categories loaded: ${resp.data.length}',
        category: LogCategory.ui,
      );
    } catch (e) {
      log.devLog('Load categories failed: $e', category: LogCategory.ui);
      if (mounted) ApiErrorHandler.handle(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    AppSnackBar.success(context, message: message);
  }

  Future<void> _delete(String id, String name) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.categoryDeleteConfirm(name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              elevation: 1,
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _isLoading = true);
    try {
      await getIt<CategoryRepository>().delete(id);
      if (mounted) {
        _showSuccess(l10n.categoryDeleted);
        _loadLabels();
        _load();
      }
    } catch (e) {
      if (mounted) ApiErrorHandler.handle(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSortSheet() {
    final l10n = AppLocalizations.of(context)!;
    final options = <(String, String)>[
      ('', l10n.categorySortDefault),
      ('name', l10n.categorySortNameAsc),
      ('-name', l10n.categorySortNameDesc),
      ('-created_at', l10n.categorySortNewest),
      ('created_at', l10n.categorySortOldest),
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
                l10n.categorySortTitle,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.categoryFilterTitle,
                  style: Theme.of(ctx).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                if (_availableLabels.isEmpty)
                  Text(
                    l10n.categoryNoLabels,
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.categoryManagement)),
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
                    hintText: l10n.categorySearchHint,
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
            const SizedBox(width: 4),
            OutlinedButton(
              onPressed: _showSortSheet,
              child: Text(l10n.categorySortTitle),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: _showFilterSheet,
              child: Text(l10n.categoryFilterTitle),
            ),
            const Spacer(),
            FloatingActionButton.small(
              heroTag: 'categoryAdd',
              onPressed: () async {
                final created = await context.push<bool>(
                  RouteNames.categoryCreate,
                );
                if (created == true) {
                  _loadLabels();
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
    if (_isLoading && _categories.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_isLoading && _categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.folder_off_outlined,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(l10n.categoryEmptyTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              l10n.categoryEmptyHint,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _load(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        itemCount: _categories.length + (_hasMore ? 1 : 0),
        itemBuilder: (ctx, i) {
          if (i == _categories.length) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: _isLoading ? null : () => _load(loadMore: true),
                  child: Text(l10n.loadMore),
                ),
              ),
            );
          }
          final cat = _categories[i];
          return _CategoryListTile(
            category: cat,
            inventoryCount: 0,
            onEdit: () async {
              final updated = await context.push<bool>(
                RouteNames.categoryEditFor(cat.id),
              );
              if (updated == true) {
                _loadLabels();
                _load();
              }
            },
            onView: () => context.push(RouteNames.categoryViewFor(cat.id)),
            onDelete: () => _delete(cat.id, cat.name),
          );
        },
      ),
    );
  }
}

class _CategoryListTile extends StatelessWidget {
  const _CategoryListTile({
    required this.category,
    required this.inventoryCount,
    required this.onEdit,
    required this.onView,
    required this.onDelete,
  });

  final CategoryResponse category;
  final int inventoryCount;
  final VoidCallback onEdit;
  final VoidCallback onView;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        leading: Icon(Icons.folder_outlined, color: theme.colorScheme.primary),
        title: Text(category.name),
        subtitle: Text(l10n.categoryInventoryCount(inventoryCount)),
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
              child: Text(l10n.categoryEdit_menuItem),
            ),
            PopupMenuItem(
              value: 'view',
              child: Text(l10n.categoryView_menuItem),
            ),
          ],
        ),
        onTap: onView,
      ),
    );
  }
}
