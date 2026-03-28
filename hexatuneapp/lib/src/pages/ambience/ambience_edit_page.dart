// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:go_router/go_router.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/dsp/ambience/ambience_service.dart';
import 'package:hexatuneapp/src/core/dsp/ambience/models/ambience_config.dart';
import 'package:hexatuneapp/src/core/dsp/dsp_asset_service.dart';
import 'package:hexatuneapp/src/core/dsp/dsp_constants.dart';
import 'package:hexatuneapp/src/core/dsp/dsp_service.dart';
import 'package:hexatuneapp/src/core/dsp/models/audio_asset.dart';
import 'package:hexatuneapp/src/pages/shared/app_snack_bar.dart';
import 'package:hexatuneapp/src/core/network/api_error_handler.dart';
import 'package:hexatuneapp/src/pages/shared/app_bottom_bar.dart';

/// Edit an existing ambience preset.
class AmbienceEditPage extends StatefulWidget {
  const AmbienceEditPage({super.key, required this.ambienceId});

  final String ambienceId;

  @override
  State<AmbienceEditPage> createState() => _AmbienceEditPageState();
}

class _AmbienceEditPageState extends State<AmbienceEditPage> {
  final _nameCtrl = TextEditingController();
  String? _selectedBase;
  final List<String> _selectedTextures = [];
  final List<String> _selectedEvents = [];

  double _baseGain = DspConstants.defaultBaseGain;
  double _textureGain = DspConstants.defaultTextureGain;
  double _eventGain = DspConstants.defaultEventGain;
  double _masterGain = DspConstants.defaultMasterGain;

  bool _isLoading = true;
  bool _saving = false;
  bool _isRendering = false;
  bool _isLoadingPreview = false;

  late final AmbienceService _ambienceService;
  late final DspAssetService _assetService;
  late final DspService _dspService;

  AmbienceConfig? _config;

  @override
  void initState() {
    super.initState();
    _ambienceService = getIt<AmbienceService>();
    _assetService = getIt<DspAssetService>();
    _dspService = getIt<DspService>();
    _loadData();
  }

