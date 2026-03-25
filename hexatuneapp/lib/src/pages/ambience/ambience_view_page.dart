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
import 'package:hexatuneapp/src/core/dsp/dsp_service.dart';
import 'package:hexatuneapp/src/core/dsp/models/audio_asset.dart';

/// Read-only view of an ambience preset with playback support.
class AmbienceViewPage extends StatefulWidget {
  const AmbienceViewPage({super.key, required this.ambienceId});

  final String ambienceId;

  @override
  State<AmbienceViewPage> createState() => _AmbienceViewPageState();
}

class _AmbienceViewPageState extends State<AmbienceViewPage> {
  bool _isLoading = true;
  bool _isPlaying = false;
  bool _isLoadingPlayback = false;

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
    _config = _ambienceService.findById(widget.ambienceId);
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    if (_isPlaying) _dspService.stop();
    _dspService.clearAllLayers();
    super.dispose();
  }

  AudioAsset? _findAssetById(String id) {
    for (final a in _assetService.allAssets) {
      if (a.id == id) return a;
    }
    return null;
  }

  Future<void> _play() async {
    final config = _config;
    if (_isPlaying || _isLoadingPlayback || config == null) return;
    setState(() => _isLoadingPlayback = true);

    try {
      if (_dspService.isPlaying) await _dspService.stop();
      await _dspService.clearAllLayers();

      if (config.baseAssetId != null) {
        final asset = _findAssetById(config.baseAssetId!);
        if (asset != null) {
          await _dspService.loadBase(asset.assetPath);
        }
      }

      for (var i = 0; i < config.textureAssetIds.length; i++) {
        final asset = _findAssetById(config.textureAssetIds[i]);
        if (asset != null) {
          await _dspService.loadTexture(i, asset.assetPath);
        }
      }

      for (var i = 0; i < config.eventAssetIds.length; i++) {
        final asset = _findAssetById(config.eventAssetIds[i]);
        if (asset != null) {
          await _dspService.loadEvent(i, asset.assetPath);
        }
      }

      _dspService.updateBinauralConfig(binauralEnabled: false);
      _dspService.setBaseGain(config.baseGain);
      _dspService.setTextureGain(config.textureGain);
      _dspService.setEventGain(config.eventGain);
      _dspService.setBinauralGain(0.0);
      _dspService.setMasterGain(config.masterGain);

      final err = await _dspService.start();
      if (err != null) {
        _showError(err);
        return;
      }

      if (mounted) setState(() => _isPlaying = true);
    } catch (e) {
      _showError('Playback error: $e');
    } finally {
      if (mounted) setState(() => _isLoadingPlayback = false);
    }
  }

  Future<void> _stop() async {
    if (!_isPlaying) return;
    await _dspService.stop();
    await _dspService.clearAllLayers();
    if (mounted) setState(() => _isPlaying = false);
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.ambienceViewTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final config = _config;
    if (config == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.ambienceViewTitle)),
        body: Center(
          child: Text(l10n.ambienceNotFound, style: theme.textTheme.bodyLarge),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.ambienceViewTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Name
            Text(l10n.ambienceNameLabel, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Material(
              elevation: 1,
              borderRadius: BorderRadius.circular(12),
              color: theme.colorScheme.surfaceContainerLow,
              child: TextField(
                controller: TextEditingController(text: config.name),
                readOnly: true,
                decoration: const InputDecoration(),
              ),
            ),
            const SizedBox(height: 24),

            // Sound Layers
            Text(l10n.ambienceSoundLayers, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            _buildReadOnlySection(
              theme: theme,
              l10n: l10n,
              title: l10n.dspSectionBase,
              layerType: 'base',
              selectedIds: config.baseAssetId != null
                  ? [config.baseAssetId!]
                  : [],
              maxCount: 1,
            ),
            const SizedBox(height: 4),
            _buildReadOnlySection(
              theme: theme,
              l10n: l10n,
              title: l10n.dspSectionTexture,
              layerType: 'texture',
              selectedIds: config.textureAssetIds,
              maxCount: DspConstants.maxTextureLayers,
            ),
            const SizedBox(height: 4),
            _buildReadOnlySection(
              theme: theme,
              l10n: l10n,
              title: l10n.dspSectionEvents,
              layerType: 'events',
              selectedIds: config.eventAssetIds,
              maxCount: DspConstants.maxEventSlots,
            ),
            const SizedBox(height: 24),

            // Sound Settings (read-only)
            Text(l10n.ambienceSoundSettings, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            _buildReadOnlySlider(theme, l10n.dspSectionBase, config.baseGain),
            _buildReadOnlySlider(
              theme,
              l10n.dspSectionTexture,
              config.textureGain,
            ),
            _buildReadOnlySlider(
              theme,
              l10n.dspSectionEvents,
              config.eventGain,
            ),
            _buildReadOnlySlider(theme, l10n.ambienceMaster, config.masterGain),
            const SizedBox(height: 16),

            // Play button
            SizedBox(
              height: 48,
              child: OutlinedButton.icon(
                onPressed: _isPlaying
                    ? _stop
                    : (!_isLoadingPlayback ? _play : null),
                icon: _isLoadingPlayback
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                label: Text(_isPlaying ? l10n.dspStop : l10n.dspPlay),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlySection({
    required ThemeData theme,
    required AppLocalizations l10n,
    required String title,
    required String layerType,
    required List<String> selectedIds,
    required int maxCount,
  }) {
    final colorScheme = theme.colorScheme;
    final assets = _assetService.assetsForLayer(layerType);
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
              final name = DspAssetService.resolveLocalizedName(context, asset);

              return _ReadOnlySoundChip(
                asset: asset,
                name: name,
                selected: selected,
                theme: theme,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlySlider(ThemeData theme, String label, double value) {
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(label, style: theme.textTheme.bodySmall),
        ),
        Expanded(child: Slider(value: value, divisions: 20, onChanged: null)),
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
// Read-only sound chip
// ---------------------------------------------------------------------------

class _ReadOnlySoundChip extends StatelessWidget {
  const _ReadOnlySoundChip({
    required this.asset,
    required this.name,
    required this.selected,
    required this.theme,
  });

  final AudioAsset asset;
  final String name;
  final bool selected;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: 88,
      child: Material(
        color: selected
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
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
    );
  }
}
