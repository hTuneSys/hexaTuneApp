// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/dsp/dsp_asset_service.dart';
import 'package:hexatuneapp/src/core/dsp/dsp_constants.dart';
import 'package:hexatuneapp/src/core/dsp/dsp_service.dart';
import 'package:hexatuneapp/src/core/dsp/models/audio_asset.dart';
import 'package:hexatuneapp/src/core/dsp/models/cycle_step.dart';

/// Dummy DSP audio engine page for testing — will be replaced with
/// production UI.
class DummyDspPage extends StatefulWidget {
  const DummyDspPage({super.key});

  @override
  State<DummyDspPage> createState() => _DummyDspPageState();
}

class _DummyDspPageState extends State<DummyDspPage> {
  late final DspService _dspService;
  late final DspAssetService _assetService;

  final _carrierFreqCtrl = TextEditingController(text: '400.0');
  bool _binauralEnabled = true;
  final List<_CycleStepEntry> _cycleSteps = [
    _CycleStepEntry(
      deltaCtrl: TextEditingController(text: '5.0'),
      durationCtrl: TextEditingController(text: '30.0'),
    ),
  ];

  AudioAsset? _selectedBase;
  final List<AudioAsset> _selectedTextures = [];
  final List<AudioAsset> _selectedEvents = [];

  bool _baseLoading = false;
  final Set<String> _loadingIds = {};

  double _baseGain = DspConstants.defaultBaseGain;
  double _textureGain = DspConstants.defaultTextureGain;
  double _eventGain = DspConstants.defaultEventGain;
  double _binauralGain = DspConstants.defaultBinauralGain;
  double _masterGain = DspConstants.defaultMasterGain;

