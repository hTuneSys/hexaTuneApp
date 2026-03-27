// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

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
import 'package:hexatuneapp/src/pages/ambience/ambience_create_page.dart';

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
  baseAssetId: 'forest',
  textureAssetIds: ['snow'],
  eventAssetIds: ['bird', 'stone'],
  baseGain: 0.6,
  textureGain: 0.3,
  eventGain: 0.4,
  masterGain: 1.0,
  createdAt: '2025-01-01T00:00:00Z',
  updatedAt: '2025-01-01T00:00:00Z',
);

const _testAssets = [
  AudioAsset(
    id: 'forest',
    layerType: 'base',
    name: 'Forest',
    assetPath: 'assets/audio/ambience/base/forest.wav',
    iconAsset: '',
    nameKey: 'ambienceBaseForest',
  ),
  AudioAsset(
    id: 'ocean',
    layerType: 'base',
    name: 'Ocean',
    assetPath: 'assets/audio/ambience/base/ocean.wav',
    iconAsset: '',
    nameKey: 'ambienceBaseOcean',
  ),
  AudioAsset(
    id: 'snow',
    layerType: 'texture',
    name: 'Snow',
    assetPath: 'assets/audio/ambience/texture/snow.wav',
    iconAsset: '',
    nameKey: 'ambienceTextureSnow',
  ),
  AudioAsset(
    id: 'bird',
    layerType: 'events',
    name: 'Bird',
    assetPath: 'assets/audio/ambience/events/bird.wav',
    iconAsset: '',
    nameKey: 'ambienceEventBird',
  ),
  AudioAsset(
    id: 'stone',
    layerType: 'events',
    name: 'Stone',
    assetPath: 'assets/audio/ambience/events/stone.wav',
    iconAsset: '',
    nameKey: 'ambienceEventStone',
  ),
];

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const AmbienceCreatePage(),
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

    when(() => mockAssetService.assetsForLayer(any())).thenAnswer((inv) {
      final type = inv.positionalArguments[0] as String;
      return _testAssets.where((a) => a.layerType == type).toList();
    });
    when(() => mockAssetService.allAssets).thenReturn(_testAssets);
    when(() => mockDspService.isRendering).thenReturn(false);
    when(() => mockDspService.stop()).thenAnswer((_) async {});
    when(() => mockDspService.clearAllLayers()).thenAnswer((_) async {});

    getIt.allowReassignment = true;
    getIt.registerSingleton<AmbienceService>(mockAmbienceService);
    getIt.registerSingleton<DspAssetService>(mockAssetService);
    getIt.registerSingleton<DspService>(mockDspService);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('AmbienceCreatePage', () {
    testWidgets('shows app bar with create title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Create Ambience'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows name text field', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('shows Sound Layers section title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Sound Layers'), findsOneWidget);
    });

    testWidgets('shows Sound Settings section title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Sound Settings'), findsOneWidget);
    });

    testWidgets('shows Base, Texture, and Event expansion sections', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(ExpansionTile), findsNWidgets(3));
    });

    testWidgets('shows gain sliders', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(Slider), findsNWidgets(4));
    });

    testWidgets('shows harmonize button disabled when no layers selected', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('HARMONIZE'), findsOneWidget);

      final playFinder = find.ancestor(
        of: find.text('HARMONIZE'),
        matching: find.byType(OutlinedButton),
      );
      final playButton = tester.widget<OutlinedButton>(playFinder);
      expect(playButton.onPressed, isNull);
    });

    testWidgets('shows create button', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(FilledButton, 'Create Ambience'),
        findsOneWidget,
      );
    });

    testWidgets('name validation shows error when empty', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final createBtn = find.widgetWithText(FilledButton, 'Create Ambience');
      await tester.ensureVisible(createBtn);
      await tester.pumpAndSettle();
      await tester.tap(createBtn);
      await tester.pumpAndSettle();

      expect(find.text('Name is required.'), findsOneWidget);
    });

    testWidgets('successful create calls service', (tester) async {
      when(
        () => mockAmbienceService.create(
          name: any(named: 'name'),
          baseAssetId: any(named: 'baseAssetId'),
          textureAssetIds: any(named: 'textureAssetIds'),
          eventAssetIds: any(named: 'eventAssetIds'),
          baseGain: any(named: 'baseGain'),
          textureGain: any(named: 'textureGain'),
          eventGain: any(named: 'eventGain'),
          masterGain: any(named: 'masterGain'),
        ),
      ).thenAnswer((_) async => _testConfig);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'My Ambience');
      await tester.pumpAndSettle();

      final createBtn = find.widgetWithText(FilledButton, 'Create Ambience');
      await tester.ensureVisible(createBtn);
      await tester.pumpAndSettle();
      await tester.tap(createBtn);
      await tester.pumpAndSettle();

      verify(
        () => mockAmbienceService.create(
          name: any(named: 'name'),
          baseAssetId: any(named: 'baseAssetId'),
          textureAssetIds: any(named: 'textureAssetIds'),
          eventAssetIds: any(named: 'eventAssetIds'),
          baseGain: any(named: 'baseGain'),
          textureGain: any(named: 'textureGain'),
          eventGain: any(named: 'eventGain'),
          masterGain: any(named: 'masterGain'),
        ),
      ).called(1);
    });
  });
}
