// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/pages/shared/app_bottom_bar.dart';

Widget _buildBarApp({ValueChanged<int>? onItemTapped}) {
  return MaterialApp(
    home: Scaffold(
      bottomNavigationBar: AppBottomBar(onItemTapped: onItemTapped),
      floatingActionButton: const AppCenterFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    ),
  );
}

Widget _buildFabApp({VoidCallback? onPressed}) {
  return MaterialApp(
    home: Scaffold(floatingActionButton: AppCenterFab(onPressed: onPressed)),
  );
}

void main() {
  group('AppBottomBar', () {
    testWidgets('renders BottomAppBar with four icon buttons', (tester) async {
      await tester.pumpWidget(_buildBarApp());

      expect(find.byType(AppBottomBar), findsOneWidget);
      expect(find.byType(BottomAppBar), findsOneWidget);
      expect(find.byType(IconButton), findsNWidgets(4));
    });

    testWidgets('displays correct icons', (tester) async {
      await tester.pumpWidget(_buildBarApp());

      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.library_music_outlined), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('has a center gap spacer for the FAB', (tester) async {
      await tester.pumpWidget(_buildBarApp());

      final sizedBoxes = tester.widgetList<SizedBox>(
        find.descendant(of: find.byType(Row), matching: find.byType(SizedBox)),
      );
      final gap = sizedBoxes.where((sb) => sb.width == 48);
      expect(gap.length, 1);
    });

    testWidgets('fires onItemTapped with correct index for each button', (
      tester,
    ) async {
      final tapped = <int>[];
      await tester.pumpWidget(_buildBarApp(onItemTapped: (i) => tapped.add(i)));

      await tester.tap(find.byIcon(Icons.home_outlined));
      await tester.tap(find.byIcon(Icons.search));
      await tester.tap(find.byIcon(Icons.library_music_outlined));
      await tester.tap(find.byIcon(Icons.person_outline));

      expect(tapped, [0, 1, 2, 3]);
    });

    testWidgets('tapping icons does not crash when onItemTapped is null', (
      tester,
    ) async {
      await tester.pumpWidget(_buildBarApp());

      await tester.tap(find.byIcon(Icons.home_outlined));
      await tester.tap(find.byIcon(Icons.search));
      await tester.tap(find.byIcon(Icons.library_music_outlined));
      await tester.tap(find.byIcon(Icons.person_outline));

      // No exception means pass
    });

    testWidgets('uses CircularNotchedRectangle shape', (tester) async {
      await tester.pumpWidget(_buildBarApp());

      final bar = tester.widget<BottomAppBar>(find.byType(BottomAppBar));
      expect(bar.shape, isA<CircularNotchedRectangle>());
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
          home: const Scaffold(bottomNavigationBar: AppBottomBar()),
        ),
      );

      final buttons = tester.widgetList<IconButton>(find.byType(IconButton));
      for (final button in buttons) {
        expect(button.color, testColor);
      }
    });
  });

  group('AppCenterFab', () {
    testWidgets('renders FloatingActionButton with hexagon icon', (
      tester,
    ) async {
      await tester.pumpWidget(_buildFabApp());

      expect(find.byType(AppCenterFab), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.hexagon_outlined), findsOneWidget);
    });

    testWidgets('fires onPressed callback when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_buildFabApp(onPressed: () => tapped = true));

      await tester.tap(find.byType(FloatingActionButton));
      expect(tapped, isTrue);
    });

    testWidgets('does not crash when onPressed is null', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(floatingActionButton: const AppCenterFab())),
      );

      await tester.tap(find.byType(FloatingActionButton));
      // No exception means pass
    });

    testWidgets('uses large FAB variant', (tester) async {
      await tester.pumpWidget(_buildFabApp());

      final size = tester.getSize(find.byType(FloatingActionButton));
      expect(size.width, greaterThanOrEqualTo(80));
      expect(size.height, greaterThanOrEqualTo(80));
    });
  });
}
