// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/harmonizer/harmonizer_service.dart';
import 'package:hexatuneapp/src/core/harmonizer/models/harmonizer_state.dart';
import 'package:hexatuneapp/src/pages/dummy/widgets/mini_harmonizer_bar.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockHarmonizerService extends Mock implements HarmonizerService {}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _buildApp({required Widget child}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: Scaffold(body: Column(children: [const Spacer(), child])),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockHarmonizerService mockHarmonizer;
  late StreamController<HarmonizerState> ctrl;

  setUp(() {
    mockHarmonizer = MockHarmonizerService();
    ctrl = StreamController<HarmonizerState>.broadcast();

    when(() => mockHarmonizer.currentState).thenReturn(const HarmonizerState());
    when(() => mockHarmonizer.state).thenAnswer((_) => ctrl.stream);
    when(() => mockHarmonizer.stopGraceful()).thenAnswer((_) async {});
    when(() => mockHarmonizer.stopImmediate()).thenAnswer((_) async {});

    getIt.allowReassignment = true;
    getIt.registerSingleton<HarmonizerService>(mockHarmonizer);
  });

  tearDown(() {
    ctrl.close();
    getIt.unregister<HarmonizerService>();
  });

  group('MiniHarmonizerBar', () {
    testWidgets('is hidden when idle', (tester) async {
      await tester.pumpWidget(_buildApp(child: const MiniHarmonizerBar()));
      await tester.pumpAndSettle();

      // Should render SizedBox.shrink — no visible content.
      expect(find.byType(MiniHarmonizerBar), findsOneWidget);
      expect(find.byIcon(Icons.stop), findsNothing);
    });

    testWidgets('shows stop button and timers when harmonizing', (
      tester,
    ) async {
      when(() => mockHarmonizer.currentState).thenReturn(
        const HarmonizerState(
          status: HarmonizerStatus.harmonizing,
          isFirstCycle: true,
          firstCycleDuration: Duration(minutes: 5),
          remainingInCycle: Duration(minutes: 3, seconds: 10),
        ),
      );

      await tester.pumpWidget(_buildApp(child: const MiniHarmonizerBar()));
      await tester.pump();

      expect(find.text('05:00'), findsOneWidget);
      expect(find.text('03:10'), findsOneWidget);
      expect(find.byIcon(Icons.stop), findsOneWidget);
    });

    testWidgets('shows loading spinner when stopping', (tester) async {
      when(() => mockHarmonizer.currentState).thenReturn(
        const HarmonizerState(
          status: HarmonizerStatus.stopping,
          remainingInCycle: Duration(minutes: 1),
        ),
      );

      await tester.pumpWidget(_buildApp(child: const MiniHarmonizerBar()));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.stop), findsNothing);
    });

    testWidgets('updates timers from stream', (tester) async {
      when(() => mockHarmonizer.currentState).thenReturn(
        const HarmonizerState(
          status: HarmonizerStatus.harmonizing,
          isFirstCycle: false,
          totalCycleDuration: Duration(minutes: 2),
          remainingInCycle: Duration(minutes: 1, seconds: 30),
        ),
      );

      await tester.pumpWidget(_buildApp(child: const MiniHarmonizerBar()));
      await tester.pump();

      expect(find.text('02:00'), findsOneWidget);
      expect(find.text('01:30'), findsOneWidget);

      // Emit updated state.
      ctrl.add(
        const HarmonizerState(
          status: HarmonizerStatus.harmonizing,
          isFirstCycle: false,
          totalCycleDuration: Duration(minutes: 2),
          remainingInCycle: Duration(minutes: 0, seconds: 45),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('00:45'), findsOneWidget);
    });

    testWidgets('stop button calls stopGraceful', (tester) async {
      when(
        () => mockHarmonizer.currentState,
      ).thenReturn(const HarmonizerState(status: HarmonizerStatus.harmonizing));

      await tester.pumpWidget(_buildApp(child: const MiniHarmonizerBar()));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.stop));
      await tester.pump();

      verify(() => mockHarmonizer.stopGraceful()).called(1);
    });
  });
}
