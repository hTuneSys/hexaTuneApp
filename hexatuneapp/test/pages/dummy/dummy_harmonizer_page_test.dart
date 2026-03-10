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

      expect(find.text('Harmonizer Player'), findsOneWidget);
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
  // HarmonizerPlayerWidget — tab navigation
  // -------------------------------------------------------------------------

  group('HarmonizerPlayerWidget tabs', () {
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
  // HarmonizerPlayerWidget — type content variations
  // -------------------------------------------------------------------------

  group('HarmonizerPlayerWidget type content', () {
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
  // HarmonizerPlayerWidget — controls section
  // -------------------------------------------------------------------------

  group('HarmonizerPlayerWidget controls', () {
    testWidgets('shows play button initially', (tester) async {
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

    testWidgets('shows stop button when playing', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      harmonizerCtrl.add(
        const HarmonizerState(status: HarmonizerStatus.playing),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.stop_rounded), findsOneWidget);
    });

    testWidgets('shows duration when playing', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      harmonizerCtrl.add(
        const HarmonizerState(
          status: HarmonizerStatus.playing,
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

  // -------------------------------------------------------------------------
  // HarmonizerPlayerWidget — standalone widget tests
  // -------------------------------------------------------------------------

  group('HarmonizerPlayerWidget standalone', () {
    testWidgets('renders all type tabs with correct icons', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          child: Scaffold(
            body: ListView(
              children: [
                HarmonizerPlayerWidget(
                  selectedType: GenerationType.monaural,
                  harmonizerState: const HarmonizerState(),
                  headsetConnected: false,
                  hexagenConnected: false,
                  selectedAmbience: null,
                  ambienceConfigs: const [],
                  isActive: false,
                  generating: false,
                  canPlay: false,
                  onTypeChanged: (_) {},
                  onAmbienceChanged: (_) {},
                  onPlay: () {},
                  onStopGraceful: () {},
                  onImmediateStart: () {},
                  onImmediateEnd: () {},
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.speaker_outlined), findsOneWidget);
      expect(find.byIcon(Icons.headphones_outlined), findsOneWidget);
      expect(find.byIcon(Icons.waves_outlined), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsNWidgets(2));
    });

    testWidgets('shows loading spinner when generating', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          child: Scaffold(
            body: ListView(
              children: [
                HarmonizerPlayerWidget(
                  selectedType: GenerationType.monaural,
                  harmonizerState: const HarmonizerState(),
                  headsetConnected: false,
                  hexagenConnected: false,
                  selectedAmbience: null,
                  ambienceConfigs: const [],
                  isActive: true,
                  generating: true,
                  canPlay: false,
                  onTypeChanged: (_) {},
                  onAmbienceChanged: (_) {},
                  onPlay: () {},
                  onStopGraceful: () {},
                  onImmediateStart: () {},
                  onImmediateEnd: () {},
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('ambience dropdown shows configs', (tester) async {
      final configs = [
        const AmbienceConfig(
          id: 'a1',
          name: 'Forest Rain',
          createdAt: '2025-01-01',
          updatedAt: '2025-01-01',
        ),
        const AmbienceConfig(
          id: 'a2',
          name: 'Ocean Breeze',
          createdAt: '2025-01-02',
          updatedAt: '2025-01-02',
        ),
      ];

      await tester.pumpWidget(
        _buildApp(
          child: Scaffold(
            body: ListView(
              children: [
                HarmonizerPlayerWidget(
                  selectedType: GenerationType.monaural,
                  harmonizerState: const HarmonizerState(),
                  headsetConnected: false,
                  hexagenConnected: false,
                  selectedAmbience: null,
                  ambienceConfigs: configs,
                  isActive: false,
                  generating: false,
                  canPlay: false,
                  onTypeChanged: (_) {},
                  onAmbienceChanged: (_) {},
                  onPlay: () {},
                  onStopGraceful: () {},
                  onImmediateStart: () {},
                  onImmediateEnd: () {},
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap the dropdown to open it
      await tester.tap(find.text('Select ambience (optional)'));
      await tester.pumpAndSettle();

      expect(find.text('No ambience'), findsWidgets);
      expect(find.text('Forest Rain'), findsWidgets);
      expect(find.text('Ocean Breeze'), findsWidgets);
    });

    testWidgets('play button calls onPlay when canPlay is true', (
      tester,
    ) async {
      var playCalled = false;

      await tester.pumpWidget(
        _buildApp(
          child: Scaffold(
            body: ListView(
              children: [
                HarmonizerPlayerWidget(
                  selectedType: GenerationType.monaural,
                  harmonizerState: const HarmonizerState(),
                  headsetConnected: false,
                  hexagenConnected: false,
                  selectedAmbience: null,
                  ambienceConfigs: const [],
                  isActive: false,
                  generating: false,
                  canPlay: true,
                  onTypeChanged: (_) {},
                  onAmbienceChanged: (_) {},
                  onPlay: () => playCalled = true,
                  onStopGraceful: () {},
                  onImmediateStart: () {},
                  onImmediateEnd: () {},
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.play_arrow_rounded));
      await tester.pumpAndSettle();

      expect(playCalled, isTrue);
    });

    testWidgets('stop button calls onStopGraceful', (tester) async {
      var stopCalled = false;

      await tester.pumpWidget(
        _buildApp(
          child: Scaffold(
            body: ListView(
              children: [
                HarmonizerPlayerWidget(
                  selectedType: GenerationType.monaural,
                  harmonizerState: const HarmonizerState(
                    status: HarmonizerStatus.playing,
                  ),
                  headsetConnected: false,
                  hexagenConnected: false,
                  selectedAmbience: null,
                  ambienceConfigs: const [],
                  isActive: true,
                  generating: false,
                  canPlay: false,
                  onTypeChanged: (_) {},
                  onAmbienceChanged: (_) {},
                  onPlay: () {},
                  onStopGraceful: () => stopCalled = true,
                  onImmediateStart: () {},
                  onImmediateEnd: () {},
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.stop_rounded));
      await tester.pumpAndSettle();

      expect(stopCalled, isTrue);
    });

    testWidgets('shows loading spinner when stopping', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          child: Scaffold(
            body: ListView(
              children: [
                HarmonizerPlayerWidget(
                  selectedType: GenerationType.monaural,
                  harmonizerState: const HarmonizerState(
                    status: HarmonizerStatus.stopping,
                    remainingInCycle: Duration(minutes: 1),
                  ),
                  headsetConnected: false,
                  hexagenConnected: false,
                  selectedAmbience: null,
                  ambienceConfigs: const [],
                  isActive: true,
                  generating: false,
                  canPlay: false,
                  onTypeChanged: (_) {},
                  onAmbienceChanged: (_) {},
                  onPlay: () {},
                  onStopGraceful: () {},
                  onImmediateStart: () {},
                  onImmediateEnd: () {},
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      // Stopping shows a loading spinner, not the stop icon.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.stop_rounded), findsNothing);
    });

    testWidgets('shows remaining time during stopping', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          child: Scaffold(
            body: ListView(
              children: [
                HarmonizerPlayerWidget(
                  selectedType: GenerationType.monaural,
                  harmonizerState: const HarmonizerState(
                    status: HarmonizerStatus.stopping,
                    isFirstCycle: false,
                    totalCycleDuration: Duration(minutes: 5),
                    remainingInCycle: Duration(minutes: 2, seconds: 30),
                  ),
                  headsetConnected: false,
                  hexagenConnected: false,
                  selectedAmbience: null,
                  ambienceConfigs: const [],
                  isActive: true,
                  generating: false,
                  canPlay: false,
                  onTypeChanged: (_) {},
                  onAmbienceChanged: (_) {},
                  onPlay: () {},
                  onStopGraceful: () {},
                  onImmediateStart: () {},
                  onImmediateEnd: () {},
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      // During stopping, times are still displayed.
      expect(find.text('05:00'), findsOneWidget);
      expect(find.text('02:30'), findsOneWidget);
    });
  });
}
