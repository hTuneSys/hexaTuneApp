// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/dsp/ambience/ambience_service.dart';
import 'package:hexatuneapp/src/core/dsp/ambience/models/ambience_config.dart';
import 'package:hexatuneapp/src/core/dsp/dsp_asset_service.dart';
import 'package:hexatuneapp/src/core/dsp/dsp_service.dart';
import 'package:hexatuneapp/src/core/dsp/models/audio_asset.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_dsp_page.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockDspService extends Mock implements DspService {}

class MockDspAssetService extends Mock implements DspAssetService {}

class MockAmbienceService extends Mock implements AmbienceService {}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _testAmbienceConfig = AmbienceConfig(
  id: 'amb-001',
  name: 'Test Ambience',
  baseAssetId: 'base-01',
  textureAssetIds: [],
  eventAssetIds: [],
  baseGain: 0.6,
  textureGain: 0.3,
  eventGain: 0.4,
  masterGain: 1.0,
  createdAt: '2025-01-01T00:00:00Z',
  updatedAt: '2025-01-01T00:00:00Z',
);

const _testAudioAsset = AudioAsset(
  id: 'base-01',
  layerType: 'base',
  name: 'Rain',
  assetPath: 'assets/audio/ambience/base/rain.m4a',
  iconAsset: '',
  nameKey: '',
);

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const DummyDspPage(),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockDspService mockDspService;
  late MockDspAssetService mockAssetService;
  late MockAmbienceService mockAmbienceService;

  setUp(() {
    mockDspService = MockDspService();
    mockAssetService = MockDspAssetService();
    mockAmbienceService = MockAmbienceService();

    // DspAssetService stubs
    when(() => mockAssetService.discover()).thenAnswer((_) async => true);
    when(() => mockAssetService.allAssets).thenReturn([_testAudioAsset]);

    // AmbienceService stubs
    when(() => mockAmbienceService.load()).thenAnswer((_) async {});
    when(() => mockAmbienceService.configs).thenReturn([_testAmbienceConfig]);

    // DspService stubs
    when(() => mockDspService.isRendering).thenReturn(false);
    when(() => mockDspService.setBinauralGain(any())).thenReturn(null);
    when(() => mockDspService.setBaseGain(any())).thenReturn(null);
    when(() => mockDspService.setTextureGain(any())).thenReturn(null);
    when(() => mockDspService.setEventGain(any())).thenReturn(null);
    when(() => mockDspService.setMasterGain(any())).thenReturn(null);
    when(() => mockDspService.clearBase()).thenAnswer((_) async => true);
    when(() => mockDspService.loadBase(any())).thenAnswer((_) async => 0);
    when(
      () => mockDspService.loadTexture(any(), any()),
    ).thenAnswer((_) async => 0);
    when(
      () => mockDspService.loadEvent(any(), any()),
    ).thenAnswer((_) async => 0);
    when(
      () => mockDspService.updateBinauralConfig(
        binauralEnabled: any(named: 'binauralEnabled'),
        cycleSteps: any(named: 'cycleSteps'),
      ),
    ).thenReturn(true);
    when(() => mockDspService.start()).thenAnswer((_) async => null);
    when(() => mockDspService.stop()).thenAnswer((_) async {});
    when(() => mockDspService.stopGraceful()).thenAnswer((_) async {});

    // Register mocks with getIt
    getIt.allowReassignment = true;
    getIt.registerSingleton<DspService>(mockDspService);
    getIt.registerSingleton<DspAssetService>(mockAssetService);
    getIt.registerSingleton<AmbienceService>(mockAmbienceService);
  });

  tearDown(() async {
    await getIt.reset();
  });

  // -------------------------------------------------------------------------
  // Tests
  // -------------------------------------------------------------------------

  group('DummyDspPage', () {
    testWidgets('shows loading indicator while services init', (tester) async {
      final discoverCompleter = Completer<bool>();
      when(
        () => mockAssetService.discover(),
      ).thenAnswer((_) => discoverCompleter.future);

      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      discoverCompleter.complete(true);
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows page content after services ready', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // AppBar should be present with a localized title
      expect(find.byType(AppBar), findsOneWidget);
      // Page body should be scrollable after loading
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('shows binaural switch', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(SwitchListTile), findsOneWidget);
    });

    testWidgets('shows cycle step fields', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Default state has one cycle step with two text fields (delta + duration)
      expect(find.byType(TextField), findsAtLeastNWidgets(2));
      // Default values in the text fields
      expect(find.text('5.0'), findsOneWidget);
      expect(find.text('30.0'), findsOneWidget);
    });

    testWidgets('shows ambience selector section when configs exist', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // The ambience config name should appear in the selector
      expect(find.text('Test Ambience'), findsOneWidget);
    });

    testWidgets('shows harmonize button', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.join_inner), findsOneWidget);
    });

    testWidgets('handles service init error gracefully', (tester) async {
      // Simulate a service that never responds (e.g. network timeout)
      when(
        () => mockAssetService.discover(),
      ).thenAnswer((_) => Completer<bool>().future);

      await tester.pumpWidget(_buildApp());
      await tester.pump();

      // Page should not crash — remains on loading state since
      // _servicesReady is never set to true when init stalls
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsNothing);
    });
  });
}
