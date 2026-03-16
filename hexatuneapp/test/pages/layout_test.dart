// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/pages/layout.dart';

Widget _buildApp() {
  return const MaterialApp(home: MainPage());
}

void main() {
  group('MainPage', () {
    testWidgets('renders a Scaffold', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('displays the app name text', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.text('hexaTuneApp'), findsOneWidget);
    });

    testWidgets('centers the text content', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(Center), findsOneWidget);
    });

    testWidgets('uses headlineMedium text style', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      final textWidget = tester.widget<Text>(find.text('hexaTuneApp'));
      expect(textWidget.style, isNotNull);
    });
  });
}
