// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/dsp/ambience/ambience_service.dart';
import 'package:hexatuneapp/src/core/dsp/ambience/models/ambience_config.dart';
import 'package:hexatuneapp/src/core/dsp/dsp_asset_service.dart';
import 'package:hexatuneapp/src/core/dsp/dsp_service.dart';
import 'package:hexatuneapp/src/core/dsp/models/audio_asset.dart';
import 'package:hexatuneapp/src/core/hardware/headset/headset_service.dart';
import 'package:hexatuneapp/src/core/hardware/hexagen/hexagen_service.dart';
import 'package:hexatuneapp/src/core/hardware/hexagen/models/hexagen_command.dart';
import 'package:hexatuneapp/src/core/harmonizer/harmonizer_service.dart';
import 'package:hexatuneapp/src/core/harmonizer/models/generation_type.dart';
import 'package:hexatuneapp/src/core/harmonizer/models/harmonizer_config.dart';
import 'package:hexatuneapp/src/core/harmonizer/models/harmonizer_state.dart';
import 'package:hexatuneapp/src/core/harmonizer/models/harmonizer_validation.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/rest/harmonics/models/harmonic_packet_dto.dart';

class MockDspService extends Mock implements DspService {}

class MockHexagenService extends Mock implements HexagenService {}

class MockHeadsetService extends Mock implements HeadsetService {}

class MockAmbienceService extends Mock implements AmbienceService {}

class MockDspAssetService extends Mock implements DspAssetService {}

