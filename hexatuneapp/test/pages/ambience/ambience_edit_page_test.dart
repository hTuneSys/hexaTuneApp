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
import 'package:hexatuneapp/src/pages/ambience/ambience_edit_page.dart';

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

Widget _buildApp({String ambienceId = 'amb-001'}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: AmbienceEditPage(ambienceId: ambienceId),
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

    when(() => mockAssetService.discover()).thenAnswer((_) async => true);
    when(() => mockAmbienceService.load()).thenAnswer((_) async {});
    when(() => mockAmbienceService.findById(any())).thenReturn(_testConfig);
    when(() => mockAssetService.allAssets).thenReturn(_testAssets);
    when(() => mockAssetService.assetsForLayer(any())).thenAnswer((inv) {
      final type = inv.positionalArguments[0] as String;
      return _testAssets.where((a) => a.layerType == type).toList();
    });
    when(() => mockDspService.isPlaying).thenReturn(false);
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

  group('AmbienceEditPage', () {
    testWidgets('shows loading indicator initially', (tester) async {
      final discoverCompleter = Completer<bool>();
      when(
        () => mockAssetService.discover(),
      ).thenAnswer((_) => discoverCompleter.future);

      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      discoverCompleter.complete(true);
      await tester.pumpAndSettle();
    });

    testWidgets('shows not found when config does not exist', (tester) async {
      when(() => mockAmbienceService.findById(any())).thenReturn(null);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Ambience not found.'), findsOneWidget);
    });

    testWidgets('shows app bar with edit title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Edit Ambience'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows pre-filled name', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, 'Test Ambience');
    });

    testWidgets('shows sound layers with expansion sections', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Sound Layers'), findsOneWidget);
      expect(find.byType(ExpansionTile), findsNWidgets(3));
    });

    testWidgets('shows gain sliders with pre-filled values', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final sliders = tester.widgetList<Slider>(find.byType(Slider)).toList();
      expect(sliders.length, 4);
      expect(sliders[0].value, 0.6);
      expect(sliders[1].value, 0.3);
      expect(sliders[2].value, 0.4);
      expect(sliders[3].value, 1.0);
    });

    testWidgets('shows delete and save buttons', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(FilledButton, 'Delete'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Save'), findsOneWidget);
    });

    testWidgets('delete shows confirmation dialog', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final deleteBtn = find.widgetWithText(FilledButton, 'Delete');
      await tester.ensureVisible(deleteBtn);
      await tester.pumpAndSettle();
      await tester.tap(deleteBtn);
      await tester.pumpAndSettle();

      expect(find.text('Delete Ambience'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('save calls update service', (tester) async {
      when(
        () => mockAmbienceService.update(
          any(),
          name: any(named: 'name'),
          baseAssetId: any(named: 'baseAssetId'),
          clearBase: any(named: 'clearBase'),
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

      final saveBtn = find.widgetWithText(FilledButton, 'Save');
      await tester.ensureVisible(saveBtn);
      await tester.pumpAndSettle();
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      verify(
        () => mockAmbienceService.update(
          'amb-001',
          name: any(named: 'name'),
          baseAssetId: any(named: 'baseAssetId'),
          clearBase: any(named: 'clearBase'),
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
