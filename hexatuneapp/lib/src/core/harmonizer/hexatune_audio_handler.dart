// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';
import 'dart:convert';

import 'package:audio_service/audio_service.dart';

import 'package:hexatuneapp/src/core/harmonizer/harmonizer_service.dart';
import 'package:hexatuneapp/src/core/harmonizer/models/generation_type.dart';
import 'package:hexatuneapp/src/core/harmonizer/models/harmonizer_config.dart';
import 'package:hexatuneapp/src/core/harmonizer/models/harmonizer_state.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/rest/harmonics/models/harmonic_packet_dto.dart';
import 'package:hexatuneapp/src/core/storage/preferences_service.dart';

/// Bridges the OS media session (lock screen / notification controls) with
/// [HarmonizerService].
///
/// Subscribes to [HarmonizerService.state] and maps each [HarmonizerState]
/// to [PlaybackState] + [MediaItem] for the platform media session.
///
/// Lock screen commands:
/// - **play** → resume last formula from [PreferencesService]
/// - **stop** → graceful stop (waits for cycle completion)
/// - **customAction('immediateStop')** → immediate stop
///
/// Also persists last session config and writes widget state for future
/// home screen widget support.
class HexaTuneAudioHandler extends BaseAudioHandler {
  HexaTuneAudioHandler(this._harmonizer, this._prefs, this._log) {
    _stateSubscription = _harmonizer.state.listen(_onStateChanged);
  }

  final HarmonizerService _harmonizer;
  final PreferencesService _prefs;
  final LogService _log;

  StreamSubscription<HarmonizerState>? _stateSubscription;
  HarmonizerStatus? _previousStatus;

  /// Custom action name for immediate (forced) stop.
  static const immediateStopAction = 'immediateStop';

  /// [PreferencesService] key for the last played session config (JSON).
  static const lastConfigKey = 'harmonizer_last_config';

  // Widget state keys.
  static const widgetIsPlayingKey = 'widget_is_playing';
  static const widgetFormulaNameKey = 'widget_formula_name';
  static const widgetGenerationTypeKey = 'widget_generation_type';
  static const widgetRemainingSecondsKey = 'widget_remaining_seconds';

  // ---------------------------------------------------------------------------
  // Lock screen commands
  // ---------------------------------------------------------------------------

  @override
  Future<void> play() async {
    _log.info('AudioHandler: play (resume last)', category: LogCategory.dsp);
    final config = _loadLastConfig();
    if (config == null) {
      _log.warning(
        'AudioHandler: no saved config to resume',
        category: LogCategory.dsp,
      );
      return;
    }
    await _harmonizer.play(config);
  }

  @override
  Future<void> stop() async {
    _log.info('AudioHandler: graceful stop', category: LogCategory.dsp);
    await _harmonizer.stopGraceful();
  }

  @override
  Future<void> customAction(String name, [Map<String, dynamic>? extras]) async {
    if (name == immediateStopAction) {
      _log.info('AudioHandler: immediate stop', category: LogCategory.dsp);
      await _harmonizer.stopImmediate();
    }
  }

  // ---------------------------------------------------------------------------
  // State synchronization
  // ---------------------------------------------------------------------------

  void _onStateChanged(HarmonizerState state) {
    _publishPlaybackState(state);
    _publishMediaItem(state);
    _writeWidgetState(state);

    // Persist config once on transition to playing.
    if (state.status == HarmonizerStatus.playing &&
        _previousStatus != HarmonizerStatus.playing) {
      _saveLastConfig(state);
    }
    _previousStatus = state.status;
  }

  void _publishPlaybackState(HarmonizerState state) {
    playbackState.add(
      PlaybackState(
        controls: _controlsForStatus(state.status),
        systemActions: const {MediaAction.stop},
        processingState: _mapProcessingState(state.status),
        playing:
            state.status == HarmonizerStatus.playing ||
            state.status == HarmonizerStatus.stopping,
        updatePosition: _elapsed(state),
      ),
    );
  }

