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
import 'package:hexatuneapp/src/pages/ambience/ambience_view_page.dart';

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
    home: AmbienceViewPage(ambienceId: ambienceId),
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

  group('AmbienceViewPage', () {
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

    testWidgets('shows app bar with view title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('View Ambience'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows read-only name field', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, 'Test Ambience');
      expect(textField.readOnly, isTrue);
    });

    testWidgets('shows sound layers with selections highlighted', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Sound Layers'), findsOneWidget);
      expect(find.byType(ExpansionTile), findsNWidgets(3));

      // Selected count badges: base 1/1, texture 1/3, events 2/5
      expect(find.text('1/1'), findsOneWidget);
      expect(find.text('1/3'), findsOneWidget);
      expect(find.text('2/5'), findsOneWidget);
    });

    testWidgets('shows read-only gain sliders', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(Slider), findsNWidgets(4));
      expect(find.text('Sound Settings'), findsOneWidget);
    });

    testWidgets('shows harmonize button', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('HARMONIZE'), findsOneWidget);
      expect(find.byIcon(Icons.join_inner), findsOneWidget);
    });

    testWidgets('sliders are disabled', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final sliders = tester.widgetList<Slider>(find.byType(Slider)).toList();
      for (final slider in sliders) {
        expect(slider.onChanged, isNull);
      }
    });

    testWidgets('no edit or delete buttons present', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(FilledButton, 'Delete'), findsNothing);
      expect(find.widgetWithText(FilledButton, 'Save'), findsNothing);
    });

    testWidgets('sound chip selections are visible', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // 4 selected chips (forest, snow, bird, stone) show check icons
      expect(find.byIcon(Icons.check_circle), findsNWidgets(4));
    });
  });
}
