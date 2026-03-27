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
import 'package:hexatuneapp/src/core/dsp/models/audio_asset.dart';
import 'package:hexatuneapp/src/pages/ambience/ambience_list_page.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockAmbienceService extends Mock implements AmbienceService {}

class MockDspAssetService extends Mock implements DspAssetService {}

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
    home: const AmbienceListPage(),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAmbienceService mockAmbienceService;
  late MockDspAssetService mockAssetService;

  setUp(() {
    mockAmbienceService = MockAmbienceService();
    mockAssetService = MockDspAssetService();

    when(() => mockAssetService.discover()).thenAnswer((_) async => true);
    when(() => mockAmbienceService.load()).thenAnswer((_) async {});
    when(() => mockAmbienceService.configs).thenReturn([_testConfig]);
    when(() => mockAssetService.allAssets).thenReturn(_testAssets);
    when(() => mockAssetService.assetsForLayer(any())).thenAnswer((inv) {
      final type = inv.positionalArguments[0] as String;
      return _testAssets.where((a) => a.layerType == type).toList();
    });

    getIt.allowReassignment = true;
    getIt.registerSingleton<AmbienceService>(mockAmbienceService);
    getIt.registerSingleton<DspAssetService>(mockAssetService);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('AmbienceListPage', () {
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

    testWidgets('shows empty state when no configs', (tester) async {
      when(() => mockAmbienceService.configs).thenReturn([]);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.landscape_outlined), findsOneWidget);
      expect(find.text('No ambience yet.'), findsOneWidget);
    });

    testWidgets('shows FAB for creating ambience', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('renders list cards when configs exist', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('shows config name in card', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Test Ambience'), findsOneWidget);
    });

    testWidgets('shows base, texture, and event info in card', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Base: Forest'), findsOneWidget);
      expect(find.text('Texture: 1/3'), findsOneWidget);
      expect(find.text('Events: 2/5'), findsOneWidget);
    });

    testWidgets('shows popup menu with View and Edit options', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final popup = find.byType(PopupMenuButton<String>);
      expect(popup, findsOneWidget);

      await tester.tap(popup);
      await tester.pumpAndSettle();

      expect(find.text('View'), findsOneWidget);
      expect(find.text('Edit'), findsOneWidget);
    });

    testWidgets('search icon is visible', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('sort and filter buttons are visible', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(OutlinedButton, 'Sort'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'Filter'), findsOneWidget);
    });

    testWidgets('search expands on tap and filters list', (tester) async {
      const secondConfig = AmbienceConfig(
        id: 'amb-002',
        name: 'Ocean Waves',
        baseAssetId: 'ocean',
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

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Ocean');
      await tester.pumpAndSettle();

      expect(find.text('Ocean Waves'), findsOneWidget);
      expect(find.text('Test Ambience'), findsNothing);
    });
  });
}
