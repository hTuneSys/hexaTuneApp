// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/dsp/ambience/ambience_service.dart';
import 'package:hexatuneapp/src/core/dsp/ambience/models/ambience_config.dart';
import 'package:hexatuneapp/src/core/dsp/dsp_asset_service.dart';
import 'package:hexatuneapp/src/core/dsp/dsp_constants.dart';
import 'package:hexatuneapp/src/core/dsp/models/audio_asset.dart';
import 'package:hexatuneapp/src/core/router/route_names.dart';
import 'package:hexatuneapp/src/pages/shared/app_bottom_bar.dart';

/// Production ambience list page with search, sort, filter, and card display.
class AmbienceListPage extends StatefulWidget {
  const AmbienceListPage({super.key});

  @override
  State<AmbienceListPage> createState() => _AmbienceListPageState();
}

enum _SortMode { name, newest, oldest }

class _AmbienceListPageState extends State<AmbienceListPage> {
  final _searchCtrl = TextEditingController();
  bool _isLoading = true;
  bool _searchExpanded = false;
  _SortMode _sortMode = _SortMode.newest;
  String? _filterBase;

  late final AmbienceService _ambienceService;
  late final DspAssetService _assetService;

  @override
  void initState() {
    super.initState();
    _ambienceService = getIt<AmbienceService>();
    _assetService = getIt<DspAssetService>();
    _initServices();
  }

  Future<void> _initServices() async {
    await _assetService.discover();
    await _ambienceService.load();
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<AmbienceConfig> get _filteredConfigs {
    var configs = List<AmbienceConfig>.from(_ambienceService.configs);

    // Search filter
    final query = _searchCtrl.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      configs = configs
          .where((c) => c.name.toLowerCase().contains(query))
          .toList();
    }

    // Base layer filter
    if (_filterBase != null) {
      configs = configs.where((c) => c.baseAssetId == _filterBase).toList();
    }

    // Sort
    switch (_sortMode) {
      case _SortMode.name:
        configs.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
      case _SortMode.newest:
        configs.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      case _SortMode.oldest:
        configs.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
    }

    return configs;
  }

  void _showSortSheet() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) {
        final options = [
          (_SortMode.name, l10n.ambienceSortByName),
          (_SortMode.newest, l10n.ambienceSortByNewest),
          (_SortMode.oldest, l10n.ambienceSortByOldest),
        ];
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.ambienceSortTitle,
                  style: Theme.of(ctx).textTheme.titleMedium,
                ),
              ),
              ...options.map((opt) {
                final selected = opt.$1 == _sortMode;
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
                    setState(() => _sortMode = opt.$1);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showFilterSheet() {
    final l10n = AppLocalizations.of(context)!;
    final baseAssets = _assetService.assetsForLayer('base');
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) {
        final allSelected = _filterBase == null;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.ambienceFilterTitle,
                  style: Theme.of(ctx).textTheme.titleMedium,
                ),
              ),
              ListTile(
                title: Text(l10n.ambienceFilterAll),
                leading: Icon(
                  allSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: allSelected ? Theme.of(ctx).colorScheme.primary : null,
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() => _filterBase = null);
                },
              ),
              for (final asset in baseAssets)
                ListTile(
                  title: Text(
                    DspAssetService.resolveLocalizedName(context, asset),
                  ),
                  leading: Icon(
                    _filterBase == asset.id
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: _filterBase == asset.id
                        ? Theme.of(ctx).colorScheme.primary
                        : null,
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() => _filterBase = asset.id);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  AudioAsset? _findAsset(String id) {
    for (final a in _assetService.allAssets) {
      if (a.id == id) return a;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final configs = _filteredConfigs;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.ambienceManagementTitle)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search + Sort + Filter row
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
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
                                hintText: l10n.ambienceSearchHint,
                                isDense: true,
                                prefixIcon: IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: () {
                                    _searchCtrl.clear();
                                    setState(() => _searchExpanded = false);
                                  },
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.search),
                                  onPressed: () => setState(() {}),
                                ),
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                        )
                      else ...[
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () =>
                              setState(() => _searchExpanded = true),
                        ),
                        const Spacer(),
                        OutlinedButton(
                          onPressed: _showSortSheet,
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(l10n.ambienceSortTitle),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: _showFilterSheet,
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(l10n.ambienceFilterTitle),
                        ),
                        const SizedBox(width: 8),
                        FloatingActionButton.small(
                          heroTag: 'ambienceAdd',
                          shape: const CircleBorder(),
                          onPressed: () async {
                            final created = await context.push<bool>(
                              RouteNames.ambienceCreate,
                            );
                            if (created == true && mounted) setState(() {});
                          },
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // List or empty state
                Expanded(
                  child: configs.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.landscape_outlined,
                                size: 64,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                l10n.ambienceEmptyTitle,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.ambienceEmptySubtitle,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            await _ambienceService.load();
                            if (mounted) setState(() {});
                          },
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(
                              12,
                              0,
                              12,
                              AppBottomBar.scrollPadding,
                            ),
                            itemCount: configs.length,
                            itemBuilder: (context, index) {
                              final config = configs[index];
                              return _AmbienceListCard(
                                config: config,
                                baseName: _resolveBaseName(config, l10n),
                                textureCount: config.textureAssetIds.length,
                                eventCount: config.eventAssetIds.length,
                                onView: () => context.push(
                                  RouteNames.ambienceViewFor(config.id),
                                ),
                                onEdit: () async {
                                  final updated = await context.push<bool>(
                                    RouteNames.ambienceEditFor(config.id),
                                  );
                                  if (updated == true && mounted) {
                                    setState(() {});
                                  }
                                },
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }

  String _resolveBaseName(AmbienceConfig config, AppLocalizations l10n) {
    if (config.baseAssetId == null) return l10n.ambienceNoBase;
    final asset = _findAsset(config.baseAssetId!);
    if (asset == null) return config.baseAssetId!;
    return DspAssetService.resolveLocalizedName(context, asset);
  }
}

// ---------------------------------------------------------------------------
// Ambience list card
// ---------------------------------------------------------------------------

class _AmbienceListCard extends StatelessWidget {
  const _AmbienceListCard({
    required this.config,
    required this.baseName,
    required this.textureCount,
    required this.eventCount,
    required this.onView,
    required this.onEdit,
  });

  final AmbienceConfig config;
  final String baseName;
  final int textureCount;
  final int eventCount;
  final VoidCallback onView;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onView,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(config.name, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      '${l10n.dspSectionBase}: $baseName',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '${l10n.dspSectionTexture}: '
                      '$textureCount/${DspConstants.maxTextureLayers}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '${l10n.dspSectionEvents}: '
                      '$eventCount/${DspConstants.maxEventSlots}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'view') onView();
                  if (value == 'edit') onEdit();
                },
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                    value: 'view',
                    child: Text(l10n.ambienceViewMenuItem),
                  ),
                  PopupMenuItem(
                    value: 'edit',
                    child: Text(l10n.ambienceEditMenuItem),
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
