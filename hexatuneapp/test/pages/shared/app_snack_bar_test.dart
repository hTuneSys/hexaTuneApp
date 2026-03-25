// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/pages/shared/app_snack_bar.dart';

Widget _buildApp({required Widget child}) {
  return MaterialApp(
    theme: ThemeData(useMaterial3: true, colorScheme: const ColorScheme.light()),
    home: Scaffold(body: child),
  );
}

void main() {
  group('AppSnackBar', () {
    group('success', () {
      testWidgets('shows floating snackbar with check icon', (tester) async {
        await tester.pumpWidget(_buildApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () =>
                  AppSnackBar.success(context, message: 'Item created'),
              child: const Text('Trigger'),
            ),
          ),
        ));
        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        expect(find.text('Item created'), findsOneWidget);
        expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);

        final snackBar =
            tester.widget<SnackBar>(find.byType(SnackBar));
        expect(snackBar.behavior, SnackBarBehavior.floating);
        expect(snackBar.duration, const Duration(seconds: 2));
      });
    });

    group('error', () {
      testWidgets('shows floating snackbar with error icon', (tester) async {
        await tester.pumpWidget(_buildApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () =>
                  AppSnackBar.error(context, message: 'Something failed'),
              child: const Text('Trigger'),
            ),
          ),
        ));
        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        expect(find.text('Something failed'), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);

        final snackBar =
            tester.widget<SnackBar>(find.byType(SnackBar));
        expect(snackBar.behavior, SnackBarBehavior.floating);
        expect(snackBar.duration, const Duration(milliseconds: 3500));
      });
    });

    group('info', () {
      testWidgets('shows floating snackbar with info icon', (tester) async {
        await tester.pumpWidget(_buildApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () =>
                  AppSnackBar.info(context, message: 'Session expired'),
              child: const Text('Trigger'),
            ),
          ),
        ));
        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        expect(find.text('Session expired'), findsOneWidget);
        expect(find.byIcon(Icons.info_outline), findsOneWidget);

        final snackBar =
            tester.widget<SnackBar>(find.byType(SnackBar));
        expect(snackBar.behavior, SnackBarBehavior.floating);
        expect(snackBar.duration, const Duration(seconds: 3));
      });
    });

    group('styling', () {
      testWidgets('has rounded corners with radius 12', (tester) async {
        await tester.pumpWidget(_buildApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () =>
                  AppSnackBar.success(context, message: 'Test'),
              child: const Text('Trigger'),
            ),
          ),
        ));
        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        final snackBar =
            tester.widget<SnackBar>(find.byType(SnackBar));
        final shape = snackBar.shape! as RoundedRectangleBorder;
        final radius = shape.borderRadius as BorderRadius;
        expect(radius.topLeft.x, 12.0);
      });

      testWidgets('has elevation 3', (tester) async {
        await tester.pumpWidget(_buildApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () =>
                  AppSnackBar.success(context, message: 'Test'),
              child: const Text('Trigger'),
            ),
          ),
        ));
        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        final snackBar =
            tester.widget<SnackBar>(find.byType(SnackBar));
        expect(snackBar.elevation, 3.0);
      });

      testWidgets('has horizontal margin of 16', (tester) async {
        await tester.pumpWidget(_buildApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () =>
                  AppSnackBar.success(context, message: 'Test'),
              child: const Text('Trigger'),
            ),
          ),
        ));
        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        final snackBar =
            tester.widget<SnackBar>(find.byType(SnackBar));
        expect(snackBar.margin, const EdgeInsets.all(16));
      });
    });

    group('action', () {
      testWidgets('shows action button when label provided', (tester) async {
        var tapped = false;
        await tester.pumpWidget(_buildApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => AppSnackBar.error(
                context,
                message: 'Failed',
                actionLabel: 'Retry',
                onAction: () => tapped = true,
              ),
              child: const Text('Trigger'),
            ),
          ),
        ));
        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        expect(find.text('Retry'), findsOneWidget);
        await tester.tap(find.text('Retry'));
        expect(tapped, isTrue);
      });
    });

    group('clear', () {
      testWidgets('clears previous snackbar before showing new one',
          (tester) async {
        await tester.pumpWidget(_buildApp(
          child: Builder(
            builder: (context) => Column(
              children: [
                ElevatedButton(
                  onPressed: () =>
                      AppSnackBar.success(context, message: 'Msg A'),
                  child: const Text('Btn1'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      AppSnackBar.error(context, message: 'Msg B'),
                  child: const Text('Btn2'),
                ),
              ],
            ),
          ),
        ));

        await tester.tap(find.text('Btn1'));
        await tester.pumpAndSettle();
        expect(find.text('Msg A'), findsOneWidget);

        await tester.tap(find.text('Btn2'));
        await tester.pumpAndSettle();
        expect(find.text('Msg B'), findsOneWidget);
        expect(find.text('Msg A'), findsNothing);
      });
    });
  });
}
