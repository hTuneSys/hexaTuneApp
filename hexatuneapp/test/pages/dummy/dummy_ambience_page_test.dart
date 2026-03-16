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
import 'package:hexatuneapp/src/pages/dummy/dummy_ambience_page.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockAmbienceService extends Mock implements AmbienceService {}

class MockDspAssetService extends Mock implements DspAssetService {}

class MockDspService extends Mock implements DspService {}

// ---------------------------------------------------------------------------
// Test data
// ---------------------------------------------------------------------------

const _testConfig = AmbienceConfig(
  id: 'amb-001',
  name: 'Test Ambience',
  baseAssetId: 'base-01',
  textureAssetIds: ['tex-01'],
  eventAssetIds: ['evt-01'],
  baseGain: 0.6,
  textureGain: 0.3,
  eventGain: 0.4,
  masterGain: 1.0,
  createdAt: '2025-01-01T00:00:00Z',
  updatedAt: '2025-01-01T00:00:00Z',
);

const _testAsset = AudioAsset(
  id: 'base-01',
  layerType: 'base',
  name: 'Rain',
  assetPath: 'assets/audio/ambience/base/rain.m4a',
  iconAsset: '',
  nameKey: '',
);

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _buildApp({Widget? child}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: child ?? const DummyAmbiencePage(),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAmbienceService mockAmbienceService;
  late MockDspAssetService mockAssetService;
  late MockDspService mockDspService;

  setUp(() {
    mockAmbienceService = MockAmbienceService();
    mockAssetService = MockDspAssetService();
    mockDspService = MockDspService();

    // Stub AmbienceService
    when(() => mockAmbienceService.load()).thenAnswer((_) async {});
    when(() => mockAmbienceService.configs).thenReturn([_testConfig]);
    when(() => mockAmbienceService.delete(any())).thenAnswer((_) async => true);

    // Stub DspAssetService
    when(() => mockAssetService.discover()).thenAnswer((_) async => true);
    when(() => mockAssetService.allAssets).thenReturn([_testAsset]);

    // Stub DspService (needed if editor sub-page is opened)
    when(() => mockDspService.isPlaying).thenReturn(false);
    when(() => mockDspService.stop()).thenAnswer((_) async {});
    when(() => mockDspService.clearAllLayers()).thenAnswer((_) async {});

    // Register singletons
    getIt.allowReassignment = true;
    getIt.registerSingleton<AmbienceService>(mockAmbienceService);
    getIt.registerSingleton<DspAssetService>(mockAssetService);
    getIt.registerSingleton<DspService>(mockDspService);
  });

  tearDown(() async {
    await getIt.reset();
  });

  // -------------------------------------------------------------------------
  // Page-level tests
  // -------------------------------------------------------------------------

  group('DummyAmbiencePage', () {
    testWidgets('shows loading indicator initially', (tester) async {
      final discoverCompleter = Completer<bool>();
      when(
        () => mockAssetService.discover(),
      ).thenAnswer((_) => discoverCompleter.future);

      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Complete to allow tearDown to proceed cleanly
      discoverCompleter.complete(true);
      await tester.pumpAndSettle();
    });

    testWidgets('shows empty state when no configs', (tester) async {
      when(() => mockAmbienceService.configs).thenReturn([]);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.landscape_outlined), findsOneWidget);
      expect(find.text('No ambiences yet'), findsOneWidget);
      expect(find.text('Tap + to create your first ambience'), findsOneWidget);
    });

    testWidgets('shows FAB for creating ambience', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('renders ambience list when configs exist', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Test Ambience'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('shows config name in list card', (tester) async {
      const secondConfig = AmbienceConfig(
        id: 'amb-002',
        name: 'Ocean Waves',
        baseAssetId: null,
        textureAssetIds: [],
        eventAssetIds: [],
        baseGain: 0.5,
        textureGain: 0.3,
        eventGain: 0.4,
        masterGain: 1.0,
        createdAt: '2025-01-02T00:00:00Z',
        updatedAt: '2025-01-02T00:00:00Z',
      );
      when(
        () => mockAmbienceService.configs,
      ).thenReturn([_testConfig, secondConfig]);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Test Ambience'), findsOneWidget);
      expect(find.text('Ocean Waves'), findsOneWidget);
      expect(find.byType(Card), findsNWidgets(2));
    });

    testWidgets('handles service init error gracefully', (tester) async {
      // Simulate discover() that never completes (e.g. network hang)
      final neverCompletes = Completer<bool>();
      when(
        () => mockAssetService.discover(),
      ).thenAnswer((_) => neverCompletes.future);

      await tester.pumpWidget(_buildApp());
      await tester.pump();

      // Page should render with loading indicator (init never finishes)
      expect(find.byType(DummyAmbiencePage), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Complete to allow clean tearDown
      neverCompletes.complete(true);
      await tester.pumpAndSettle();
    });
  });
}
