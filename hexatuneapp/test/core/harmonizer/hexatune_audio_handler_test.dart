// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';
import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/harmonizer/harmonizer_service.dart';
import 'package:hexatuneapp/src/core/harmonizer/hexatune_audio_handler.dart';
import 'package:hexatuneapp/src/core/harmonizer/models/generation_type.dart';
import 'package:hexatuneapp/src/core/harmonizer/models/harmonizer_config.dart';
import 'package:hexatuneapp/src/core/harmonizer/models/harmonizer_state.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/rest/harmonics/models/harmonic_packet_dto.dart';
import 'package:hexatuneapp/src/core/storage/preferences_service.dart';

class MockHarmonizerService extends Mock implements HarmonizerService {
  final _stateController = StreamController<HarmonizerState>.broadcast();

  @override
  Stream<HarmonizerState> get state => _stateController.stream;

  void emitState(HarmonizerState s) => _stateController.add(s);

  Future<void> closeStream() => _stateController.close();
}

class MockPreferencesService extends Mock implements PreferencesService {}

class MockLogService extends Mock implements LogService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(
      const HarmonizerConfig(type: GenerationType.monaural, steps: []),
    );
  });

  late MockHarmonizerService mockHarmonizer;
  late MockPreferencesService mockPrefs;
  late MockLogService mockLog;
  late HexaTuneAudioHandler handler;

  const testPackets = [
    HarmonicPacketDto(value: 440, durationMs: 30000, isOneShot: false),
    HarmonicPacketDto(value: 528, durationMs: 15000, isOneShot: true),
  ];

  const playingState = HarmonizerState(
    status: HarmonizerStatus.playing,
    activeType: GenerationType.monaural,
    formulaId: 'formula-123',
    sequence: testPackets,
    totalCycleDuration: Duration(seconds: 30),
    firstCycleDuration: Duration(seconds: 45),
    remainingInCycle: Duration(seconds: 20),
    isFirstCycle: true,
  );

  const stoppingState = HarmonizerState(
    status: HarmonizerStatus.stopping,
    activeType: GenerationType.monaural,
    formulaId: 'formula-123',
    sequence: testPackets,
    totalCycleDuration: Duration(seconds: 30),
    firstCycleDuration: Duration(seconds: 45),
    remainingInCycle: Duration(seconds: 5),
    gracefulStopRequested: true,
  );

  const preparingState = HarmonizerState(
    status: HarmonizerStatus.preparing,
    activeType: GenerationType.binaural,
    formulaId: 'formula-abc',
    sequence: testPackets,
  );

  const idleState = HarmonizerState();

  const errorState = HarmonizerState(
    status: HarmonizerStatus.error,
    errorMessage: 'Init failed',
  );

  setUp(() {
    mockHarmonizer = MockHarmonizerService();
    mockPrefs = MockPreferencesService();
    mockLog = MockLogService();

    // Default stubs for PreferencesService writes.
    when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async => true);
    when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
    when(() => mockPrefs.setInt(any(), any())).thenAnswer((_) async => true);
    when(() => mockPrefs.getString(any())).thenReturn(null);

    handler = HexaTuneAudioHandler(mockHarmonizer, mockPrefs, mockLog);
  });

  tearDown(() async {
    handler.dispose();
    await mockHarmonizer.closeStream();
  });

  // ---------------------------------------------------------------------------
  // Construction & initialization
  // ---------------------------------------------------------------------------

  group('construction', () {
    test('creates handler without errors', () {
      expect(handler, isNotNull);
    });

    test('initial playbackState is idle', () {
      // BaseAudioHandler starts with an empty PlaybackState.
      final state = handler.playbackState.value;
      expect(state.playing, isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // State mapping (HarmonizerState → PlaybackState)
  // ---------------------------------------------------------------------------

  group('state mapping', () {
    test('idle state maps to AudioProcessingState.completed', () async {
      mockHarmonizer.emitState(idleState);
      await Future<void>.delayed(Duration.zero);

      final ps = handler.playbackState.value;
      expect(ps.processingState, AudioProcessingState.completed);
      expect(ps.playing, isFalse);
      expect(ps.controls, isEmpty);
    });

    test('preparing state maps to AudioProcessingState.loading', () async {
      mockHarmonizer.emitState(preparingState);
      await Future<void>.delayed(Duration.zero);

      final ps = handler.playbackState.value;
      expect(ps.processingState, AudioProcessingState.loading);
      expect(ps.playing, isFalse);
      expect(ps.controls, isEmpty);
    });

    test(
      'playing state maps to AudioProcessingState.ready with controls',
      () async {
        mockHarmonizer.emitState(playingState);
        await Future<void>.delayed(Duration.zero);

        final ps = handler.playbackState.value;
        expect(ps.processingState, AudioProcessingState.ready);
        expect(ps.playing, isTrue);
        expect(ps.controls, hasLength(2));
        expect(ps.controls[0], MediaControl.stop);
        expect(ps.controls[1].action, MediaAction.custom);
        expect(ps.controls[1].label, 'Stop Now');
      },
    );

    test('stopping state maps to ready with immediate stop only', () async {
      mockHarmonizer.emitState(stoppingState);
      await Future<void>.delayed(Duration.zero);

      final ps = handler.playbackState.value;
      expect(ps.processingState, AudioProcessingState.ready);
      expect(ps.playing, isTrue);
      expect(ps.controls, hasLength(1));
      expect(ps.controls[0].action, MediaAction.custom);
    });

    test('error state maps to AudioProcessingState.error', () async {
      mockHarmonizer.emitState(errorState);
      await Future<void>.delayed(Duration.zero);

      final ps = handler.playbackState.value;
      expect(ps.processingState, AudioProcessingState.error);
      expect(ps.playing, isFalse);
      expect(ps.controls, isEmpty);
    });

    test('updatePosition reflects elapsed time', () async {
      mockHarmonizer.emitState(playingState);
      await Future<void>.delayed(Duration.zero);

      final ps = handler.playbackState.value;
      // first cycle: 45s total - 20s remaining = 25s elapsed
      expect(ps.updatePosition, const Duration(seconds: 25));
    });

    test('updatePosition is zero when remaining exceeds total', () async {
      const oddState = HarmonizerState(
        status: HarmonizerStatus.playing,
        activeType: GenerationType.monaural,
        totalCycleDuration: Duration(seconds: 10),
        firstCycleDuration: Duration(seconds: 10),
        remainingInCycle: Duration(seconds: 15),
        isFirstCycle: true,
      );
      mockHarmonizer.emitState(oddState);
      await Future<void>.delayed(Duration.zero);

      final ps = handler.playbackState.value;
      expect(ps.updatePosition, Duration.zero);
    });
  });

  // ---------------------------------------------------------------------------
  // MediaItem publishing
  // ---------------------------------------------------------------------------

  group('mediaItem', () {
    test('publishes MediaItem when playing', () async {
      mockHarmonizer.emitState(playingState);
      await Future<void>.delayed(Duration.zero);

      final item = handler.mediaItem.value;
      expect(item, isNotNull);
      expect(item!.id, 'formula-123');
      expect(item.title, contains('formula-123'));
      expect(item.artist, contains('monaural'));
      expect(item.album, 'HexaTune');
      expect(item.duration, const Duration(seconds: 45));
    });

    test('publishes MediaItem when preparing', () async {
      mockHarmonizer.emitState(preparingState);
      await Future<void>.delayed(Duration.zero);

      final item = handler.mediaItem.value;
      expect(item, isNotNull);
      expect(item!.artist, contains('binaural'));
    });

    test('publishes MediaItem when stopping', () async {
      mockHarmonizer.emitState(stoppingState);
      await Future<void>.delayed(Duration.zero);

      final item = handler.mediaItem.value;
      expect(item, isNotNull);
    });

    test('clears MediaItem on idle', () async {
      mockHarmonizer.emitState(playingState);
      await Future<void>.delayed(Duration.zero);
      expect(handler.mediaItem.value, isNotNull);

      mockHarmonizer.emitState(idleState);
      await Future<void>.delayed(Duration.zero);
      expect(handler.mediaItem.value, isNull);
    });

    test('clears MediaItem on error', () async {
      mockHarmonizer.emitState(errorState);
      await Future<void>.delayed(Duration.zero);
      expect(handler.mediaItem.value, isNull);
    });

    test('uses looping duration for non-first cycle', () async {
      const loopState = HarmonizerState(
        status: HarmonizerStatus.playing,
        activeType: GenerationType.monaural,
        formulaId: 'f1',
        totalCycleDuration: Duration(seconds: 30),
        firstCycleDuration: Duration(seconds: 45),
        isFirstCycle: false,
      );
      mockHarmonizer.emitState(loopState);
      await Future<void>.delayed(Duration.zero);

      final item = handler.mediaItem.value;
      expect(item!.duration, const Duration(seconds: 30));
    });

    test('handles null activeType and formulaId gracefully', () async {
      const minState = HarmonizerState(status: HarmonizerStatus.playing);
      mockHarmonizer.emitState(minState);
      await Future<void>.delayed(Duration.zero);

      final item = handler.mediaItem.value;
      expect(item, isNotNull);
      expect(item!.title, contains('Unknown'));
      expect(item.artist, contains('Unknown'));
    });
  });

  // ---------------------------------------------------------------------------
  // Command handling
  // ---------------------------------------------------------------------------

  group('commands', () {
    test('play() loads last config and calls harmonizer.play', () async {
      final configJson = jsonEncode({
        'type': 'monaural',
        'ambienceId': 'amb-1',
        'formulaId': 'f-1',
        'steps': testPackets.map((p) => p.toJson()).toList(),
      });

      when(
        () => mockPrefs.getString(HexaTuneAudioHandler.lastConfigKey),
      ).thenReturn(configJson);
      when(() => mockHarmonizer.play(any())).thenAnswer((_) async => null);

      await handler.play();

      final captured = verify(() => mockHarmonizer.play(captureAny())).captured;
      expect(captured, hasLength(1));

      final config = captured.first as HarmonizerConfig;
      expect(config.type, GenerationType.monaural);
      expect(config.ambienceId, 'amb-1');
      expect(config.formulaId, 'f-1');
      expect(config.steps, hasLength(2));
      expect(config.steps.first.value, 440);
    });

    test('play() with no saved config is a no-op', () async {
      when(
        () => mockPrefs.getString(HexaTuneAudioHandler.lastConfigKey),
      ).thenReturn(null);

      await handler.play();
      verifyNever(() => mockHarmonizer.play(any()));
    });

    test('play() with corrupt JSON is a no-op', () async {
      when(
        () => mockPrefs.getString(HexaTuneAudioHandler.lastConfigKey),
      ).thenReturn('{invalid json');

      await handler.play();
      verifyNever(() => mockHarmonizer.play(any()));
    });

    test('stop() calls harmonizer.stopGraceful', () async {
      when(() => mockHarmonizer.stopGraceful()).thenAnswer((_) async {});

      await handler.stop();
      verify(() => mockHarmonizer.stopGraceful()).called(1);
    });

    test('customAction immediateStop calls harmonizer.stopImmediate', () async {
      when(() => mockHarmonizer.stopImmediate()).thenAnswer((_) async {});

      await handler.customAction(HexaTuneAudioHandler.immediateStopAction);
      verify(() => mockHarmonizer.stopImmediate()).called(1);
    });

    test('customAction with unknown name is a no-op', () async {
      await handler.customAction('unknownAction');
      verifyNever(() => mockHarmonizer.stopImmediate());
      verifyNever(() => mockHarmonizer.stopGraceful());
    });
  });

  // ---------------------------------------------------------------------------
  // Last session persistence
  // ---------------------------------------------------------------------------

  group('last session persistence', () {
    test('saves config on transition to playing', () async {
      mockHarmonizer.emitState(preparingState);
      await Future<void>.delayed(Duration.zero);

      mockHarmonizer.emitState(playingState);
      await Future<void>.delayed(Duration.zero);

      final captured = verify(
        () => mockPrefs.setString(
          HexaTuneAudioHandler.lastConfigKey,
          captureAny(),
        ),
      ).captured;

      expect(captured, isNotEmpty);
      final saved = jsonDecode(captured.last as String);
      expect(saved['type'], 'monaural');
      expect(saved['formulaId'], 'formula-123');
      expect(saved['steps'], hasLength(2));
    });

    test('does not save again when already playing', () async {
      mockHarmonizer.emitState(playingState);
      await Future<void>.delayed(Duration.zero);

      // Emit another playing state (countdown tick).
      mockHarmonizer.emitState(
        playingState.copyWith(remainingInCycle: const Duration(seconds: 19)),
      );
      await Future<void>.delayed(Duration.zero);

      // lastConfigKey write should happen exactly once (the transition).
      verify(
        () => mockPrefs.setString(HexaTuneAudioHandler.lastConfigKey, any()),
      ).called(1);
    });

    test('saves again after stop and re-play', () async {
      mockHarmonizer.emitState(playingState);
      await Future<void>.delayed(Duration.zero);

      mockHarmonizer.emitState(idleState);
      await Future<void>.delayed(Duration.zero);

      mockHarmonizer.emitState(playingState);
      await Future<void>.delayed(Duration.zero);

      verify(
        () => mockPrefs.setString(HexaTuneAudioHandler.lastConfigKey, any()),
      ).called(2);
    });

    test('does not save when sequence is empty', () async {
      const emptySeqState = HarmonizerState(
        status: HarmonizerStatus.playing,
        activeType: GenerationType.monaural,
        sequence: [],
      );
      mockHarmonizer.emitState(emptySeqState);
      await Future<void>.delayed(Duration.zero);

      verifyNever(
        () => mockPrefs.setString(HexaTuneAudioHandler.lastConfigKey, any()),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // Widget state writing
  // ---------------------------------------------------------------------------

  group('widget state', () {
    test('writes isPlaying=true when playing', () async {
      mockHarmonizer.emitState(playingState);
      await Future<void>.delayed(Duration.zero);

      verify(
        () => mockPrefs.setBool(HexaTuneAudioHandler.widgetIsPlayingKey, true),
      ).called(1);
    });

    test('writes isPlaying=true when stopping', () async {
      mockHarmonizer.emitState(stoppingState);
      await Future<void>.delayed(Duration.zero);

      verify(
        () => mockPrefs.setBool(HexaTuneAudioHandler.widgetIsPlayingKey, true),
      ).called(1);
    });

    test('writes isPlaying=false when idle', () async {
      mockHarmonizer.emitState(idleState);
      await Future<void>.delayed(Duration.zero);

      verify(
        () => mockPrefs.setBool(HexaTuneAudioHandler.widgetIsPlayingKey, false),
      ).called(1);
    });

    test('writes formula name and generation type', () async {
      mockHarmonizer.emitState(playingState);
      await Future<void>.delayed(Duration.zero);

      verify(
        () => mockPrefs.setString(
          HexaTuneAudioHandler.widgetFormulaNameKey,
          'formula-123',
        ),
      ).called(1);
      verify(
        () => mockPrefs.setString(
          HexaTuneAudioHandler.widgetGenerationTypeKey,
          'monaural',
        ),
      ).called(1);
    });

    test('writes remaining seconds', () async {
      mockHarmonizer.emitState(playingState);
      await Future<void>.delayed(Duration.zero);

      verify(
        () => mockPrefs.setInt(
          HexaTuneAudioHandler.widgetRemainingSecondsKey,
          20,
        ),
      ).called(1);
    });

    test('writes empty strings when idle (no active type/formula)', () async {
      mockHarmonizer.emitState(idleState);
      await Future<void>.delayed(Duration.zero);

      verify(
        () =>
            mockPrefs.setString(HexaTuneAudioHandler.widgetFormulaNameKey, ''),
      ).called(1);
      verify(
        () => mockPrefs.setString(
          HexaTuneAudioHandler.widgetGenerationTypeKey,
          '',
        ),
      ).called(1);
    });
  });

  // ---------------------------------------------------------------------------
  // Dispose / cleanup
  // ---------------------------------------------------------------------------

  group('dispose', () {
    test('cancels state subscription', () async {
      handler.dispose();

      // Emitting after dispose should not cause errors.
      mockHarmonizer.emitState(playingState);
      await Future<void>.delayed(Duration.zero);

      // playbackState should not have been updated after dispose.
      final ps = handler.playbackState.value;
      expect(ps.processingState, isNot(AudioProcessingState.ready));
    });

    test('double dispose does not throw', () {
      handler.dispose();
      expect(() => handler.dispose(), returnsNormally);
    });
  });
}
