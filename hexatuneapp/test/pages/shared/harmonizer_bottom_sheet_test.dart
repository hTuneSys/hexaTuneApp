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
import 'package:hexatuneapp/src/pages/shared/harmonizer_bottom_sheet.dart';
import 'package:hexatuneapp/src/pages/shared/harmonizer_widget.dart';

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
];

const _emptyPagination = PaginationMeta(
  hasMore: false,
  limit: 20,
  nextCursor: null,
);

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: Builder(
      builder: (context) => Scaffold(
        body: ElevatedButton(
          onPressed: () => showHarmonizerSheet(context),
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

  group('showHarmonizerSheet', () {
    testWidgets('opens bottom sheet with HarmonizerWidget', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.byType(HarmonizerWidget), findsOneWidget);
    });

    testWidgets('shows formula selector in bottom sheet', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Formula'), findsOneWidget);
    });

    testWidgets('shows loading spinner while formulas load', (tester) async {
      final completer = Completer<PaginatedResponse<FormulaResponse>>();
      when(() => mockFormulaRepo.list()).thenAnswer((_) => completer.future);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(
        PaginatedResponse(data: _testFormulas, pagination: _emptyPagination),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Select a formula'), findsOneWidget);
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

    testWidgets('shows no-formulas card when list is empty', (tester) async {
      when(() => mockFormulaRepo.list()).thenAnswer(
        (_) async =>
            PaginatedResponse(data: const [], pagination: _emptyPagination),
      );

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('No formulas available'), findsOneWidget);
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
  });
}
