// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/pages/shared/app_bottom_bar.dart';

Widget _buildApp({
  ValueChanged<int>? onItemTapped,
  VoidCallback? onCenterTapped,
}) {
  return MaterialApp(
    home: Scaffold(
      extendBody: true,
      body: const SizedBox.expand(),
      bottomNavigationBar: AppBottomBar(
        onItemTapped: onItemTapped,
        onCenterTapped: onCenterTapped,
      ),
    ),
  );
}

void main() {
  group('AppBottomBar', () {
    testWidgets('renders with four icon buttons and a center hex button', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());

      expect(find.byType(AppBottomBar), findsOneWidget);
      expect(find.byType(IconButton), findsNWidgets(4));
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('displays correct navigation icons', (tester) async {
      await tester.pumpWidget(_buildApp());

      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
      expect(find.byIcon(Icons.newspaper_outlined), findsOneWidget);
      expect(find.byIcon(Icons.workspaces_outlined), findsOneWidget);
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    });

    testWidgets('displays harmonize icon in the center hex button', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());

      expect(find.byIcon(Icons.join_inner_rounded), findsOneWidget);
    });

    testWidgets('fires onItemTapped with correct index for each button', (
      tester,
    ) async {
      final tapped = <int>[];
      await tester.pumpWidget(_buildApp(onItemTapped: (i) => tapped.add(i)));

      await tester.tap(find.byIcon(Icons.home_outlined));
      await tester.tap(find.byIcon(Icons.newspaper_outlined));
      await tester.tap(find.byIcon(Icons.workspaces_outlined));
      await tester.tap(find.byIcon(Icons.settings_outlined));

      expect(tapped, [0, 1, 2, 3]);
    });

    testWidgets('fires onCenterTapped when hex button is tapped', (
      tester,
    ) async {
      var tapped = false;
      await tester.pumpWidget(_buildApp(onCenterTapped: () => tapped = true));

      await tester.tap(find.byIcon(Icons.join_inner_rounded));
      expect(tapped, isTrue);
    });

    testWidgets('tapping icons does not crash when callbacks are null', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());

      await tester.tap(find.byIcon(Icons.home_outlined));
      await tester.tap(find.byIcon(Icons.newspaper_outlined));
      await tester.tap(find.byIcon(Icons.workspaces_outlined));
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.tap(find.byIcon(Icons.join_inner_rounded));
    });

    testWidgets('bar floats with padding from edges', (tester) async {
      await tester.pumpWidget(_buildApp());

      final padding = tester.widget<Padding>(
        find
            .descendant(
              of: find.byType(AppBottomBar),
              matching: find.byType(Padding),
            )
            .first,
      );
      final insets = padding.padding as EdgeInsets;
      expect(insets.left, 16);
      expect(insets.right, 16);
      expect(insets.bottom, greaterThanOrEqualTo(16));
    });

    testWidgets('bar uses Material with elevation for floating effect', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());

      final material = tester.widget<Material>(
        find
            .descendant(
              of: find.byType(AppBottomBar),
              matching: find.byType(Material),
            )
            .first,
      );
      expect(material.elevation, 3);
    });

    testWidgets('icon colors come from theme colorScheme.onSurface', (
      tester,
    ) async {
      const testColor = Color(0xFFFF0000);
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
            ).copyWith(onSurface: testColor),
          ),
          home: const Scaffold(
            extendBody: true,
            bottomNavigationBar: AppBottomBar(),
          ),
        ),
      );

      final buttons = tester.widgetList<IconButton>(find.byType(IconButton));
      for (final button in buttons) {
        expect(button.color, testColor);
      }
    });
  });
}
