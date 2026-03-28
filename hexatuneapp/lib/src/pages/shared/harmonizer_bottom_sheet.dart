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
import 'package:hexatuneapp/src/pages/shared/app_snack_bar.dart';
import 'package:hexatuneapp/src/pages/shared/harmonizer_widget.dart';

/// Opens a modal bottom sheet containing the [HarmonizerWidget] with full
/// state management for formula selection, harmonize/stop controls, and
/// hardware status monitoring.
void showHarmonizerSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    builder: (ctx) => const _HarmonizerSheetContent(),
  );
}

/// Stateful wrapper that provides [HarmonizerWidget] with all required
/// services and reactive state management.
class _HarmonizerSheetContent extends StatefulWidget {
  const _HarmonizerSheetContent();

  @override
  State<_HarmonizerSheetContent> createState() =>
      _HarmonizerSheetContentState();
}

class _HarmonizerSheetContentState extends State<_HarmonizerSheetContent> {
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

    _harmonizerState = _harmonizer.currentState;
    if (_harmonizerState.status != HarmonizerStatus.idle) {
      _selectedType = _harmonizerState.activeType ?? GenerationType.monaural;
    }

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
    _loadAmbiences();
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
          _restoreFormulaFromState();
        });
      }
    } catch (e) {
      if (mounted) setState(() => _formulasLoading = false);
    }
  }

  Future<void> _loadAmbiences() async {
    await _ambienceService.load();
    if (mounted) {
      setState(() {
        _restoreAmbienceFromState();
      });
    }
  }

  void _restoreFormulaFromState() {
    final formulaId = _harmonizerState.formulaId;
    if (formulaId == null) return;
    if (_harmonizerState.status == HarmonizerStatus.idle) return;

    for (final f in _formulas) {
      if (f.id == formulaId) {
        _selectedFormula = f;
        return;
      }
    }
  }

  void _restoreAmbienceFromState() {
    final ambienceId = _harmonizerState.ambienceId;
    if (ambienceId == null) return;
    if (_harmonizerState.status == HarmonizerStatus.idle) return;

    _selectedAmbience = _ambienceService.findById(ambienceId);
  }

  // ---------------------------------------------------------------------------
  // Harmonize / Stop
  // ---------------------------------------------------------------------------

  Future<void> _harmonize() async {
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
        formulaId: _selectedFormula!.id,
      );

      final error = await _harmonizer.harmonize(config);
      if (error != null && mounted) {
        AppSnackBar.success(context, message: error);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _generating = false);
        AppSnackBar.success(context, message: e.toString());
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

  void _onAmbienceChanged(AmbienceConfig? config) {
    setState(() => _selectedAmbience = config);
    if (_harmonizerState.status == HarmonizerStatus.harmonizing) {
      _harmonizer.changeAmbience(config?.id);
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  bool get _isActive =>
      _harmonizerState.status == HarmonizerStatus.harmonizing ||
      _harmonizerState.status == HarmonizerStatus.preparing ||
      _harmonizerState.status == HarmonizerStatus.stopping ||
      _generating;

  bool get _canHarmonize {
    if (_isActive) return false;
    if (_selectedFormula == null) return false;

    final validation = _harmonizer.validatePrerequisites(_selectedType);
    return validation == HarmonizerValidation.valid;
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFormulaSelector(theme, l10n),
            const SizedBox(height: 16),
            HarmonizerWidget(
              selectedType: _selectedType,
              harmonizerState: _harmonizerState,
              headsetConnected: _headsetConnected,
              hexagenConnected: _hexagenConnected,
              selectedAmbience: _selectedAmbience,
              ambienceConfigs: _ambienceService.configs,
              isActive: _isActive,
              generating: _generating,
              canHarmonize: _canHarmonize,
              onTypeChanged: (type) => setState(() => _selectedType = type),
              onAmbienceChanged: _onAmbienceChanged,
              onHarmonize: _harmonize,
              onStopGraceful: _stopGraceful,
              onImmediateStart: _startImmediateTimer,
              onImmediateEnd: _cancelImmediateTimer,
            ),
          ],
        ),
      ),
    );
  }

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
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: l10n.harmonizerFormulaLabel,
            border: InputBorder.none,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<FormulaResponse?>(
              value: _selectedFormula,
              hint: Text(l10n.harmonizerSelectFormula),
              isExpanded: true,
              items: _formulas
                  .map(
                    (f) => DropdownMenuItem<FormulaResponse?>(
                      value: f,
                      child: Text(f.name),
                    ),
                  )
                  .toList(),
              onChanged: _isActive
                  ? null
                  : (f) => setState(() => _selectedFormula = f),
            ),
          ),
        ),
      ),
    );
  }
}
