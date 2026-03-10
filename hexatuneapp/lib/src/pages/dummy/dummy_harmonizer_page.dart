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
/// Provides formula selection, generation type selection, ambience selection,
/// play/stop controls, and real-time hardware status monitoring.
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

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.harmonizerTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Formula selector
          _buildFormulaSelector(theme, l10n),
          const SizedBox(height: 16),

          // Generation type chips
          _buildTypeChips(theme, l10n),
          const SizedBox(height: 16),

          // Hardware warning / ambience container
          _buildMiddleContainer(theme, l10n, colorScheme),
          const SizedBox(height: 16),

          // Player controls
          _buildPlayerControls(theme, l10n, colorScheme),
          const SizedBox(height: 16),

          // Sequence display
          if (_harmonizerState.sequence.isNotEmpty)
            _buildSequenceList(theme, l10n),
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
  // Type Chips
  // ---------------------------------------------------------------------------

  Widget _buildTypeChips(ThemeData theme, AppLocalizations l10n) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: GenerationType.values.map((type) {
        final label = _typeLabel(type, l10n);
        final isSelected = _selectedType == type;
        final isActive = type.isActive;

        return ChoiceChip(
          label: Text(label),
          selected: isSelected,
          onSelected: _isActive
              ? null
              : isActive
              ? (_) => setState(() => _selectedType = type)
              : null,
          avatar: isActive ? null : const Icon(Icons.lock_outline, size: 18),
        );
      }).toList(),
    );
  }

  String _typeLabel(GenerationType type, AppLocalizations l10n) {
    return switch (type) {
      GenerationType.monaural => l10n.harmonizerTypeMonaural,
      GenerationType.binaural => l10n.harmonizerTypeBinaural,
      GenerationType.magnetic => l10n.harmonizerTypeMagnetic,
      GenerationType.photonic => l10n.harmonizerTypePhotonic,
      GenerationType.quantal => l10n.harmonizerTypeQuantal,
    };
  }

  // ---------------------------------------------------------------------------
  // Middle Container (Warnings + Ambience)
  // ---------------------------------------------------------------------------

  Widget _buildMiddleContainer(
    ThemeData theme,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    // Photonic / Quantal — coming soon
    if (!_selectedType.isActive) {
      return _buildWarningCard(
        theme,
        colorScheme,
        Icons.schedule,
        l10n.harmonizerComingSoon,
      );
    }

    // Magnetic — check HexaGen
    if (_selectedType == GenerationType.magnetic) {
      if (!_hexagenConnected) {
        return _buildWarningCard(
          theme,
          colorScheme,
          Icons.cable_outlined,
          l10n.harmonizerHexagenRequired,
        );
      }
      // No ambience for magnetic
      return const SizedBox.shrink();
    }

    // Binaural — check headset
    if (_selectedType == GenerationType.binaural && !_headsetConnected) {
      return Column(
        children: [
          _buildWarningCard(
            theme,
            colorScheme,
            Icons.headphones_outlined,
            l10n.harmonizerHeadsetRequired,
          ),
          const SizedBox(height: 8),
          _buildAmbienceSelector(theme, l10n),
        ],
      );
    }

    // Monaural or Binaural (headset connected) — ambience only
    return _buildAmbienceSelector(theme, l10n);
  }

  Widget _buildWarningCard(
    ThemeData theme,
    ColorScheme colorScheme,
    IconData icon,
    String message,
  ) {
    return Card(
      color: colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.onErrorContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Ambience Selector
  // ---------------------------------------------------------------------------

  Widget _buildAmbienceSelector(ThemeData theme, AppLocalizations l10n) {
    final configs = _ambienceService.configs;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<AmbienceConfig?>(
                decoration: InputDecoration(
                  labelText: l10n.harmonizerSelectAmbience,
                  border: InputBorder.none,
                ),
                initialValue: _selectedAmbience,
                items: [
                  DropdownMenuItem<AmbienceConfig?>(
                    value: null,
                    child: Text(l10n.harmonizerNoAmbience),
                  ),
                  ...configs.map(
                    (c) => DropdownMenuItem(value: c, child: Text(c.name)),
                  ),
                ],
                onChanged: _isActive
                    ? null
                    : (c) => setState(() => _selectedAmbience = c),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: l10n.harmonizerAddAmbience,
              onPressed: _isActive ? null : _navigateToAmbience,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAmbience() {
    Navigator.of(context).pushNamed('/dev/ambience');
  }

  // ---------------------------------------------------------------------------
  // Player Controls
  // ---------------------------------------------------------------------------

  Widget _buildPlayerControls(
    ThemeData theme,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    final isPlaying =
        _harmonizerState.status == HarmonizerStatus.playing ||
        _harmonizerState.status == HarmonizerStatus.stopping;
    final canPlay = _canPlay;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Duration row
            if (isPlaying) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.harmonizerTotalDuration,
                        style: theme.textTheme.labelSmall,
                      ),
                      Text(
                        _formatDuration(
                          _harmonizerState.isFirstCycle
                              ? _harmonizerState.firstCycleDuration
                              : _harmonizerState.totalCycleDuration,
                        ),
                        style: theme.textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        l10n.harmonizerRemaining,
                        style: theme.textTheme.labelSmall,
                      ),
                      Text(
                        _formatDuration(_harmonizerState.remainingInCycle),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                l10n.harmonizerCycle(_harmonizerState.currentCycle + 1),
                style: theme.textTheme.labelMedium,
              ),
              const SizedBox(height: 16),
            ],

            // Play / Stop button
            _buildActionButton(theme, l10n, colorScheme, isPlaying, canPlay),

            // Status text
            if (_harmonizerState.status == HarmonizerStatus.error &&
                _harmonizerState.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  l10n.harmonizerError(_harmonizerState.errorMessage!),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    ThemeData theme,
    AppLocalizations l10n,
    ColorScheme colorScheme,
    bool isPlaying,
    bool canPlay,
  ) {
    if (_generating) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: CircularProgressIndicator(),
      );
    }

    if (isPlaying) {
      return GestureDetector(
        onLongPressStart: (_) => _startImmediateTimer(),
        onLongPressEnd: (_) => _cancelImmediateTimer(),
        child: FilledButton.tonalIcon(
          icon: const Icon(Icons.stop),
          label: Text(
            _harmonizerState.status == HarmonizerStatus.stopping
                ? l10n.harmonizerStopping
                : l10n.harmonizerStop,
          ),
          onPressed: _stopGraceful,
        ),
      );
    }

    return FilledButton.icon(
      icon: const Icon(Icons.play_arrow),
      label: Text(l10n.harmonizerPlay),
      onPressed: canPlay ? _play : null,
    );
  }

  // ---------------------------------------------------------------------------
  // 3-second long-press for immediate stop
  // ---------------------------------------------------------------------------

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

  // ---------------------------------------------------------------------------
  // Sequence Display
  // ---------------------------------------------------------------------------

  Widget _buildSequenceList(ThemeData theme, AppLocalizations l10n) {
    final steps = _harmonizerState.sequence;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${l10n.harmonizerFormulaLabel} — ${steps.length} steps',
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        ...steps.asMap().entries.map((e) {
          final i = e.key;
          final step = e.value;
          final isCurrent =
              _harmonizerState.status == HarmonizerStatus.playing &&
              i == _harmonizerState.currentStepIndex;
          return Card(
            color: isCurrent ? theme.colorScheme.primaryContainer : null,
            child: ListTile(
              dense: true,
              leading: Text('${i + 1}', style: theme.textTheme.titleMedium),
              title: Text(
                l10n.harmonizerStep(
                  i + 1,
                  step.value,
                  (step.durationMs / 1000.0).toStringAsFixed(1),
                ),
              ),
              trailing: step.isOneShot
                  ? Chip(
                      label: Text(
                        l10n.harmonizerStepOneshot,
                        style: theme.textTheme.labelSmall,
                      ),
                      visualDensity: VisualDensity.compact,
                    )
                  : null,
            ),
          );
        }),
      ],
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

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}
