// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/dsp/ambience/ambience_service.dart';
import 'package:hexatuneapp/src/core/hardware/headset/headset_service.dart';
import 'package:hexatuneapp/src/core/hardware/headset/headset_state.dart';
import 'package:hexatuneapp/src/core/hardware/hexagen/hexagen_service.dart';
import 'package:hexatuneapp/src/core/hardware/hexagen/models/hexagen_state.dart';
import 'package:hexatuneapp/src/core/harmonizer/harmonizer_service.dart';
import 'package:hexatuneapp/src/core/harmonizer/models/generation_type.dart';
import 'package:hexatuneapp/src/core/harmonizer/models/harmonizer_state.dart';
import 'package:hexatuneapp/src/core/harmonizer/models/harmonizer_validation.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/formula_response.dart';
import 'package:hexatuneapp/src/core/rest/harmonics/harmonics_repository.dart';
import 'package:hexatuneapp/src/core/rest/inventory/models/inventory_response.dart';
import 'package:hexatuneapp/src/pages/shared/harmonize_source.dart';
import 'package:hexatuneapp/src/pages/shared/harmonize_source_holder.dart';
import 'package:hexatuneapp/src/pages/shared/harmonizer_bottom_sheet.dart';
import 'package:hexatuneapp/src/pages/shared/harmonizer_widget.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockHarmonizerService extends Mock implements HarmonizerService {}

class MockAmbienceService extends Mock implements AmbienceService {}

class MockHeadsetService extends Mock implements HeadsetService {}

class MockHexagenService extends Mock implements HexagenService {}

class MockHarmonicsRepository extends Mock implements HarmonicsRepository {}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _testFormulas = [
  FormulaResponse(
    id: 'f1',
    name: 'Alpha Wave',
    labels: [],
    createdAt: '2025-01-01',
    updatedAt: '2025-01-01',
  ),
];

const _testInventories = [
  InventoryResponse(
    id: 'inv1',
    name: 'Bass Drum',
    categoryId: 'cat1',
    labels: [],
    imageUploaded: false,
    createdAt: '2025-01-01',
    updatedAt: '2025-01-01',
  ),
  InventoryResponse(
    id: 'inv2',
    name: 'Snare',
    categoryId: 'cat1',
    labels: [],
    imageUploaded: false,
    createdAt: '2025-01-01',
    updatedAt: '2025-01-01',
  ),
];

Widget _buildApp({HarmonizeSource? source}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: Builder(
      builder: (context) => Scaffold(
        body: ElevatedButton(
          onPressed: () => showHarmonizerSheet(context, source: source),
          child: const Text('Open'),
        ),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockHarmonizerService mockHarmonizer;
  late MockAmbienceService mockAmbience;
  late MockHeadsetService mockHeadset;
  late MockHexagenService mockHexagen;
  late MockHarmonicsRepository mockHarmonicsRepo;

  late StreamController<HarmonizerState> harmonizerCtrl;
  late StreamController<HeadsetState> headsetCtrl;
  late StreamController<HexagenState> hexagenCtrl;

  setUpAll(() {
    registerFallbackValue(GenerationType.monaural);
  });

  setUp(() {
    mockHarmonizer = MockHarmonizerService();
    mockAmbience = MockAmbienceService();
    mockHeadset = MockHeadsetService();
    mockHexagen = MockHexagenService();
    mockHarmonicsRepo = MockHarmonicsRepository();

    harmonizerCtrl = StreamController<HarmonizerState>.broadcast();
    headsetCtrl = StreamController<HeadsetState>.broadcast();
    hexagenCtrl = StreamController<HexagenState>.broadcast();

    when(() => mockHarmonizer.state).thenAnswer((_) => harmonizerCtrl.stream);
    when(() => mockHarmonizer.currentState).thenReturn(const HarmonizerState());
    when(() => mockHarmonizer.isHarmonizing).thenReturn(false);
    when(
      () => mockHarmonizer.validatePrerequisites(any()),
    ).thenReturn(HarmonizerValidation.valid);

    when(() => mockHeadset.isConnected).thenReturn(false);
    when(() => mockHeadset.state).thenAnswer((_) => headsetCtrl.stream);

    when(() => mockHexagen.isConnected).thenReturn(false);
    when(() => mockHexagen.state).thenAnswer((_) => hexagenCtrl.stream);

    when(() => mockAmbience.configs).thenReturn([]);
    when(() => mockAmbience.load()).thenAnswer((_) async {});

    getIt.allowReassignment = true;
    getIt.registerSingleton<HarmonizerService>(mockHarmonizer);
    getIt.registerSingleton<AmbienceService>(mockAmbience);
    getIt.registerSingleton<HeadsetService>(mockHeadset);
    getIt.registerSingleton<HexagenService>(mockHexagen);
    getIt.registerSingleton<HarmonicsRepository>(mockHarmonicsRepo);
    getIt.registerLazySingleton<HarmonizeSourceHolder>(
      () => HarmonizeSourceHolder(),
    );
  });

  tearDown(() async {
    harmonizerCtrl.close();
    headsetCtrl.close();
    hexagenCtrl.close();
    await getIt.reset();
  });

  group('showHarmonizerSheet', () {
    testWidgets('opens bottom sheet with HarmonizerWidget', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.byType(HarmonizerWidget), findsOneWidget);
    });

    testWidgets('shows select source prompt when no source is set', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(
        find.text('Please select a source from formula or inventory pages'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('shows harmonizer type tabs', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Monaural'), findsNWidgets(2));
      expect(find.text('Binaural'), findsOneWidget);
      expect(find.text('Magnetic'), findsOneWidget);
    });

    testWidgets('reflects harmonizer state changes', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Initially idle — harmonize button visible
      expect(find.byIcon(Icons.join_inner_rounded), findsOneWidget);

      // Switch to harmonizing
      harmonizerCtrl.add(
        const HarmonizerState(status: HarmonizerStatus.harmonizing),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.stop_rounded), findsOneWidget);
    });

    testWidgets('shows read-only formula display for FormulaSource', (
      tester,
    ) async {
      final source = FormulaSource(formula: _testFormulas[0]);
      await tester.pumpWidget(_buildApp(source: source));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Alpha Wave'), findsOneWidget);
      expect(find.byIcon(Icons.science_outlined), findsOneWidget);
    });

    testWidgets('shows inventory chips for InventorySource', (tester) async {
      const source = InventorySource(inventories: _testInventories);
      await tester.pumpWidget(_buildApp(source: source));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Bass Drum'), findsOneWidget);
      expect(find.text('Snare'), findsOneWidget);
      expect(find.byType(Chip), findsNWidgets(2));
    });

    testWidgets('persists source in holder across sheet open/close', (
      tester,
    ) async {
      final source = FormulaSource(formula: _testFormulas[0]);
      await tester.pumpWidget(_buildApp(source: source));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Alpha Wave'), findsOneWidget);

      final holder = getIt<HarmonizeSourceHolder>();
      expect(holder.source, isA<FormulaSource>());
    });
  });
}
