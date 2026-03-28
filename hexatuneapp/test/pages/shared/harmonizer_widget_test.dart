// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/dsp/ambience/models/ambience_config.dart';
import 'package:hexatuneapp/src/core/harmonizer/models/generation_type.dart';
import 'package:hexatuneapp/src/core/harmonizer/models/harmonizer_state.dart';
import 'package:hexatuneapp/src/pages/shared/harmonizer_widget.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _buildApp({required Widget child}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: child,
  );
}

HarmonizerWidget _buildWidget({
  GenerationType selectedType = GenerationType.monaural,
  HarmonizerState harmonizerState = const HarmonizerState(),
  bool headsetConnected = false,
  bool hexagenConnected = false,
  AmbienceConfig? selectedAmbience,
  List<AmbienceConfig> ambienceConfigs = const [],
  bool isActive = false,
  bool generating = false,
  bool canHarmonize = false,
  ValueChanged<GenerationType>? onTypeChanged,
  ValueChanged<AmbienceConfig?>? onAmbienceChanged,
  VoidCallback? onHarmonize,
  VoidCallback? onStopGraceful,
  VoidCallback? onImmediateStart,
  VoidCallback? onImmediateEnd,
}) {
  return HarmonizerWidget(
    selectedType: selectedType,
    harmonizerState: harmonizerState,
    headsetConnected: headsetConnected,
    hexagenConnected: hexagenConnected,
    selectedAmbience: selectedAmbience,
    ambienceConfigs: ambienceConfigs,
    isActive: isActive,
    generating: generating,
    canHarmonize: canHarmonize,
    onTypeChanged: onTypeChanged ?? (_) {},
    onAmbienceChanged: onAmbienceChanged ?? (_) {},
    onHarmonize: onHarmonize ?? () {},
    onStopGraceful: onStopGraceful ?? () {},
    onImmediateStart: onImmediateStart ?? () {},
    onImmediateEnd: onImmediateEnd ?? () {},
  );
}

void main() {
  // ---------------------------------------------------------------------------
  // Rendering
  // ---------------------------------------------------------------------------

  group('HarmonizerWidget rendering', () {
    testWidgets('renders all type tabs with correct icons', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          child: Scaffold(body: ListView(children: [_buildWidget()])),
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
              children: [_buildWidget(isActive: true, generating: true)],
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows harmonize button when idle', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          child: Scaffold(body: ListView(children: [_buildWidget()])),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.join_inner_rounded), findsOneWidget);
    });

    testWidgets('shows stop button when harmonizing', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          child: Scaffold(
            body: ListView(
              children: [
                _buildWidget(
                  harmonizerState: const HarmonizerState(
                    status: HarmonizerStatus.harmonizing,
                  ),
                  isActive: true,
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.stop_rounded), findsOneWidget);
    });

    testWidgets('shows --:-- for both timers when idle', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          child: Scaffold(body: ListView(children: [_buildWidget()])),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('--:--'), findsNWidgets(2));
    });

    testWidgets('shows Total and Remaining labels', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          child: Scaffold(body: ListView(children: [_buildWidget()])),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Total'), findsOneWidget);
      expect(find.text('Remaining'), findsOneWidget);
    });

    testWidgets('shows duration and remaining when harmonizing', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildApp(
          child: Scaffold(
            body: ListView(
              children: [
                _buildWidget(
                  harmonizerState: const HarmonizerState(
                    status: HarmonizerStatus.harmonizing,
                    isFirstCycle: false,
                    totalCycleDuration: Duration(minutes: 5, seconds: 30),
                    remainingInCycle: Duration(minutes: 3, seconds: 15),
                  ),
                  isActive: true,
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('05:30'), findsOneWidget);
      expect(find.text('03:15'), findsOneWidget);
    });

    testWidgets('shows error message on error state', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          child: Scaffold(
            body: ListView(
              children: [
                _buildWidget(
                  harmonizerState: const HarmonizerState(
                    status: HarmonizerStatus.error,
                    errorMessage: 'DSP init failed',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Error: DSP init failed'), findsOneWidget);
    });

    testWidgets('shows loading spinner when stopping', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          child: Scaffold(
            body: ListView(
              children: [
                _buildWidget(
                  harmonizerState: const HarmonizerState(
                    status: HarmonizerStatus.stopping,
                    remainingInCycle: Duration(minutes: 1),
                  ),
                  isActive: true,
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.stop_rounded), findsNothing);
    });
  });

  // ---------------------------------------------------------------------------
  // Ambience
  // ---------------------------------------------------------------------------

  group('HarmonizerWidget ambience', () {
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
            body: ListView(children: [_buildWidget(ambienceConfigs: configs)]),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('No ambience'));
      await tester.pumpAndSettle();

      expect(find.text('No ambience'), findsWidgets);
      expect(find.text('Forest Rain'), findsWidgets);
      expect(find.text('Ocean Breeze'), findsWidgets);
    });
  });

  // ---------------------------------------------------------------------------
  // Callbacks
  // ---------------------------------------------------------------------------

  group('HarmonizerWidget callbacks', () {
    testWidgets(
      'harmonize button calls onHarmonize when canHarmonize is true',
      (tester) async {
        var harmonizeCalled = false;

        await tester.pumpWidget(
          _buildApp(
            child: Scaffold(
              body: ListView(
                children: [
                  _buildWidget(
                    canHarmonize: true,
                    onHarmonize: () => harmonizeCalled = true,
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.join_inner_rounded));
        await tester.pumpAndSettle();

        expect(harmonizeCalled, isTrue);
      },
    );

    testWidgets('stop button calls onStopGraceful', (tester) async {
      var stopCalled = false;

      await tester.pumpWidget(
        _buildApp(
          child: Scaffold(
            body: ListView(
              children: [
                _buildWidget(
                  harmonizerState: const HarmonizerState(
                    status: HarmonizerStatus.harmonizing,
                  ),
                  isActive: true,
                  onStopGraceful: () => stopCalled = true,
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
  });

  // ---------------------------------------------------------------------------
  // Type tabs
  // ---------------------------------------------------------------------------

  group('HarmonizerWidget type tabs', () {
    testWidgets('Monaural shows ambience selector', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          child: Scaffold(body: ListView(children: [_buildWidget()])),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Monaural'), findsNWidgets(2));
      expect(find.text('Select ambience (optional)'), findsOneWidget);
    });

    testWidgets('Binaural shows headset warning when not connected', (
      tester,
    ) async {
      GenerationType? tappedType;

      await tester.pumpWidget(
        _buildApp(
          child: Scaffold(
            body: ListView(
              children: [
                _buildWidget(
                  selectedType: GenerationType.binaural,
                  onTypeChanged: (t) => tappedType = t,
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Please connect headphones for binaural mode'),
        findsOneWidget,
      );
      expect(tappedType, isNull);
    });

    testWidgets('Magnetic shows hexagen warning when not connected', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildApp(
          child: Scaffold(
            body: ListView(
              children: [_buildWidget(selectedType: GenerationType.magnetic)],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Please connect a hexaGen device for magnetic mode'),
        findsOneWidget,
      );
    });

    testWidgets('Photonic shows coming soon', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          child: Scaffold(
            body: ListView(
              children: [_buildWidget(selectedType: GenerationType.photonic)],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('This feature is coming soon'), findsOneWidget);
    });

    testWidgets('Quantal shows coming soon', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          child: Scaffold(
            body: ListView(
              children: [_buildWidget(selectedType: GenerationType.quantal)],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('This feature is coming soon'), findsOneWidget);
    });
  });
}
