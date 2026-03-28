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
import 'package:hexatuneapp/src/core/network/models/paginated_response.dart';
import 'package:hexatuneapp/src/core/network/models/pagination_meta.dart';
import 'package:hexatuneapp/src/core/rest/formula/formula_repository.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/formula_response.dart';
import 'package:hexatuneapp/src/core/rest/harmonics/harmonics_repository.dart';
import 'package:hexatuneapp/src/pages/dummy/dummy_harmonizer_page.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockHarmonizerService extends Mock implements HarmonizerService {}

class MockAmbienceService extends Mock implements AmbienceService {}

class MockHeadsetService extends Mock implements HeadsetService {}

class MockHexagenService extends Mock implements HexagenService {}

class MockFormulaRepository extends Mock implements FormulaRepository {}

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
  FormulaResponse(
    id: 'f2',
    name: 'Theta Boost',
    labels: [],
    createdAt: '2025-01-02',
    updatedAt: '2025-01-02',
  ),
];

const _emptyPagination = PaginationMeta(
  hasMore: false,
  limit: 20,
  nextCursor: null,
);

Widget _buildApp({Widget? child}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: child ?? const DummyHarmonizerPage(),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockHarmonizerService mockHarmonizer;
  late MockAmbienceService mockAmbience;
  late MockHeadsetService mockHeadset;
  late MockHexagenService mockHexagen;
  late MockFormulaRepository mockFormulaRepo;
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
    mockFormulaRepo = MockFormulaRepository();
    mockHarmonicsRepo = MockHarmonicsRepository();

    harmonizerCtrl = StreamController<HarmonizerState>.broadcast();
    headsetCtrl = StreamController<HeadsetState>.broadcast();
    hexagenCtrl = StreamController<HexagenState>.broadcast();

    when(() => mockHarmonizer.state).thenAnswer((_) => harmonizerCtrl.stream);
    when(() => mockHarmonizer.currentState).thenReturn(const HarmonizerState());
    when(
      () => mockHarmonizer.validatePrerequisites(any()),
    ).thenReturn(HarmonizerValidation.valid);

    when(() => mockHeadset.isConnected).thenReturn(false);
    when(() => mockHeadset.state).thenAnswer((_) => headsetCtrl.stream);

    when(() => mockHexagen.isConnected).thenReturn(false);
    when(() => mockHexagen.state).thenAnswer((_) => hexagenCtrl.stream);

    when(() => mockAmbience.configs).thenReturn([]);
    when(() => mockAmbience.load()).thenAnswer((_) async {});

    when(() => mockFormulaRepo.list()).thenAnswer(
      (_) async =>
          PaginatedResponse(data: _testFormulas, pagination: _emptyPagination),
    );

    getIt.allowReassignment = true;
    getIt.registerSingleton<HarmonizerService>(mockHarmonizer);
    getIt.registerSingleton<AmbienceService>(mockAmbience);
    getIt.registerSingleton<HeadsetService>(mockHeadset);
    getIt.registerSingleton<HexagenService>(mockHexagen);
    getIt.registerSingleton<FormulaRepository>(mockFormulaRepo);
    getIt.registerSingleton<HarmonicsRepository>(mockHarmonicsRepo);
  });

  tearDown(() async {
    harmonizerCtrl.close();
    headsetCtrl.close();
    hexagenCtrl.close();
    await getIt.reset();
  });

  // -------------------------------------------------------------------------
  // Page-level tests
  // -------------------------------------------------------------------------

  group('DummyHarmonizerPage', () {
    testWidgets('shows appbar title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Harmonizer'), findsOneWidget);
    });

    testWidgets('shows formula selector with formulas', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Formula'), findsOneWidget);
    });

    testWidgets('shows no-formulas card when list is empty', (tester) async {
      when(() => mockFormulaRepo.list()).thenAnswer(
        (_) async =>
            PaginatedResponse(data: const [], pagination: _emptyPagination),
      );

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('No formulas available'), findsOneWidget);
    });

    testWidgets('shows loading spinner while formulas load', (tester) async {
      final completer = Completer<PaginatedResponse<FormulaResponse>>();
      when(() => mockFormulaRepo.list()).thenAnswer((_) => completer.future);

      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(
        PaginatedResponse(data: _testFormulas, pagination: _emptyPagination),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });

  // -------------------------------------------------------------------------
  // HarmonizerWidget — tab navigation
  // -------------------------------------------------------------------------

  group('HarmonizerWidget tabs', () {
    testWidgets('shows all 5 type tabs', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Monaural appears 2x: tab label + content title
      expect(find.text('Monaural'), findsNWidgets(2));
      expect(find.text('Binaural'), findsOneWidget);
      expect(find.text('Magnetic'), findsOneWidget);
      expect(find.text('Photonic'), findsOneWidget);
      expect(find.text('Quantal'), findsOneWidget);
    });

    testWidgets('tapping Binaural tab changes type content', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Headset not connected — should show warning
      await tester.tap(find.text('Binaural'));
      await tester.pumpAndSettle();

      expect(
        find.text('Please connect headphones for binaural mode'),
        findsOneWidget,
      );
    });

    testWidgets('tapping Magnetic tab shows hexagen warning', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Magnetic'));
      await tester.pumpAndSettle();

      expect(
        find.text('Please connect a hexaGen device for magnetic mode'),
        findsOneWidget,
      );
    });

    testWidgets('tapping Photonic tab shows coming soon', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Photonic'));
      await tester.pumpAndSettle();

      expect(find.text('This feature is coming soon'), findsOneWidget);
    });

    testWidgets('tapping Quantal tab shows coming soon', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Quantal'));
      await tester.pumpAndSettle();

      expect(find.text('This feature is coming soon'), findsOneWidget);
    });
  });

  // -------------------------------------------------------------------------
  // HarmonizerWidget — type content variations
  // -------------------------------------------------------------------------

  group('HarmonizerWidget type content', () {
    testWidgets('Monaural shows ambience selector', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Monaural is selected by default — appears in tab + content
      expect(find.text('Monaural'), findsNWidgets(2));
      expect(find.text('Select ambience (optional)'), findsOneWidget);
    });

    testWidgets('Binaural shows ambience when headset connected', (
      tester,
    ) async {
      when(() => mockHeadset.isConnected).thenReturn(true);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Binaural'));
      await tester.pumpAndSettle();

      expect(find.text('Select ambience (optional)'), findsOneWidget);
    });

    testWidgets('Binaural reactively shows warning when headset disconnects', (
      tester,
    ) async {
      when(() => mockHeadset.isConnected).thenReturn(true);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Binaural'));
      await tester.pumpAndSettle();

      // Disconnect headset
      headsetCtrl.add(
        const HeadsetState(wiredConnected: false, wirelessConnected: false),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Please connect headphones for binaural mode'),
        findsOneWidget,
      );
    });

    testWidgets('Magnetic shows title when hexagen connected', (tester) async {
      when(() => mockHexagen.isConnected).thenReturn(true);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Magnetic'));
      await tester.pumpAndSettle();

      // No warning, just the type name
      expect(
        find.text('Please connect a hexaGen device for magnetic mode'),
        findsNothing,
      );
    });

    testWidgets('Magnetic reactively shows warning when hexagen disconnects', (
      tester,
    ) async {
      when(() => mockHexagen.isConnected).thenReturn(true);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Magnetic'));
      await tester.pumpAndSettle();

      // Disconnect hexagen
      hexagenCtrl.add(const HexagenState(isConnected: false));
      await tester.pumpAndSettle();

      expect(
        find.text('Please connect a hexaGen device for magnetic mode'),
        findsOneWidget,
      );
    });
  });

  // -------------------------------------------------------------------------
  // HarmonizerWidget — controls section
  // -------------------------------------------------------------------------

  group('HarmonizerWidget controls', () {
    testWidgets('shows harmonize button initially', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
    });

    testWidgets('shows --:-- for both timers when idle', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('--:--'), findsNWidgets(2));
    });

    testWidgets('shows Total and Remaining labels', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Total'), findsOneWidget);
      expect(find.text('Remaining'), findsOneWidget);
    });

    testWidgets('shows stop button when harmonizing', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      harmonizerCtrl.add(
        const HarmonizerState(status: HarmonizerStatus.harmonizing),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.stop_rounded), findsOneWidget);
    });

    testWidgets('shows duration when harmonizing', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      harmonizerCtrl.add(
        const HarmonizerState(
          status: HarmonizerStatus.harmonizing,
          isFirstCycle: false,
          totalCycleDuration: Duration(minutes: 5, seconds: 30),
          remainingInCycle: Duration(minutes: 3, seconds: 15),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('05:30'), findsOneWidget);
      expect(find.text('03:15'), findsOneWidget);
    });

    testWidgets('shows error message', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      harmonizerCtrl.add(
        const HarmonizerState(
          status: HarmonizerStatus.error,
          errorMessage: 'DSP init failed',
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Error: DSP init failed'), findsOneWidget);
    });
  });
}