  bool _isPlaying = false;
  bool _isStopping = false;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _dspService = getIt<DspService>();
    _assetService = getIt<DspAssetService>();
    _assetService.discover().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _carrierFreqCtrl.dispose();
    for (final s in _cycleSteps) {
      s.deltaCtrl.dispose();
      s.durationCtrl.dispose();
    }
    super.dispose();
  }

  bool get _anyLoading => _baseLoading || _loadingIds.isNotEmpty;

  // ---------------------------------------------------------------------------
  // Base selection
  // ---------------------------------------------------------------------------

  Future<void> _onBaseTapped(AudioAsset asset) async {
    if (_baseLoading) return;

    if (_selectedBase?.id == asset.id) {
      setState(() {
        _selectedBase = null;
        _baseLoading = false;
      });
      final cascaded = await _dspService.clearBase();
      setState(() {
        _statusMessage = null;
        if (cascaded) {
          _selectedTextures.clear();
          _selectedEvents.clear();
          _loadingIds.clear();
        }
      });
      return;
    }

    setState(() {
      _selectedBase = asset;
      _baseLoading = true;
      _selectedTextures.clear();
      _selectedEvents.clear();
      _loadingIds.clear();
    });

    try {
      final rc = await _dspService.loadBase(asset.assetPath);
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      final name = DspAssetService.resolveLocalizedName(context, asset);
      setState(() {
        _baseLoading = false;
        _statusMessage = rc == 0
            ? l10n.dspBaseLoaded(name)
            : l10n.dspLoadFailed(rc);
      });
    } catch (e) {
      setState(() {
        _baseLoading = false;
        _statusMessage = 'Base error: $e';
      });
    }
  }

  // ---------------------------------------------------------------------------
  // Texture selection (multi, up to maxTextureLayers)
  // ---------------------------------------------------------------------------

  Future<void> _onTextureTapped(AudioAsset asset) async {
    final l10n = AppLocalizations.of(context)!;
    final existingIdx = _selectedTextures.indexWhere((a) => a.id == asset.id);

    if (existingIdx >= 0) {
      final slotIdx = existingIdx;
      await _dspService.clearTexture(slotIdx);
      setState(() {
        _selectedTextures.removeAt(existingIdx);
        _loadingIds.remove(asset.id);
      });
      return;
    }

    if (_selectedTextures.length >= DspConstants.maxTextureLayers) return;
    if (_loadingIds.contains(asset.id)) return;

    final slotIdx = _selectedTextures.length;
    setState(() {
      _selectedTextures.add(asset);
      _loadingIds.add(asset.id);
    });

    try {
      final rc = await _dspService.loadTexture(slotIdx, asset.assetPath);
      if (!mounted) return;
      final name = DspAssetService.resolveLocalizedName(context, asset);
      setState(() {
        _loadingIds.remove(asset.id);
        if (rc == HtdError.baseRequired.code) {
          _statusMessage = l10n.dspSelectBaseFirst;
          _selectedTextures.removeWhere((a) => a.id == asset.id);
        } else {
          _statusMessage = rc == 0
              ? l10n.dspTextureLoaded(slotIdx + 1, name)
              : l10n.dspLoadFailed(rc);
        }
      });
    } catch (e) {
      setState(() {
        _loadingIds.remove(asset.id);
        _statusMessage = 'Texture error: $e';
      });
    }
  }

  // ---------------------------------------------------------------------------
  // Event selection (multi, up to maxEventSlots)
  // ---------------------------------------------------------------------------

  Future<void> _onEventTapped(AudioAsset asset) async {
    final l10n = AppLocalizations.of(context)!;
    final existingIdx = _selectedEvents.indexWhere((a) => a.id == asset.id);

    if (existingIdx >= 0) {
      final slotIdx = existingIdx;
      await _dspService.clearEvent(slotIdx);
      setState(() {
        _selectedEvents.removeAt(existingIdx);
        _loadingIds.remove(asset.id);
      });
      return;
    }

    if (_selectedEvents.length >= DspConstants.maxEventSlots) return;
    if (_loadingIds.contains(asset.id)) return;

    final slotIdx = _selectedEvents.length;
    setState(() {
      _selectedEvents.add(asset);
      _loadingIds.add(asset.id);
    });

    try {
      final rc = await _dspService.loadEvent(slotIdx, asset.assetPath);
      if (!mounted) return;
      final name = DspAssetService.resolveLocalizedName(context, asset);
      setState(() {
        _loadingIds.remove(asset.id);
        if (rc == HtdError.baseRequired.code) {
          _statusMessage = l10n.dspSelectBaseFirst;
          _selectedEvents.removeWhere((a) => a.id == asset.id);
        } else {
          _statusMessage = rc == 0
              ? l10n.dspEventLoaded(slotIdx + 1, name)
              : l10n.dspLoadFailed(rc);
        }
      });
    } catch (e) {
      setState(() {
        _loadingIds.remove(asset.id);
        _statusMessage = 'Event error: $e';
      });
    }
  }

  // ---------------------------------------------------------------------------
  // Play / Stop
  // ---------------------------------------------------------------------------

  Future<void> _play() async {
    _dspService.updateBinauralConfig(
      carrierFrequency: double.tryParse(_carrierFreqCtrl.text) ?? 400.0,
      binauralEnabled: _binauralEnabled,
      cycleSteps: _cycleSteps
          .map(
            (s) => CycleStep(
              frequencyDelta: double.tryParse(s.deltaCtrl.text) ?? 5.0,
              durationSeconds: double.tryParse(s.durationCtrl.text) ?? 30.0,
              oneshot: s.oneshot,
            ),
          )
          .toList(),
    );

    final error = await _dspService.start();
    if (error != null) {
      setState(() => _statusMessage = error);
      return;
    }

    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isPlaying = true;
      _statusMessage = l10n.dspPlaying;
    });
  }

  Future<void> _stop() async {
    await _dspService.stop();
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isPlaying = false;
      _isStopping = false;
      _statusMessage = l10n.dspStopped;
    });
  }

  Future<void> _stopGraceful() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isStopping = true;
      _statusMessage = l10n.dspFinishingCycle;
    });
    await _dspService.stopGraceful();
    if (!mounted) return;
    setState(() {
      _isPlaying = false;
      _isStopping = false;
      _statusMessage = l10n.dspGracefullyStopped;
    });
  }

  void _addCycleStep() {
    setState(() {
      _cycleSteps.add(
        _CycleStepEntry(
          deltaCtrl: TextEditingController(text: '5.0'),
          durationCtrl: TextEditingController(text: '30.0'),
        ),
      );
    });
  }

  void _removeCycleStep(int index) {
    setState(() {
      _cycleSteps[index].deltaCtrl.dispose();
      _cycleSteps[index].durationCtrl.dispose();
      _cycleSteps.removeAt(index);
    });
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.dspPageTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_statusMessage != null) _buildStatusCard(theme, colorScheme),
            const SizedBox(height: 12),

            // Sound Layers
            _buildSectionTitle(theme, l10n.dspSoundLayers),
            _buildSoundLayerSection(
              theme: theme,
              l10n: l10n,
              title: l10n.dspSectionBase,
              layerType: 'base',
              selectedCount: _selectedBase != null ? 1 : 0,
              maxCount: 1,
              isSelected: (a) => _selectedBase?.id == a.id,
              onTap: _onBaseTapped,
            ),
            const SizedBox(height: 4),
            _buildSoundLayerSection(
              theme: theme,
              l10n: l10n,
              title: l10n.dspSectionTexture,
              layerType: 'texture',
              selectedCount: _selectedTextures.length,
              maxCount: DspConstants.maxTextureLayers,
              isSelected: (a) => _selectedTextures.any((t) => t.id == a.id),
              onTap: _onTextureTapped,
            ),
            const SizedBox(height: 4),
            _buildSoundLayerSection(
              theme: theme,
              l10n: l10n,
              title: l10n.dspSectionEvents,
              layerType: 'events',
              selectedCount: _selectedEvents.length,
              maxCount: DspConstants.maxEventSlots,
              isSelected: (a) => _selectedEvents.any((e) => e.id == a.id),
              onTap: _onEventTapped,
            ),
            const SizedBox(height: 16),

            // Gain Controls
            _buildSectionTitle(theme, l10n.dspGainControls),
            _buildGainSlider(theme, l10n.dspSectionBase, _baseGain, (v) {
              setState(() => _baseGain = v);
              _dspService.setBaseGain(v);
            }),
            _buildGainSlider(theme, l10n.dspSectionTexture, _textureGain, (v) {
              setState(() => _textureGain = v);
              _dspService.setTextureGain(v);
            }),
            _buildGainSlider(theme, l10n.dspSectionEvents, _eventGain, (v) {
              setState(() => _eventGain = v);
              _dspService.setEventGain(v);
            }),
            _buildGainSlider(theme, l10n.dspBinauralMode, _binauralGain, (v) {
              setState(() => _binauralGain = v);
              _dspService.setBinauralGain(v);
            }),
            _buildGainSlider(theme, 'Master', _masterGain, (v) {
              setState(() => _masterGain = v);
              _dspService.setMasterGain(v);
            }),
            const SizedBox(height: 16),

            // Binaural Configuration
            _buildSectionTitle(theme, l10n.dspBinauralConfig),
            _buildNumberField(
              _carrierFreqCtrl,
              l10n.dspCarrierFrequency,
              enabled: !_isPlaying,
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: Text(
                l10n.dspBinauralMode,
                style: theme.textTheme.bodyMedium,
              ),
              subtitle: Text(
                _binauralEnabled
                    ? l10n.dspBinauralStereo
                    : l10n.dspBinauralMono,
                style: theme.textTheme.bodySmall,
              ),
              value: _binauralEnabled,
              onChanged: _isPlaying
                  ? null
                  : (val) => setState(() => _binauralEnabled = val),
              dense: true,
            ),
            const SizedBox(height: 8),

            // Cycle Steps
            _buildSectionTitle(theme, l10n.dspCycleSteps),
            ..._cycleSteps.asMap().entries.map((entry) {
              final i = entry.key;
              final step = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildNumberField(
                        step.deltaCtrl,
                        l10n.dspDeltaHz,
                        enabled: !_isPlaying,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildNumberField(
                        step.durationCtrl,
                        l10n.dspDurationS,
                        enabled: !_isPlaying,
                      ),
                    ),
                    SizedBox(
                      width: 32,
                      child: Checkbox(
                        value: step.oneshot,
                        onChanged: _isPlaying
                            ? null
                            : (val) =>
                                  setState(() => step.oneshot = val ?? false),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    if (!_isPlaying && _cycleSteps.length > 1)
                      IconButton(
                        icon: Icon(
                          Icons.remove_circle,
                          color: colorScheme.error,
                        ),
                        onPressed: () => _removeCycleStep(i),
                        iconSize: 20,
                      ),
                  ],
                ),
              );
            }),
            if (!_isPlaying)
              TextButton.icon(
                onPressed: _addCycleStep,
                icon: const Icon(Icons.add, size: 18),
                label: Text(l10n.dspAddStep),
              ),
            const SizedBox(height: 24),

            // Play / Stop
            _buildPlayStopButtons(theme, colorScheme, l10n),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Sound layer accordion sections
  // ---------------------------------------------------------------------------

  Widget _buildSoundLayerSection({
    required ThemeData theme,
    required AppLocalizations l10n,
    required String title,
    required String layerType,
    required int selectedCount,
    required int maxCount,
    required bool Function(AudioAsset) isSelected,
    required Future<void> Function(AudioAsset) onTap,
  }) {
    final colorScheme = theme.colorScheme;
    final assets = _assetService.assetsForLayer(layerType);
    final counter = l10n.dspSelectedCount(selectedCount, maxCount);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Row(
          children: [
            Expanded(child: Text(title, style: theme.textTheme.titleSmall)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: selectedCount > 0
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                counter,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: selectedCount > 0
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
          if (assets.isEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                l10n.dspNoSelection,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: assets.map((asset) {
                final selected = isSelected(asset);
                final loading =
                    _loadingIds.contains(asset.id) ||
                    (_baseLoading && _selectedBase?.id == asset.id);
                final atLimit = !selected && selectedCount >= maxCount;
                final name = DspAssetService.resolveLocalizedName(
                  context,
                  asset,
                );

                return _SoundCard(
                  asset: asset,
                  name: name,
                  selected: selected,
                  loading: loading,
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

  // ---------------------------------------------------------------------------
  // Widget helpers
  // ---------------------------------------------------------------------------

  Widget _buildStatusCard(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      color: _isPlaying
          ? colorScheme.primaryContainer
          : colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          _statusMessage!,
          style: theme.textTheme.titleSmall?.copyWith(
            color: _isPlaying
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
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

  Widget _buildNumberField(
    TextEditingController ctrl,
    String hint, {
    bool enabled = true,
  }) {
    return TextField(
      controller: ctrl,
      enabled: enabled,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
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

  Widget _buildPlayStopButtons(
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    if (!_isPlaying) {
      return SizedBox(
        height: 56,
        child: FilledButton.icon(
          onPressed: _anyLoading ? null : _play,
          icon: _anyLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.play_arrow, size: 28),
          label: Text(
            _anyLoading ? l10n.dspLoading : l10n.dspPlay,
            style: theme.textTheme.titleMedium,
          ),
        ),
      );
    }
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 56,
            child: FilledButton.icon(
              onPressed: _isStopping ? null : _stop,
              icon: const Icon(Icons.stop, size: 24),
              label: Text(l10n.dspStop, style: theme.textTheme.titleSmall),
              style: FilledButton.styleFrom(backgroundColor: colorScheme.error),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 56,
            child: FilledButton.tonalIcon(
              onPressed: _isStopping ? null : _stopGraceful,
              icon: _isStopping
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.timelapse, size: 24),
              label: Text(
                _isStopping ? l10n.dspFinishing : l10n.dspGraceful,
                style: theme.textTheme.titleSmall,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Sound card widget
// ---------------------------------------------------------------------------

class _SoundCard extends StatelessWidget {
  const _SoundCard({
    required this.asset,
    required this.name,
    required this.selected,
    required this.loading,
    required this.disabled,
    required this.theme,
    required this.onTap,
  });

  final AudioAsset asset;
  final String name;
  final bool selected;
  final bool loading;
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
                  child: loading
                      ? const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : asset.iconAsset.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            asset.iconAsset,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, trace) => Icon(
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

class _CycleStepEntry {
  _CycleStepEntry({required this.deltaCtrl, required this.durationCtrl});

  final TextEditingController deltaCtrl;
  final TextEditingController durationCtrl;
  bool oneshot = false;
}
