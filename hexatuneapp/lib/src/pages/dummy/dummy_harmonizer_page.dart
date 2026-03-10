// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/dsp/ambience/ambience_service.dart';
import 'package:hexatuneapp/src/core/dsp/ambience/models/ambience_config.dart';
import 'package:hexatuneapp/src/core/hardware/headset/headset_service.dart';
import 'package:hexatuneapp/src/core/hardware/headset/headset_state.dart';
import 'package:hexatuneapp/src/core/hardware/hexagen/hexagen_service.dart';
import 'package:hexatuneapp/src/core/hardware/hexagen/models/hexagen_state.dart';
import 'package:hexatuneapp/src/core/harmonizer/harmonizer_service.dart';
import 'package:hexatuneapp/src/core/harmonizer/models/generation_type.dart';
import 'package:hexatuneapp/src/core/harmonizer/models/harmonizer_config.dart';
import 'package:hexatuneapp/src/core/harmonizer/models/harmonizer_state.dart';
import 'package:hexatuneapp/src/core/harmonizer/models/harmonizer_validation.dart';
import 'package:hexatuneapp/src/core/rest/formula/formula_repository.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/formula_response.dart';
import 'package:hexatuneapp/src/core/rest/harmonics/harmonics_repository.dart';
import 'package:hexatuneapp/src/core/rest/harmonics/models/generate_harmonics_request.dart';

/// Dummy page for testing the Harmonizer player.
///
/// Formula selection sits above the [HarmonizerPlayerWidget] which contains
/// the tabbed type selector, ambience/warning area, and play/stop controls
/// inside a single bordered container.
class DummyHarmonizerPage extends StatefulWidget {
  const DummyHarmonizerPage({super.key});

  @override
  State<DummyHarmonizerPage> createState() => _DummyHarmonizerPageState();
}

class _DummyHarmonizerPageState extends State<DummyHarmonizerPage> {
  late final HarmonizerService _harmonizer;
  late final AmbienceService _ambienceService;
  late final HeadsetService _headsetService;
  late final HexagenService _hexagenService;
  late final FormulaRepository _formulaRepo;
  late final HarmonicsRepository _harmonicsRepo;

  StreamSubscription<HarmonizerState>? _harmonizerSub;
  StreamSubscription<HeadsetState>? _headsetSub;
  StreamSubscription<HexagenState>? _hexagenSub;

  GenerationType _selectedType = GenerationType.monaural;
  FormulaResponse? _selectedFormula;
  AmbienceConfig? _selectedAmbience;

  List<FormulaResponse> _formulas = [];
  bool _formulasLoading = true;
  bool _generating = false;

  HarmonizerState _harmonizerState = const HarmonizerState();
  bool _headsetConnected = false;
  bool _hexagenConnected = false;

  @override
  void initState() {
    super.initState();
    _harmonizer = getIt<HarmonizerService>();
    _ambienceService = getIt<AmbienceService>();
    _headsetService = getIt<HeadsetService>();
    _hexagenService = getIt<HexagenService>();
    _formulaRepo = getIt<FormulaRepository>();
    _harmonicsRepo = getIt<HarmonicsRepository>();

    _headsetConnected = _headsetService.isConnected;
    _hexagenConnected = _hexagenService.isConnected;

    _harmonizerSub = _harmonizer.state.listen((s) {
      if (mounted) setState(() => _harmonizerState = s);
    });

    _headsetSub = _headsetService.state.listen((s) {
      if (mounted) setState(() => _headsetConnected = s.isAnyConnected);
    });

    _hexagenSub = _hexagenService.state.listen((s) {
      if (mounted) setState(() => _hexagenConnected = s.isConnected);
    });

    _loadFormulas();
    _ambienceService.load();
  }