  Future<void> _loadData() async {
    await _assetService.discover();
    await _ambienceService.load();
    final config = _ambienceService.findById(widget.ambienceId);
    if (config != null) {
      _config = config;
      _nameCtrl.text = config.name;
      _selectedBase = config.baseAssetId;
      _selectedTextures
        ..clear()
        ..addAll(config.textureAssetIds);
      _selectedEvents
        ..clear()
        ..addAll(config.eventAssetIds);
      _baseGain = config.baseGain;
      _textureGain = config.textureGain;
      _eventGain = config.eventGain;
      _masterGain = config.masterGain;
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    if (_isRendering) _dspService.stop();
    _dspService.clearAllLayers();
    _nameCtrl.dispose();
    super.dispose();
  }

  bool get _hasLayers =>
      _selectedBase != null ||
      _selectedTextures.isNotEmpty ||
      _selectedEvents.isNotEmpty;

  AudioAsset? _findAssetById(String id) {
    for (final a in _assetService.allAssets) {
      if (a.id == id) return a;
    }
    return null;
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      _showError(l10n.ambienceNameRequired);
      return;
    }

    if (_isRendering) await _stop();

    setState(() => _saving = true);
    try {
      await _ambienceService.update(
        widget.ambienceId,
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
      if (mounted) {
        AppSnackBar.success(context, message: l10n.ambienceUpdated);
        context.pop(true);
      }
    } catch (e) {
      if (mounted) ApiErrorHandler.handle(context, e);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.ambienceDeleteConfirmTitle),
        content: Text(l10n.ambienceDeleteConfirmMessage(_config?.name ?? '')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.dspAmbienceCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              elevation: 1,
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.dspAmbienceDelete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (_isRendering) await _stop();
      await _ambienceService.delete(widget.ambienceId);
      if (mounted) {
        AppSnackBar.success(context, message: l10n.ambienceDeleted);
        context.pop(true);
      }
    }
  }

  Future<void> _play() async {
    if (_isRendering || _isLoadingPreview || !_hasLayers) return;
    setState(() => _isLoadingPreview = true);

    try {
      if (_dspService.isRendering) await _dspService.stop();
      await _dspService.clearAllLayers();

      if (_selectedBase != null) {
        final asset = _findAssetById(_selectedBase!);
        if (asset != null) {
          final rc = await _dspService.loadBase(asset.assetPath);
          if (rc != 0) {
            _showError('Failed to load base: ${asset.id} (code $rc)');
            return;
          }
        }
      }

      for (var i = 0; i < _selectedTextures.length; i++) {
        final asset = _findAssetById(_selectedTextures[i]);
        if (asset != null) {
          final rc = await _dspService.loadTexture(i, asset.assetPath);
          if (rc != 0) {
            _showError('Failed to load texture: ${asset.id} (code $rc)');
            return;
          }
        }
      }

      for (var i = 0; i < _selectedEvents.length; i++) {
        final asset = _findAssetById(_selectedEvents[i]);
        if (asset != null) {
          final rc = await _dspService.loadEvent(i, asset.assetPath);
          if (rc != 0) {
            _showError('Failed to load event: ${asset.id} (code $rc)');
            return;
          }
        }
      }

      _dspService.updateBinauralConfig(binauralEnabled: false);
      _dspService.setBaseGain(_baseGain);
      _dspService.setTextureGain(_textureGain);
      _dspService.setEventGain(_eventGain);
      _dspService.setBinauralGain(0.0);
      _dspService.setMasterGain(_masterGain);

      final err = await _dspService.start();
      if (err != null) {
        _showError(err);
        return;
      }

      if (mounted) setState(() => _isRendering = true);
    } catch (e) {
      _showError('Playback error: $e');
    } finally {
      if (mounted) setState(() => _isLoadingPreview = false);
    }
  }

  Future<void> _stop() async {
    if (!_isRendering) return;
    await _dspService.stop();
    await _dspService.clearAllLayers();
    if (mounted) setState(() => _isRendering = false);
  }

  void _onBaseTapped(AudioAsset asset) {
    setState(() {
      _selectedBase = _selectedBase == asset.id ? null : asset.id;
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

  void _showError(String msg) {
    if (!mounted) return;
    AppSnackBar.error(context, message: msg);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.ambienceEditTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_config == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.ambienceEditTitle)),
        body: Center(
          child: Text(l10n.ambienceNotFound, style: theme.textTheme.bodyLarge),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.ambienceEditTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          16 + AppBottomBar.scrollPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Name
            Text(
              l10n.ambienceNameLabel,
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
                controller: _nameCtrl,
                decoration: InputDecoration(hintText: l10n.ambienceNameHint),
              ),
            ),
            const SizedBox(height: 24),

            // Sound Layers
            Text(
              l10n.ambienceSoundLayers,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
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
            const SizedBox(height: 24),

            // Sound Settings
            Text(
              l10n.ambienceSoundSettings,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildGainSlider(theme, l10n.dspSectionBase, _baseGain, (v) {
              setState(() => _baseGain = v);
              if (_isRendering) _dspService.setBaseGain(v);
            }),
            _buildGainSlider(theme, l10n.dspSectionTexture, _textureGain, (v) {
              setState(() => _textureGain = v);
              if (_isRendering) _dspService.setTextureGain(v);
            }),
            _buildGainSlider(theme, l10n.dspSectionEvents, _eventGain, (v) {
              setState(() => _eventGain = v);
              if (_isRendering) _dspService.setEventGain(v);
            }),
            _buildGainSlider(theme, l10n.ambienceMaster, _masterGain, (v) {
              setState(() => _masterGain = v);
              if (_isRendering) _dspService.setMasterGain(v);
            }),
            const SizedBox(height: 16),

            // Play button
            SizedBox(
              height: 48,
              child: OutlinedButton.icon(
                onPressed: _isRendering
                    ? _stop
                    : (_hasLayers && !_isLoadingPreview ? _play : null),
                icon: _isLoadingPreview
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(_isRendering ? Icons.stop : Icons.join_inner),
                label: Text(_isRendering ? l10n.dspStop : l10n.dspPlay),
              ),
            ),
            const SizedBox(height: 16),

            // Delete + Save buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: FilledButton(
                      onPressed: _delete,
                      style: FilledButton.styleFrom(
                        elevation: 1,
                        backgroundColor: colorScheme.error,
                        foregroundColor: colorScheme.onError,
                      ),
                      child: Text(l10n.dspAmbienceDelete),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: FilledButton(
                      onPressed: _saving ? null : _save,
                      child: _saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.dspAmbienceSave),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
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
    final assets = _assetService.assetsForLayer(layerType);
    final counter = l10n.dspSelectedCount(selectedIds.length, maxCount);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
}

// ---------------------------------------------------------------------------
// Sound chip widget
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
                          borderRadius: BorderRadius.circular(12),
                          child: SvgPicture.asset(
                            asset.iconAsset,
                            width: 48,
                            height: 48,
                            fit: BoxFit.contain,
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
