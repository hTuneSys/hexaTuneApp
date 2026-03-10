// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/dsp/ambience/ambience_service.dart';
import 'package:hexatuneapp/src/core/dsp/dsp_asset_service.dart';
import 'package:hexatuneapp/src/core/dsp/dsp_service.dart';
import 'package:hexatuneapp/src/core/hardware/headset/headset_service.dart';
import 'package:hexatuneapp/src/core/hardware/hexagen/hexagen_service.dart';
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
      expect(service.isPlaying, isFalse);
    });

    test('state stream emits default', () async {
      final states = <HarmonizerState>[];
      final sub = service.state.listen(states.add);
      addTearDown(sub.cancel);

      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(states, isEmpty);
    });
  });

  group('play', () {
    test('rejects empty steps', () async {
      const config = HarmonizerConfig(type: GenerationType.monaural, steps: []);

      final error = await service.play(config);
      expect(error, isNotNull);
      expect(error, contains('No harmonic packets'));
    });

    test('rejects unsupported type', () async {
      const config = HarmonizerConfig(
        type: GenerationType.photonic,
        steps: testPackets,
      );

      final error = await service.play(config);
      expect(error, isNotNull);
      expect(error, contains('not yet supported'));
    });

    test('rejects binaural without headset', () async {
      when(() => mockHeadset.isConnected).thenReturn(false);

      const config = HarmonizerConfig(
        type: GenerationType.binaural,
        steps: testPackets,
      );

      final error = await service.play(config);
      expect(error, isNotNull);
      expect(error, contains('Headphones'));
    });

    test('rejects magnetic without hexagen', () async {
      when(() => mockHexagen.isConnected).thenReturn(false);

      const config = HarmonizerConfig(
        type: GenerationType.magnetic,
        steps: testPackets,
      );

      final error = await service.play(config);
      expect(error, isNotNull);
      expect(error, contains('hexaGen'));
    });

    test('emits preparing then playing on successful monaural play', () async {
      when(
        () => mockDsp.updateBinauralConfig(
          carrierFrequency: any(named: 'carrierFrequency'),
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
      );

      final error = await service.play(config);
      expect(error, isNull);

      // Allow microtasks from the broadcast stream to complete.
      await Future<void>.delayed(Duration.zero);

      expect(states.any((s) => s.status == HarmonizerStatus.preparing), isTrue);
      expect(states.last.status, HarmonizerStatus.playing);
      expect(states.last.activeType, GenerationType.monaural);
      expect(states.last.sequence, testPackets);

      // Verify DSP was configured with 220 Hz carrier and AM mode.
      verify(
        () => mockDsp.updateBinauralConfig(
          carrierFrequency: 220.0,
          binauralEnabled: false,
          cycleSteps: any(named: 'cycleSteps'),
        ),
      ).called(1);
    });

    test('binaural play configures DSP with binaural enabled', () async {
      when(() => mockHeadset.isConnected).thenReturn(true);
      when(
        () => mockDsp.updateBinauralConfig(
          carrierFrequency: any(named: 'carrierFrequency'),
          binauralEnabled: any(named: 'binauralEnabled'),
          cycleSteps: any(named: 'cycleSteps'),
        ),
      ).thenReturn(true);
      when(() => mockDsp.start()).thenAnswer((_) async => null);

      const config = HarmonizerConfig(
        type: GenerationType.binaural,
        steps: testPackets,
      );

      final error = await service.play(config);
      expect(error, isNull);

      verify(
        () => mockDsp.updateBinauralConfig(
          carrierFrequency: 220.0,
          binauralEnabled: true,
          cycleSteps: any(named: 'cycleSteps'),
        ),
      ).called(1);
    });

    test('rejects play when already playing', () async {
      when(
        () => mockDsp.updateBinauralConfig(
          carrierFrequency: any(named: 'carrierFrequency'),
          binauralEnabled: any(named: 'binauralEnabled'),
          cycleSteps: any(named: 'cycleSteps'),
        ),
      ).thenReturn(true);
      when(() => mockDsp.start()).thenAnswer((_) async => null);

      const config = HarmonizerConfig(
        type: GenerationType.monaural,
        steps: testPackets,
      );

      await service.play(config);
      final error = await service.play(config);
      expect(error, 'Harmonizer is already active');
    });

    test('DSP start failure sets error state', () async {
      when(
        () => mockDsp.updateBinauralConfig(
          carrierFrequency: any(named: 'carrierFrequency'),
          binauralEnabled: any(named: 'binauralEnabled'),
          cycleSteps: any(named: 'cycleSteps'),
        ),
      ).thenReturn(true);
      when(() => mockDsp.start()).thenAnswer((_) async => 'Init failed');

      const config = HarmonizerConfig(
        type: GenerationType.monaural,
        steps: testPackets,
      );

      final error = await service.play(config);
      expect(error, isNotNull);
      expect(service.currentState.status, HarmonizerStatus.error);
    });
  });

  group('stop', () {
    test('graceful stop calls DSP stopGraceful for monaural', () async {
      when(
        () => mockDsp.updateBinauralConfig(
          carrierFrequency: any(named: 'carrierFrequency'),
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

      await service.play(config);
      await service.stopGraceful();

      verify(() => mockDsp.stopGraceful()).called(1);
      expect(service.currentState.status, HarmonizerStatus.idle);
    });

    test('immediate stop calls DSP stop for binaural', () async {
      when(() => mockHeadset.isConnected).thenReturn(true);
      when(
        () => mockDsp.updateBinauralConfig(
          carrierFrequency: any(named: 'carrierFrequency'),
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

      await service.play(config);
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
            carrierFrequency: any(named: 'carrierFrequency'),
            binauralEnabled: any(named: 'binauralEnabled'),
            cycleSteps: any(named: 'cycleSteps'),
          ),
        ).thenReturn(true);
        when(() => mockDsp.start()).thenAnswer((_) async => null);

        const config = HarmonizerConfig(
          type: GenerationType.monaural,
          steps: testPackets, // 30000ms normal + 15000ms oneshot
        );

        await service.play(config);

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
}