  @override
  void dispose() {
    _harmonizerSub?.cancel();
    _headsetSub?.cancel();
    _hexagenSub?.cancel();
    _immediateTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadFormulas() async {
    try {
      final result = await _formulaRepo.list();
      if (mounted) {
        setState(() {
          _formulas = result.data;
          _formulasLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _formulasLoading = false);
    }
  }

  // ---------------------------------------------------------------------------
  // Play / Stop
  // ---------------------------------------------------------------------------

  Future<void> _play() async {
    if (_selectedFormula == null) return;

    setState(() => _generating = true);

    try {
      final response = await _harmonicsRepo.generate(
        GenerateHarmonicsRequest(
          generationType: _selectedType.apiValue,
          sourceType: 'Formula',
          sourceId: _selectedFormula!.id,
        ),
      );

      if (!mounted) return;
      setState(() => _generating = false);

      if (response.sequence.isEmpty) return;

      final config = HarmonizerConfig(
        type: _selectedType,
        ambienceId: _selectedAmbience?.id,
        steps: response.sequence,
      );

      final error = await _harmonizer.play(config);
      if (error != null && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _generating = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> _stopGraceful() async {
    await _harmonizer.stopGraceful();
  }

  Future<void> _stopImmediate() async {
    await _harmonizer.stopImmediate();
  }

  Timer? _immediateTimer;

  void _startImmediateTimer() {
    _immediateTimer?.cancel();
    _immediateTimer = Timer(const Duration(seconds: 3), () {
      _stopImmediate();
    });
  }

  void _cancelImmediateTimer() {
    _immediateTimer?.cancel();
    _immediateTimer = null;
  }

  void _navigateToAmbience() {
    Navigator.of(context).pushNamed('/dev/ambience');
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.harmonizerTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildFormulaSelector(theme, l10n),
          const SizedBox(height: 16),
          HarmonizerPlayerWidget(
            selectedType: _selectedType,
            harmonizerState: _harmonizerState,
            headsetConnected: _headsetConnected,
            hexagenConnected: _hexagenConnected,
            selectedAmbience: _selectedAmbience,
            ambienceConfigs: _ambienceService.configs,
            isActive: _isActive,
            generating: _generating,
            canPlay: _canPlay,
            onTypeChanged: (type) => setState(() => _selectedType = type),
            onAmbienceChanged: (c) => setState(() => _selectedAmbience = c),
            onAddAmbience: _navigateToAmbience,
            onPlay: _play,
            onStopGraceful: _stopGraceful,
            onImmediateStart: _startImmediateTimer,
            onImmediateEnd: _cancelImmediateTimer,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Formula Selector
  // ---------------------------------------------------------------------------

  Widget _buildFormulaSelector(ThemeData theme, AppLocalizations l10n) {
    if (_formulasLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_formulas.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            l10n.harmonizerNoFormulas,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: DropdownButtonFormField<FormulaResponse>(
          decoration: InputDecoration(
            labelText: l10n.harmonizerFormulaLabel,
            border: InputBorder.none,
          ),
          initialValue: _selectedFormula,
          hint: Text(l10n.harmonizerSelectFormula),
          items: _formulas
              .map((f) => DropdownMenuItem(value: f, child: Text(f.name)))
              .toList(),
          onChanged: _isActive
              ? null
              : (f) => setState(() => _selectedFormula = f),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  bool get _isActive =>
      _harmonizerState.status == HarmonizerStatus.playing ||
      _harmonizerState.status == HarmonizerStatus.preparing ||
      _harmonizerState.status == HarmonizerStatus.stopping ||
      _generating;

  bool get _canPlay {
    if (_isActive) return false;
    if (_selectedFormula == null) return false;

    final validation = _harmonizer.validatePrerequisites(_selectedType);
    return validation == HarmonizerValidation.valid;
  }
}

// =============================================================================
// HarmonizerPlayerWidget — single bordered container with tabs + controls
// =============================================================================

/// A standalone player widget with tabbed type selection, ambience/warning
/// area, and play/stop controls inside a single rounded container.
class HarmonizerPlayerWidget extends StatelessWidget {
  const HarmonizerPlayerWidget({
    required this.selectedType,
    required this.harmonizerState,
    required this.headsetConnected,
    required this.hexagenConnected,
    required this.selectedAmbience,
    required this.ambienceConfigs,
    required this.isActive,
    required this.generating,
    required this.canPlay,
    required this.onTypeChanged,
    required this.onAmbienceChanged,
    required this.onAddAmbience,
    required this.onPlay,
    required this.onStopGraceful,
    required this.onImmediateStart,
    required this.onImmediateEnd,
    super.key,
  });

  final GenerationType selectedType;
  final HarmonizerState harmonizerState;
  final bool headsetConnected;
  final bool hexagenConnected;
  final AmbienceConfig? selectedAmbience;
  final List<AmbienceConfig> ambienceConfigs;
  final bool isActive;
  final bool generating;
  final bool canPlay;
  final ValueChanged<GenerationType> onTypeChanged;
  final ValueChanged<AmbienceConfig?> onAmbienceChanged;
  final VoidCallback onAddAmbience;
  final VoidCallback onPlay;
  final VoidCallback onStopGraceful;
  final VoidCallback onImmediateStart;
  final VoidCallback onImmediateEnd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- Type tabs ---
          _TypeTabBar(
            selectedType: selectedType,
            isActive: isActive,
            onTypeChanged: onTypeChanged,
          ),

          // --- Top half: type-specific content ---
          _buildTypeContent(theme, l10n, colorScheme),

          Divider(height: 1, color: colorScheme.outlineVariant),

          // --- Bottom half: timer + play/stop ---
          _buildControls(theme, l10n, colorScheme),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Top-half: type-specific content (ambience / warnings / coming soon)
  // ---------------------------------------------------------------------------

  Widget _buildTypeContent(
    ThemeData theme,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: _typeContentBody(theme, l10n, colorScheme),
    );
  }

  Widget _typeContentBody(
    ThemeData theme,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    // Photonic / Quantal — coming soon
    if (!selectedType.isActive) {
      return _buildInfoRow(
        theme,
        colorScheme,
        Icons.schedule,
        _typeLabel(selectedType, l10n),
        l10n.harmonizerComingSoon,
        isWarning: false,
      );
    }

    // Magnetic
    if (selectedType == GenerationType.magnetic) {
      if (!hexagenConnected) {
        return _buildInfoRow(
          theme,
          colorScheme,
          Icons.cable_outlined,
          l10n.harmonizerTypeMagnetic,
          l10n.harmonizerHexagenRequired,
          isWarning: true,
        );
      }
      return _buildTypeLabel(theme, l10n.harmonizerTypeMagnetic);
    }

    // Binaural — headset check
    if (selectedType == GenerationType.binaural && !headsetConnected) {
      return _buildInfoRow(
        theme,
        colorScheme,
        Icons.headphones_outlined,
        l10n.harmonizerTypeBinaural,
        l10n.harmonizerHeadsetRequired,
        isWarning: true,
      );
    }

    // Monaural or Binaural (headset connected) — show ambience selector
    final typeText = selectedType == GenerationType.binaural
        ? l10n.harmonizerTypeBinaural
        : l10n.harmonizerTypeMonaural;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(typeText, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        _buildAmbienceRow(theme, l10n, colorScheme),
      ],
    );
  }

  Widget _buildInfoRow(
    ThemeData theme,
    ColorScheme colorScheme,
    IconData icon,
    String title,
    String subtitle, {
    required bool isWarning,
  }) {
    final contentColor = isWarning
        ? colorScheme.error
        : colorScheme.onSurfaceVariant;

    return Row(
      children: [
        Icon(icon, color: contentColor, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(color: contentColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTypeLabel(ThemeData theme, String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(label, style: theme.textTheme.titleMedium),
    );
  }

  Widget _buildAmbienceRow(
    ThemeData theme,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<AmbienceConfig?>(
            decoration: InputDecoration(
              labelText: l10n.harmonizerSelectAmbience,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            initialValue: selectedAmbience,
            items: [
              DropdownMenuItem<AmbienceConfig?>(
                value: null,
                child: Text(l10n.harmonizerNoAmbience),
              ),
              ...ambienceConfigs.map(
                (c) => DropdownMenuItem(value: c, child: Text(c.name)),
              ),
            ],
            onChanged: isActive ? null : onAmbienceChanged,
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filled(
          icon: const Icon(Icons.add),
          tooltip: l10n.harmonizerAddAmbience,
          onPressed: isActive ? null : onAddAmbience,
          style: IconButton.styleFrom(
            backgroundColor: colorScheme.primaryContainer,
            foregroundColor: colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Bottom-half: Total Time | Play/Stop | Remaining
  // ---------------------------------------------------------------------------

  Widget _buildControls(
    ThemeData theme,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    final isPlaying =
        harmonizerState.status == HarmonizerStatus.playing ||
        harmonizerState.status == HarmonizerStatus.stopping;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              // Left: Total Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.harmonizerTotalDuration,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: colorScheme.outlineVariant,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isPlaying
                          ? _formatDuration(
                              harmonizerState.isFirstCycle
                                  ? harmonizerState.firstCycleDuration
                                  : harmonizerState.totalCycleDuration,
                            )
                          : '--:--',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),

              // Center: Play / Stop button
              _buildCenterButton(theme, l10n, colorScheme, isPlaying),

              // Right: Remaining
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l10n.harmonizerRemaining,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: colorScheme.outlineVariant,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isPlaying
                          ? _formatDuration(harmonizerState.remainingInCycle)
                          : '--:--',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: colorScheme.primary,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Error text
          if (harmonizerState.status == HarmonizerStatus.error &&
              harmonizerState.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                l10n.harmonizerError(harmonizerState.errorMessage!),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCenterButton(
    ThemeData theme,
    AppLocalizations l10n,
    ColorScheme colorScheme,
    bool isPlaying,
  ) {
    const double size = 64;

    if (generating) {
      return const SizedBox(
        width: size,
        height: size,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (isPlaying) {
      return GestureDetector(
        onLongPressStart: (_) => onImmediateStart(),
        onLongPressEnd: (_) => onImmediateEnd(),
        child: Container(
          width: size,
          height: size,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.error,
          ),
          child: IconButton(
            icon: Icon(
              Icons.stop_rounded,
              color: colorScheme.onError,
              size: 36,
            ),
            onPressed: onStopGraceful,
          ),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: canPlay ? colorScheme.primary : colorScheme.surfaceContainerHigh,
      ),
      child: IconButton(
        icon: Icon(
          Icons.play_arrow_rounded,
          color: canPlay
              ? colorScheme.onPrimary
              : colorScheme.onSurface.withAlpha(97),
          size: 36,
        ),
        onPressed: canPlay ? onPlay : null,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  String _typeLabel(GenerationType type, AppLocalizations l10n) {
    return switch (type) {
      GenerationType.monaural => l10n.harmonizerTypeMonaural,
      GenerationType.binaural => l10n.harmonizerTypeBinaural,
      GenerationType.magnetic => l10n.harmonizerTypeMagnetic,
      GenerationType.photonic => l10n.harmonizerTypePhotonic,
      GenerationType.quantal => l10n.harmonizerTypeQuantal,
    };
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}

// =============================================================================
// _TypeTabBar — five tabs at the top of the container
// =============================================================================

class _TypeTabBar extends StatelessWidget {
  const _TypeTabBar({
    required this.selectedType,
    required this.isActive,
    required this.onTypeChanged,
  });

  final GenerationType selectedType;
  final bool isActive;
  final ValueChanged<GenerationType> onTypeChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Row(
        children: GenerationType.values.map((type) {
          final isSelected = selectedType == type;
          return _buildTab(theme, colorScheme, l10n, type, isSelected);
        }).toList(),
      ),
    );
  }

  Widget _buildTab(
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations l10n,
    GenerationType type,
    bool isSelected,
  ) {
    final label = _shortLabel(type, l10n);
    final icon = _typeIcon(type);
    final canTap = !isActive && type.isActive;

    return Expanded(
      child: GestureDetector(
        onTap: canTap || (!isActive && !type.isActive)
            ? () => onTypeChanged(type)
            : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.surface : null,
            border: isSelected
                ? Border(
                    bottom: BorderSide(color: colorScheme.primary, width: 2),
                  )
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected
                    ? colorScheme.primary
                    : !type.isActive
                    ? colorScheme.onSurface.withAlpha(97)
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? colorScheme.primary
                      : !type.isActive
                      ? colorScheme.onSurface.withAlpha(97)
                      : colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.bold : null,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _typeIcon(GenerationType type) {
    return switch (type) {
      GenerationType.monaural => Icons.speaker_outlined,
      GenerationType.binaural => Icons.headphones_outlined,
      GenerationType.magnetic => Icons.waves_outlined,
      GenerationType.photonic => Icons.lock_outline,
      GenerationType.quantal => Icons.lock_outline,
    };
  }

  String _shortLabel(GenerationType type, AppLocalizations l10n) {
    return switch (type) {
      GenerationType.monaural => l10n.harmonizerTypeMonaural,
      GenerationType.binaural => l10n.harmonizerTypeBinaural,
      GenerationType.magnetic => l10n.harmonizerTypeMagnetic,
      GenerationType.photonic => l10n.harmonizerTypePhotonic,
      GenerationType.quantal => l10n.harmonizerTypeQuantal,
    };
  }
}