  Duration _elapsed(HarmonizerState state) {
    final total = state.isFirstCycle
        ? state.firstCycleDuration
        : state.totalCycleDuration;
    final elapsed = total - state.remainingInCycle;
    return elapsed.isNegative ? Duration.zero : elapsed;
  }

  List<MediaControl> _controlsForStatus(HarmonizerStatus status) {
    return switch (status) {
      HarmonizerStatus.playing => [
        MediaControl.stop,
        const MediaControl(
          androidIcon: 'drawable/audio_service_stop',
          label: 'Stop Now',
          action: MediaAction.custom,
        ),
      ],
      HarmonizerStatus.stopping => [
        const MediaControl(
          androidIcon: 'drawable/audio_service_stop',
          label: 'Stop Now',
          action: MediaAction.custom,
        ),
      ],
      _ => const [],
    };
  }

  AudioProcessingState _mapProcessingState(HarmonizerStatus status) {
    return switch (status) {
      HarmonizerStatus.idle => AudioProcessingState.idle,
      HarmonizerStatus.preparing => AudioProcessingState.loading,
      HarmonizerStatus.playing => AudioProcessingState.ready,
      HarmonizerStatus.stopping => AudioProcessingState.ready,
      HarmonizerStatus.error => AudioProcessingState.error,
    };
  }

  void _publishMediaItem(HarmonizerState state) {
    if (state.status == HarmonizerStatus.playing ||
        state.status == HarmonizerStatus.stopping ||
        state.status == HarmonizerStatus.preparing) {
      final typeName = state.activeType?.name ?? 'Unknown';
      final formulaId = state.formulaId ?? 'Unknown';
      mediaItem.add(
        MediaItem(
          id: formulaId,
          title: 'Formula $formulaId',
          artist: 'HexaTune — $typeName',
          album: 'HexaTune',
          duration: state.isFirstCycle
              ? state.firstCycleDuration
              : state.totalCycleDuration,
        ),
      );
    } else {
      mediaItem.add(null);
    }
  }

  // ---------------------------------------------------------------------------
  // Last session persistence
  // ---------------------------------------------------------------------------

  Future<void> _saveLastConfig(HarmonizerState state) async {
    try {
      final type = state.activeType;
      if (type == null || state.sequence.isEmpty) return;
      final json = jsonEncode({
        'type': type.name,
        'ambienceId': state.ambienceId,
        'formulaId': state.formulaId,
        'steps': state.sequence.map((s) => s.toJson()).toList(),
      });
      await _prefs.setString(lastConfigKey, json);
    } catch (e) {
      _log.warning(
        'AudioHandler: failed to save last config: $e',
        category: LogCategory.dsp,
      );
    }
  }

  HarmonizerConfig? _loadLastConfig() {
    try {
      final raw = _prefs.getString(lastConfigKey);
      if (raw == null || raw.isEmpty) return null;
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return HarmonizerConfig(
        type: GenerationType.values.byName(map['type'] as String),
        ambienceId: map['ambienceId'] as String?,
        formulaId: map['formulaId'] as String?,
        steps: (map['steps'] as List)
            .map((j) => HarmonicPacketDto.fromJson(j as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      _log.warning(
        'AudioHandler: failed to load last config: $e',
        category: LogCategory.dsp,
      );
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Widget state (passive "now playing" for future home screen widget)
  // ---------------------------------------------------------------------------

  void _writeWidgetState(HarmonizerState state) {
    final isPlaying =
        state.status == HarmonizerStatus.playing ||
        state.status == HarmonizerStatus.stopping;
    _prefs.setBool(widgetIsPlayingKey, isPlaying);
    _prefs.setString(widgetFormulaNameKey, state.formulaId ?? '');
    _prefs.setString(widgetGenerationTypeKey, state.activeType?.name ?? '');
    _prefs.setInt(widgetRemainingSecondsKey, state.remainingInCycle.inSeconds);
  }

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  /// Cancels the state stream subscription.
  void dispose() {
    _stateSubscription?.cancel();
    _stateSubscription = null;
  }
}
