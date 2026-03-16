// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/bootstrap/bootstrap_step.dart';
import 'package:hexatuneapp/src/pages/shared/splash_page.dart';

Widget _buildApp({
  ValueNotifier<List<BootstrapStep>>? steps,
  VoidCallback? onRetry,
}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: SplashPage(steps: steps, onRetry: onRetry),
  );
}

void main() {
  group('SplashPage', () {
    testWidgets('renders without errors', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(SplashPage), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('displays app name', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('hexaTune'), findsOneWidget);
    });

    testWidgets('displays app icon image', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('does not show bootstrap progress without steps', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // No progress indicators when no steps
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows bootstrap steps when provided', (tester) async {
      final steps = ValueNotifier<List<BootstrapStep>>([
        const BootstrapStep(
          label: 'Loading config',
          status: BootstrapStepStatus.done,
        ),
        const BootstrapStep(
          label: 'Connecting',
          status: BootstrapStepStatus.running,
        ),
        const BootstrapStep(
          label: 'Syncing data',
          status: BootstrapStepStatus.pending,
        ),
      ]);

      await tester.pumpWidget(_buildApp(steps: steps));
      await tester.pump();

      expect(find.text('Loading config'), findsOneWidget);
      expect(find.text('Connecting'), findsOneWidget);
      expect(find.text('Syncing data'), findsOneWidget);
    });

    testWidgets('shows check icon for completed steps', (tester) async {
      final steps = ValueNotifier<List<BootstrapStep>>([
        const BootstrapStep(
          label: 'Done step',
          status: BootstrapStepStatus.done,
        ),
      ]);

      await tester.pumpWidget(_buildApp(steps: steps));
      await tester.pump();

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('shows error icon and message for failed steps', (
      tester,
    ) async {
      final steps = ValueNotifier<List<BootstrapStep>>([
        const BootstrapStep(
          label: 'Failed step',
          status: BootstrapStepStatus.error,
          error: 'Connection timeout',
        ),
      ]);

      await tester.pumpWidget(_buildApp(steps: steps, onRetry: () {}));
      await tester.pump();

      expect(find.byIcon(Icons.error), findsOneWidget);
      expect(find.text('Connection timeout'), findsOneWidget);
    });

    testWidgets(
      'shows retry button when a step has an error and onRetry given',
      (tester) async {
        var retryCalled = false;
        final steps = ValueNotifier<List<BootstrapStep>>([
          const BootstrapStep(
            label: 'Broken',
            status: BootstrapStepStatus.error,
            error: 'fail',
          ),
        ]);

        await tester.pumpWidget(
          _buildApp(steps: steps, onRetry: () => retryCalled = true),
        );
        await tester.pump();

        final retryButton = find.text('Retry');
        expect(retryButton, findsOneWidget);

        await tester.tap(retryButton);
        expect(retryCalled, isTrue);
      },
    );

    testWidgets('does not show retry button without onRetry callback', (
      tester,
    ) async {
      final steps = ValueNotifier<List<BootstrapStep>>([
        const BootstrapStep(
          label: 'Broken',
          status: BootstrapStepStatus.error,
          error: 'fail',
        ),
      ]);

      await tester.pumpWidget(_buildApp(steps: steps));
      await tester.pump();

      expect(find.widgetWithText(FilledButton, 'Retry'), findsNothing);
    });

    testWidgets('shows progress indicator for running step', (tester) async {
      final steps = ValueNotifier<List<BootstrapStep>>([
        const BootstrapStep(
          label: 'Loading',
          status: BootstrapStepStatus.running,
        ),
      ]);

      await tester.pumpWidget(_buildApp(steps: steps));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows pending icon for pending steps', (tester) async {
      final steps = ValueNotifier<List<BootstrapStep>>([
        const BootstrapStep(
          label: 'Waiting',
          status: BootstrapStepStatus.pending,
        ),
      ]);

      await tester.pumpWidget(_buildApp(steps: steps));
      await tester.pump();

      expect(find.byIcon(Icons.circle_outlined), findsOneWidget);
    });
  });
}