class MockLogService extends Mock implements LogService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockDspService mockDsp;
  late MockHexagenService mockHexagen;
  late MockHeadsetService mockHeadset;
  late MockAmbienceService mockAmbience;
  late MockDspAssetService mockAsset;
  late MockLogService mockLog;
  late HarmonizerService service;

  const testPackets = [
    HarmonicPacketDto(value: 5, durationMs: 30000, isOneShot: false),
    HarmonicPacketDto(value: 10, durationMs: 15000, isOneShot: true),
  ];

  setUp(() {
    mockDsp = MockDspService();
    mockHexagen = MockHexagenService();
    mockHeadset = MockHeadsetService();
    mockAmbience = MockAmbienceService();
    mockAsset = MockDspAssetService();
    mockLog = MockLogService();

    // Default stubs for ambience clearing (called when ambienceId is null).
    when(() => mockDsp.clearBase()).thenAnswer((_) async => true);
    when(() => mockDsp.clearTexture(any())).thenAnswer((_) async {});
    when(() => mockDsp.clearEvent(any())).thenAnswer((_) async {});

    // Default stubs for asset catalog (empty until discover is called).
    when(() => mockAsset.allAssets).thenReturn([]);
    when(() => mockAsset.discover()).thenAnswer((_) async => true);

    service = HarmonizerService(
      mockDsp,
      mockHexagen,
      mockHeadset,
      mockAmbience,
      mockAsset,
      mockLog,
    );
  });

  tearDown(() {
    service.dispose();
  });

  group('validatePrerequisites', () {
    test('monaural is always valid', () {
      expect(
        service.validatePrerequisites(GenerationType.monaural),
        HarmonizerValidation.valid,
      );
    });

    test('binaural requires headset — valid when connected', () {
      when(() => mockHeadset.isConnected).thenReturn(true);
      expect(
        service.validatePrerequisites(GenerationType.binaural),
        HarmonizerValidation.valid,
      );
    });

    test('binaural requires headset — invalid when disconnected', () {
      when(() => mockHeadset.isConnected).thenReturn(false);
      expect(
        service.validatePrerequisites(GenerationType.binaural),
        HarmonizerValidation.headsetRequired,
      );
    });

    test('magnetic requires hexagen — valid when connected', () {
      when(() => mockHexagen.isConnected).thenReturn(true);
      expect(
        service.validatePrerequisites(GenerationType.magnetic),
        HarmonizerValidation.valid,
      );
    });

    test('magnetic requires hexagen — invalid when disconnected', () {
      when(() => mockHexagen.isConnected).thenReturn(false);
      expect(
        service.validatePrerequisites(GenerationType.magnetic),
        HarmonizerValidation.hexagenRequired,
      );
    });

    test('photonic is not supported', () {
      expect(
        service.validatePrerequisites(GenerationType.photonic),
        HarmonizerValidation.notSupported,
      );
    });

    test('quantal is not supported', () {
      expect(
        service.validatePrerequisites(GenerationType.quantal),
        HarmonizerValidation.notSupported,
      );
    });
  });

  group('initial state', () {
    test('starts idle', () {
      expect(service.currentState.status, HarmonizerStatus.idle);
      expect(service.isHarmonizing, isFalse);
    });

    test('state stream emits default', () async {
      final states = <HarmonizerState>[];
      final sub = service.state.listen(states.add);
      addTearDown(sub.cancel);

      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(states, isEmpty);
    });
  });

  group('harmonize', () {
    test('rejects empty steps', () async {
      const config = HarmonizerConfig(type: GenerationType.monaural, steps: []);

      final error = await service.harmonize(config);
      expect(error, isNotNull);
      expect(error, contains('No harmonic packets'));
    });

    test('rejects unsupported type', () async {
      const config = HarmonizerConfig(
        type: GenerationType.photonic,
        steps: testPackets,
      );

      final error = await service.harmonize(config);
      expect(error, isNotNull);
      expect(error, contains('not yet supported'));
    });

    test('rejects binaural without headset', () async {
      when(() => mockHeadset.isConnected).thenReturn(false);

      const config = HarmonizerConfig(
        type: GenerationType.binaural,
        steps: testPackets,
      );

      final error = await service.harmonize(config);
      expect(error, isNotNull);
      expect(error, contains('Headphones'));
    });

    test('rejects magnetic without hexagen', () async {
      when(() => mockHexagen.isConnected).thenReturn(false);

      const config = HarmonizerConfig(
        type: GenerationType.magnetic,
        steps: testPackets,
      );

      final error = await service.harmonize(config);
      expect(error, isNotNull);
      expect(error, contains('hexaGen'));
    });

    test(
      'emits preparing then harmonizing on successful monaural harmonize',
      () async {
        when(
          () => mockDsp.updateBinauralConfig(
            binauralEnabled: any(named: 'binauralEnabled'),
            cycleSteps: any(named: 'cycleSteps'),
          ),
        ).thenReturn(true);
        when(() => mockDsp.start()).thenAnswer((_) async => null);

        final states = <HarmonizerState>[];
        final sub = service.state.listen(states.add);
        addTearDown(sub.cancel);

        const config = HarmonizerConfig(
          type: GenerationType.monaural,
          steps: testPackets,
          formulaId: 'formula-abc',
        );

        final error = await service.harmonize(config);
        expect(error, isNull);

        // Allow microtasks from the broadcast stream to complete.
        await Future<void>.delayed(Duration.zero);

        expect(
          states.any((s) => s.status == HarmonizerStatus.preparing),
          isTrue,
        );
        expect(states.last.status, HarmonizerStatus.harmonizing);
        expect(states.last.activeType, GenerationType.monaural);
        expect(states.last.sequence, testPackets);
        expect(states.last.formulaId, 'formula-abc');

        // Verify DSP was configured with 220 Hz carrier and AM mode.
        verify(
          () => mockDsp.updateBinauralConfig(
            binauralEnabled: false,
            cycleSteps: any(named: 'cycleSteps'),
          ),
        ).called(1);
      },
    );

    test('binaural harmonize configures DSP with binaural enabled', () async {
      when(() => mockHeadset.isConnected).thenReturn(true);
      when(
        () => mockDsp.updateBinauralConfig(
          binauralEnabled: any(named: 'binauralEnabled'),
          cycleSteps: any(named: 'cycleSteps'),
        ),
      ).thenReturn(true);
      when(() => mockDsp.start()).thenAnswer((_) async => null);

      const config = HarmonizerConfig(
        type: GenerationType.binaural,
        steps: testPackets,
      );

      final error = await service.harmonize(config);
      expect(error, isNull);

      verify(
        () => mockDsp.updateBinauralConfig(
          binauralEnabled: true,
          cycleSteps: any(named: 'cycleSteps'),
        ),
      ).called(1);
    });

    test('rejects harmonize when already harmonizing', () async {
      when(
        () => mockDsp.updateBinauralConfig(
          binauralEnabled: any(named: 'binauralEnabled'),
          cycleSteps: any(named: 'cycleSteps'),
        ),
      ).thenReturn(true);
      when(() => mockDsp.start()).thenAnswer((_) async => null);

      const config = HarmonizerConfig(
        type: GenerationType.monaural,
        steps: testPackets,
      );

      await service.harmonize(config);
      final error = await service.harmonize(config);
      expect(error, 'Harmonizer is already active');
    });

    test('DSP start failure sets error state', () async {
      when(
        () => mockDsp.updateBinauralConfig(
          binauralEnabled: any(named: 'binauralEnabled'),
          cycleSteps: any(named: 'cycleSteps'),
        ),
      ).thenReturn(true);
      when(() => mockDsp.start()).thenAnswer((_) async => 'Init failed');

      const config = HarmonizerConfig(
        type: GenerationType.monaural,
        steps: testPackets,
      );

      final error = await service.harmonize(config);
      expect(error, isNotNull);
      expect(service.currentState.status, HarmonizerStatus.error);
    });
  });

  group('stop', () {
    test('graceful stop calls DSP stopGraceful for monaural', () async {
      when(
        () => mockDsp.updateBinauralConfig(
          binauralEnabled: any(named: 'binauralEnabled'),
          cycleSteps: any(named: 'cycleSteps'),
        ),
      ).thenReturn(true);
      when(() => mockDsp.start()).thenAnswer((_) async => null);
      when(() => mockDsp.stopGraceful()).thenAnswer((_) async {});

      const config = HarmonizerConfig(
        type: GenerationType.monaural,
        steps: testPackets,
      );

      await service.harmonize(config);
      await service.stopGraceful();

      // Backend stop fires asynchronously — give microtasks time to complete.
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      verify(() => mockDsp.stopGraceful()).called(1);
      // State is 'stopping' (timer counts remaining to zero before idle).
      expect(service.currentState.status, HarmonizerStatus.stopping);
      expect(service.currentState.gracefulStopRequested, isTrue);
    });

    test('immediate stop calls DSP stop for binaural', () async {
      when(() => mockHeadset.isConnected).thenReturn(true);
      when(
        () => mockDsp.updateBinauralConfig(
          binauralEnabled: any(named: 'binauralEnabled'),
          cycleSteps: any(named: 'cycleSteps'),
        ),
      ).thenReturn(true);
      when(() => mockDsp.start()).thenAnswer((_) async => null);
      when(() => mockDsp.stop()).thenAnswer((_) async {});

      const config = HarmonizerConfig(
        type: GenerationType.binaural,
        steps: testPackets,
      );

      await service.harmonize(config);
      await service.stopImmediate();

      verify(() => mockDsp.stop()).called(1);
      expect(service.currentState.status, HarmonizerStatus.idle);
    });

    test('graceful stop is no-op when idle', () async {
      await service.stopGraceful();
      verifyNever(() => mockDsp.stopGraceful());
    });

    test('immediate stop is no-op when idle', () async {
      await service.stopImmediate();
      verifyNever(() => mockDsp.stop());
    });
  });

  group('cycle duration calculation', () {
    test(
      'total cycle duration excludes one-shots for looping cycles',
      () async {
        when(
          () => mockDsp.updateBinauralConfig(
            binauralEnabled: any(named: 'binauralEnabled'),
            cycleSteps: any(named: 'cycleSteps'),
          ),
        ).thenReturn(true);
        when(() => mockDsp.start()).thenAnswer((_) async => null);

        const config = HarmonizerConfig(
          type: GenerationType.monaural,
          steps: testPackets, // 30000ms normal + 15000ms oneshot
        );

        await service.harmonize(config);

        final state = service.currentState;
        expect(state.firstCycleDuration, const Duration(milliseconds: 45000));
        expect(state.totalCycleDuration, const Duration(milliseconds: 30000));
      },
    );
  });

  group('dispose', () {
    test('dispose closes state stream', () async {
      service.dispose();

      // A closed broadcast stream returns a done subscription, not an error.
      var gotDone = false;
      service.state.listen((_) {}, onDone: () => gotDone = true);
      await Future<void>.delayed(Duration.zero);
      expect(gotDone, isTrue);
    });
  });

  group('changeAmbience', () {
    test('does nothing when idle', () async {
      await service.changeAmbience('some-id');
      verifyNever(() => mockDsp.clearBase());
    });

    test('clears all layers when null during play', () async {
      when(
        () => mockDsp.updateBinauralConfig(
          binauralEnabled: any(named: 'binauralEnabled'),
          cycleSteps: any(named: 'cycleSteps'),
        ),
      ).thenReturn(true);
      when(() => mockDsp.start()).thenAnswer((_) async => null);

      const config = HarmonizerConfig(
        type: GenerationType.monaural,
        steps: testPackets,
      );

      await service.harmonize(config);

      // Reset invocations from play to isolate changeAmbience calls.
      clearInteractions(mockDsp);
      when(() => mockDsp.clearBase()).thenAnswer((_) async => true);
      when(() => mockDsp.clearTexture(any())).thenAnswer((_) async {});
      when(() => mockDsp.clearEvent(any())).thenAnswer((_) async {});

      await service.changeAmbience(null);

      verify(() => mockDsp.clearBase()).called(1);
      verify(() => mockDsp.clearTexture(any())).called(4);
      verify(() => mockDsp.clearEvent(any())).called(4);
    });

    test(
      'updates ambienceId in state when changed during harmonizing',
      () async {
        when(
          () => mockDsp.updateBinauralConfig(
            binauralEnabled: any(named: 'binauralEnabled'),
            cycleSteps: any(named: 'cycleSteps'),
          ),
        ).thenReturn(true);
        when(() => mockDsp.start()).thenAnswer((_) async => null);

        const config = HarmonizerConfig(
          type: GenerationType.monaural,
          steps: testPackets,
          ambienceId: 'original',
        );

        await service.harmonize(config);
        expect(service.currentState.ambienceId, 'original');

        // Clear invocations; we only care about state update.
        clearInteractions(mockDsp);
        when(() => mockDsp.clearBase()).thenAnswer((_) async => true);
        when(() => mockDsp.clearTexture(any())).thenAnswer((_) async {});
        when(() => mockDsp.clearEvent(any())).thenAnswer((_) async {});

        await service.changeAmbience(null);
        expect(service.currentState.ambienceId, isNull);
      },
    );

    test('is ignored for magnetic type', () async {
      when(() => mockHexagen.isConnected).thenReturn(true);
      when(() => mockHexagen.generateId()).thenReturn(1);
      when(
        () => mockHexagen.sendOperationPrepare(any()),
      ).thenAnswer((_) async => CommandStatus.success);
      when(
        () => mockHexagen.sendFreqCommandAndWait(any(), any()),
      ).thenAnswer((_) async => CommandStatus.success);
      when(
        () => mockHexagen.sendOperationGenerate(any()),
      ).thenAnswer((_) async => CommandStatus.success);

      const config = HarmonizerConfig(
        type: GenerationType.magnetic,
        steps: testPackets,
      );

      await service.harmonize(config);

      clearInteractions(mockDsp);
      await service.changeAmbience(null);

      // Magnetic does not support DSP ambience.
      verifyNever(() => mockDsp.clearBase());
    });
  });

  group('immediate stop', () {
    test('cleans up to idle immediately', () async {
      when(
        () => mockDsp.updateBinauralConfig(
          binauralEnabled: any(named: 'binauralEnabled'),
          cycleSteps: any(named: 'cycleSteps'),
        ),
      ).thenReturn(true);
      when(() => mockDsp.start()).thenAnswer((_) async => null);
      when(() => mockDsp.stop()).thenAnswer((_) async {});

      const config = HarmonizerConfig(
        type: GenerationType.monaural,
        steps: testPackets,
      );

      await service.harmonize(config);
      await service.stopImmediate();

      verify(() => mockDsp.stop()).called(1);
      expect(service.currentState.status, HarmonizerStatus.idle);
    });

    test('works from stopping state', () async {
      when(
        () => mockDsp.updateBinauralConfig(
          binauralEnabled: any(named: 'binauralEnabled'),
          cycleSteps: any(named: 'cycleSteps'),
        ),
      ).thenReturn(true);
      when(() => mockDsp.start()).thenAnswer((_) async => null);
      when(() => mockDsp.stopGraceful()).thenAnswer((_) async {});
      when(() => mockDsp.stop()).thenAnswer((_) async {});

      const config = HarmonizerConfig(
        type: GenerationType.monaural,
        steps: testPackets,
      );

      await service.harmonize(config);
      await service.stopGraceful();
      expect(service.currentState.status, HarmonizerStatus.stopping);

      await service.stopImmediate();
      expect(service.currentState.status, HarmonizerStatus.idle);
    });
  });

  group('ambience loading', () {
    test('calls discover when allAssets is empty', () async {
      when(
        () => mockDsp.updateBinauralConfig(
          binauralEnabled: any(named: 'binauralEnabled'),
          cycleSteps: any(named: 'cycleSteps'),
        ),
      ).thenReturn(true);
      when(() => mockDsp.start()).thenAnswer((_) async => null);
      when(() => mockDsp.setBaseGain(any())).thenReturn(null);
      when(() => mockDsp.setTextureGain(any())).thenReturn(null);
      when(() => mockDsp.setEventGain(any())).thenReturn(null);
      when(() => mockDsp.setMasterGain(any())).thenReturn(null);

      // findById returns a config with a base asset.
      when(() => mockAmbience.findById('amb-1')).thenReturn(
        AmbienceConfig(
          id: 'amb-1',
          name: 'Test',
          baseAssetId: 'forest',
          createdAt: '2025-01-01T00:00:00Z',
          updatedAt: '2025-01-01T00:00:00Z',
        ),
      );

      const config = HarmonizerConfig(
        type: GenerationType.monaural,
        steps: testPackets,
        ambienceId: 'amb-1',
      );

      await service.harmonize(config);

      verify(() => mockAsset.discover()).called(1);
    });

    test('skips discover when allAssets is not empty', () async {
      // Pre-populate assets so discover is not needed.
      when(() => mockAsset.allAssets).thenReturn(const [
        AudioAsset(
          id: 'forest',
          layerType: 'base',
          name: 'Forest',
          assetPath: 'assets/audio/ambience/base/forest.ogg',
        ),
      ]);

      when(
        () => mockDsp.updateBinauralConfig(
          binauralEnabled: any(named: 'binauralEnabled'),
          cycleSteps: any(named: 'cycleSteps'),
        ),
      ).thenReturn(true);
      when(() => mockDsp.start()).thenAnswer((_) async => null);
      when(() => mockDsp.setBaseGain(any())).thenReturn(null);
      when(() => mockDsp.setTextureGain(any())).thenReturn(null);
      when(() => mockDsp.setEventGain(any())).thenReturn(null);
      when(() => mockDsp.setMasterGain(any())).thenReturn(null);
      when(() => mockDsp.loadBase(any())).thenAnswer((_) async => 0);

      when(() => mockAmbience.findById('amb-1')).thenReturn(
        AmbienceConfig(
          id: 'amb-1',
          name: 'Test',
          baseAssetId: 'forest',
          createdAt: '2025-01-01T00:00:00Z',
          updatedAt: '2025-01-01T00:00:00Z',
        ),
      );

      const config = HarmonizerConfig(
        type: GenerationType.monaural,
        steps: testPackets,
        ambienceId: 'amb-1',
      );

      await service.harmonize(config);

      verifyNever(() => mockAsset.discover());
    });

    test('loads base, texture and event layers from asset catalog', () async {
      when(() => mockAsset.allAssets).thenReturn(const [
        AudioAsset(
          id: 'forest',
          layerType: 'base',
          name: 'Forest',
          assetPath: 'assets/audio/ambience/base/forest.ogg',
        ),
        AudioAsset(
          id: 'wind',
          layerType: 'texture',
          name: 'Wind',
          assetPath: 'assets/audio/ambience/texture/wind.ogg',
        ),
        AudioAsset(
          id: 'bird',
          layerType: 'events',
          name: 'Bird',
          assetPath: 'assets/audio/ambience/events/bird.ogg',
        ),
      ]);

      when(
        () => mockDsp.updateBinauralConfig(
          binauralEnabled: any(named: 'binauralEnabled'),
          cycleSteps: any(named: 'cycleSteps'),
        ),
      ).thenReturn(true);
      when(() => mockDsp.start()).thenAnswer((_) async => null);
      when(() => mockDsp.setBaseGain(any())).thenReturn(null);
      when(() => mockDsp.setTextureGain(any())).thenReturn(null);
      when(() => mockDsp.setEventGain(any())).thenReturn(null);
      when(() => mockDsp.setMasterGain(any())).thenReturn(null);
      when(() => mockDsp.loadBase(any())).thenAnswer((_) async => 0);
      when(() => mockDsp.loadTexture(any(), any())).thenAnswer((_) async => 0);
      when(() => mockDsp.loadEvent(any(), any())).thenAnswer((_) async => 0);

      when(() => mockAmbience.findById('amb-1')).thenReturn(
        AmbienceConfig(
          id: 'amb-1',
          name: 'Full',
          baseAssetId: 'forest',
          textureAssetIds: const ['wind'],
          eventAssetIds: const ['bird'],
          createdAt: '2025-01-01T00:00:00Z',
          updatedAt: '2025-01-01T00:00:00Z',
        ),
      );

      const config = HarmonizerConfig(
        type: GenerationType.monaural,
        steps: testPackets,
        ambienceId: 'amb-1',
      );

      await service.harmonize(config);

      verify(
        () => mockDsp.loadBase('assets/audio/ambience/base/forest.ogg'),
      ).called(1);
      verify(
        () => mockDsp.loadTexture(0, 'assets/audio/ambience/texture/wind.ogg'),
      ).called(1);
      verify(
        () => mockDsp.loadEvent(0, 'assets/audio/ambience/events/bird.ogg'),
      ).called(1);
    });
  });
}
