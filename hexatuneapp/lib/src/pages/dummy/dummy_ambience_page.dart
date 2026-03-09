// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/dsp/ambience/ambience_service.dart';
import 'package:hexatuneapp/src/core/dsp/ambience/models/ambience_config.dart';
import 'package:hexatuneapp/src/core/dsp/dsp_asset_service.dart';
import 'package:hexatuneapp/src/core/dsp/dsp_constants.dart';
import 'package:hexatuneapp/src/core/dsp/models/audio_asset.dart';

/// Dummy page for creating, editing, and managing ambience presets.
class DummyAmbiencePage extends StatefulWidget {
  const DummyAmbiencePage({super.key});

  @override
  State<DummyAmbiencePage> createState() => _DummyAmbiencePageState();
}

class _DummyAmbiencePageState extends State<DummyAmbiencePage> {
  late final AmbienceService _ambienceService;
  late final DspAssetService _assetService;
  bool _isLoading = true;

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

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primaryContainer,
      ),
    );
  }

  Future<void> _showCreateDialog() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => _AmbienceEditorPage(
          assetService: _assetService,
          ambienceService: _ambienceService,
        ),
      ),
    );
    if (result == true && mounted) setState(() {});
  }

  Future<void> _showEditDialog(AmbienceConfig config) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => _AmbienceEditorPage(
          assetService: _assetService,
          ambienceService: _ambienceService,
          existing: config,
        ),
      ),
    );
    if (result == true && mounted) setState(() {});
  }

  Future<void> _deleteConfig(AmbienceConfig config) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx)!;
        return AlertDialog(
          title: Text(l10n.dspAmbienceDeleteTitle),
          content: Text(l10n.dspAmbienceDeleteConfirm(config.name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.dspAmbienceCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.dspAmbienceDelete),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _ambienceService.delete(config.id);
      if (mounted) {
        setState(() {});
        _showMessage('Deleted "${config.name}"');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final configs = _ambienceService.configs;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.dspAmbienceTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateDialog,
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : configs.isEmpty
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
                    l10n.dspAmbienceEmpty,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.dspAmbienceEmptyHint,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
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
                padding: const EdgeInsets.all(12),
                itemCount: configs.length,
                itemBuilder: (context, index) {
                  final config = configs[index];
                  return _AmbienceListCard(
                    config: config,
                    assetService: _assetService,
                    onEdit: () => _showEditDialog(config),
                    onDelete: () => _deleteConfig(config),
                  );
                },
              ),
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// Ambience list card
// ---------------------------------------------------------------------------

class _AmbienceListCard extends StatelessWidget {
  const _AmbienceListCard({
    required this.config,
    required this.assetService,
    required this.onEdit,
    required this.onDelete,
  });

  final AmbienceConfig config;
  final DspAssetService assetService;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final baseAsset = config.baseAssetId != null
        ? _findAsset(config.baseAssetId!)
        : null;
    final baseName = baseAsset != null
        ? DspAssetService.resolveLocalizedName(context, baseAsset)
        : l10n.dspAmbienceNoBase;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      config.name,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: colorScheme.error),
                    onPressed: onDelete,
                    iconSize: 20,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${l10n.dspSectionBase}: $baseName',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              if (config.textureAssetIds.isNotEmpty)
                Text(
                  '${l10n.dspSectionTexture}: '
                  '${config.textureAssetIds.length}/${DspConstants.maxTextureLayers}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              if (config.eventAssetIds.isNotEmpty)
                Text(
                  '${l10n.dspSectionEvents}: '
                  '${config.eventAssetIds.length}/${DspConstants.maxEventSlots}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  AudioAsset? _findAsset(String id) {
    for (final a in assetService.allAssets) {
      if (a.id == id) return a;
    }
    return null;
  }
}

// ---------------------------------------------------------------------------
// Ambience editor page (create / edit)
// ---------------------------------------------------------------------------

class _AmbienceEditorPage extends StatefulWidget {
  const _AmbienceEditorPage({
    required this.assetService,
    required this.ambienceService,
    this.existing,
  });

  final DspAssetService assetService;
  final AmbienceService ambienceService;
  final AmbienceConfig? existing;

  @override
  State<_AmbienceEditorPage> createState() => _AmbienceEditorPageState();
}

class _AmbienceEditorPageState extends State<_AmbienceEditorPage> {
  late final TextEditingController _nameCtrl;
  String? _selectedBase;
  final List<String> _selectedTextures = [];
  final List<String> _selectedEvents = [];

  double _baseGain = DspConstants.defaultBaseGain;
  double _textureGain = DspConstants.defaultTextureGain;
  double _eventGain = DspConstants.defaultEventGain;
  double _masterGain = DspConstants.defaultMasterGain;

  bool _saving = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameCtrl = TextEditingController(text: e?.name ?? '');
    if (e != null) {
      _selectedBase = e.baseAssetId;
      _selectedTextures.addAll(e.textureAssetIds);
      _selectedEvents.addAll(e.eventAssetIds);
      _baseGain = e.baseGain;
      _textureGain = e.textureGain;
      _eventGain = e.eventGain;
      _masterGain = e.masterGain;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      _showError('Name cannot be empty');
      return;
    }

    setState(() => _saving = true);
    try {
      if (_isEditing) {
        await widget.ambienceService.update(
          widget.existing!.id,
          name: name,
          baseAssetId: _selectedBase,
          clearBase: _selectedBase == null,
          textureAssetIds: _selectedTextures,
          eventAssetIds: _selectedEvents,
          baseGain: _baseGain,
          textureGain: _textureGain,
          eventGain: _eventGain,
          masterGain: _masterGain,
        );
      } else {
        await widget.ambienceService.create(
          name: name,
          baseAssetId: _selectedBase,
          textureAssetIds: _selectedTextures,
          eventAssetIds: _selectedEvents,
          baseGain: _baseGain,
          textureGain: _textureGain,
          eventGain: _eventGain,
          masterGain: _masterGain,
        );
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _onBaseTapped(AudioAsset asset) {
    setState(() {
      if (_selectedBase == asset.id) {
        _selectedBase = null;
      } else {
        _selectedBase = asset.id;
      }
    });
  }

  void _onTextureTapped(AudioAsset asset) {
    setState(() {
      if (_selectedTextures.contains(asset.id)) {
        _selectedTextures.remove(asset.id);
      } else if (_selectedTextures.length < DspConstants.maxTextureLayers) {
        _selectedTextures.add(asset.id);
      }
    });
  }

  void _onEventTapped(AudioAsset asset) {
    setState(() {
      if (_selectedEvents.contains(asset.id)) {
        _selectedEvents.remove(asset.id);
      } else if (_selectedEvents.length < DspConstants.maxEventSlots) {
        _selectedEvents.add(asset.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.dspAmbienceEdit : l10n.dspAmbienceCreate),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.dspAmbienceSave),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Name field
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: l10n.dspAmbienceName,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Sound layers
            _buildSectionTitle(theme, l10n.dspSoundLayers),
            _buildSoundSection(
              theme: theme,
              l10n: l10n,
              title: l10n.dspSectionBase,
              layerType: 'base',
              selectedIds: _selectedBase != null ? [_selectedBase!] : [],
              maxCount: 1,
              onTap: _onBaseTapped,
            ),
            const SizedBox(height: 4),
            _buildSoundSection(
              theme: theme,
              l10n: l10n,
              title: l10n.dspSectionTexture,
              layerType: 'texture',
              selectedIds: _selectedTextures,
              maxCount: DspConstants.maxTextureLayers,
              onTap: _onTextureTapped,
            ),
            const SizedBox(height: 4),
            _buildSoundSection(
              theme: theme,
              l10n: l10n,
              title: l10n.dspSectionEvents,
              layerType: 'events',
              selectedIds: _selectedEvents,
              maxCount: DspConstants.maxEventSlots,
              onTap: _onEventTapped,
            ),
            const SizedBox(height: 16),

            // Gain controls
            _buildSectionTitle(theme, l10n.dspGainControls),
            _buildGainSlider(theme, l10n.dspSectionBase, _baseGain, (v) {
              setState(() => _baseGain = v);
            }),
            _buildGainSlider(theme, l10n.dspSectionTexture, _textureGain, (v) {
              setState(() => _textureGain = v);
            }),
            _buildGainSlider(theme, l10n.dspSectionEvents, _eventGain, (v) {
              setState(() => _eventGain = v);
            }),
            _buildGainSlider(theme, 'Master', _masterGain, (v) {
              setState(() => _masterGain = v);
            }),
            const SizedBox(height: 24),

            // Save button
            SizedBox(
              height: 48,
              child: FilledButton(
                onPressed: _saving ? null : _save,
                child: Text(
                  _isEditing ? l10n.dspAmbienceUpdate : l10n.dspAmbienceCreate,
                  style: theme.textTheme.titleSmall,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Summary
            if (_selectedBase != null ||
                _selectedTextures.isNotEmpty ||
                _selectedEvents.isNotEmpty)
              Card(
                color: colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.dspAmbienceSummary,
                        style: theme.textTheme.labelMedium,
                      ),
                      const SizedBox(height: 4),
                      if (_selectedBase != null)
                        _summaryRow(
                          theme,
                          l10n.dspSectionBase,
                          _resolveName(_selectedBase!),
                        ),
                      for (final id in _selectedTextures)
                        _summaryRow(
                          theme,
                          l10n.dspSectionTexture,
                          _resolveName(id),
                        ),
                      for (final id in _selectedEvents)
                        _summaryRow(
                          theme,
                          l10n.dspSectionEvents,
                          _resolveName(id),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 4),
      child: Text(text, style: theme.textTheme.titleSmall),
    );
  }

  Widget _buildSoundSection({
    required ThemeData theme,
    required AppLocalizations l10n,
    required String title,
    required String layerType,
    required List<String> selectedIds,
    required int maxCount,
    required void Function(AudioAsset) onTap,
  }) {
    final colorScheme = theme.colorScheme;
    final assets = widget.assetService.assetsForLayer(layerType);
    final counter = l10n.dspSelectedCount(selectedIds.length, maxCount);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Row(
          children: [
            Expanded(child: Text(title, style: theme.textTheme.titleSmall)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: selectedIds.isNotEmpty
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                counter,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: selectedIds.isNotEmpty
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        initiallyExpanded: true,
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: assets.map((asset) {
              final selected = selectedIds.contains(asset.id);
              final atLimit = !selected && selectedIds.length >= maxCount;
              final name = DspAssetService.resolveLocalizedName(context, asset);

              return _SoundChip(
                asset: asset,
                name: name,
                selected: selected,
                disabled: atLimit,
                theme: theme,
                onTap: () => onTap(asset),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGainSlider(
    ThemeData theme,
    String label,
    double value,
    ValueChanged<double> onChanged,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(label, style: theme.textTheme.bodySmall),
        ),
        Expanded(
          child: Slider(value: value, divisions: 20, onChanged: onChanged),
        ),
        SizedBox(
          width: 36,
          child: Text(
            value.toStringAsFixed(2),
            style: theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }

  String _resolveName(String assetId) {
    for (final a in widget.assetService.allAssets) {
      if (a.id == assetId) {
        return DspAssetService.resolveLocalizedName(context, a);
      }
    }
    return assetId;
  }
}

// ---------------------------------------------------------------------------
// Sound chip widget (reused in editor)
// ---------------------------------------------------------------------------

class _SoundChip extends StatelessWidget {
  const _SoundChip({
    required this.asset,
    required this.name,
    required this.selected,
    required this.disabled,
    required this.theme,
    required this.onTap,
  });

  final AudioAsset asset;
  final String name;
  final bool selected;
  final bool disabled;
  final ThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: 88,
      child: Material(
        color: selected
            ? colorScheme.primaryContainer
            : disabled
            ? colorScheme.surfaceContainerHighest.withAlpha(128)
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: disabled ? null : onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 48,
                  height: 48,
                  child:
                      asset.iconAsset.isNotEmpty &&
                          asset.iconAsset.endsWith('.svg')
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SvgPicture.asset(
                            asset.iconAsset,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              selected
                                  ? colorScheme.onPrimaryContainer
                                  : colorScheme.onSurfaceVariant,
                              BlendMode.srcIn,
                            ),
                            placeholderBuilder: (_) => Icon(
                              Icons.music_note,
                              size: 32,
                              color: selected
                                  ? colorScheme.onPrimaryContainer
                                  : colorScheme.onSurfaceVariant,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.music_note,
                          size: 32,
                          color: selected
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onSurfaceVariant,
                        ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: selected
                        ? colorScheme.onPrimaryContainer
                        : disabled
                        ? colorScheme.onSurface.withAlpha(97)
                        : colorScheme.onSurface,
                  ),
                ),
                if (selected)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.check_circle,
                      size: 14,
                      color: colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
