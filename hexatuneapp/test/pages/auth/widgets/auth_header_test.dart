// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/pages/auth/widgets/auth_header.dart';

Widget _buildApp({double? size}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: Scaffold(body: AuthHeader(size: size ?? 80)),
  );
}

void main() {
  group('AuthHeader', () {
    testWidgets('renders column with image and brand name', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(AuthHeader), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(find.text('hexaTune'), findsOneWidget);
    });

    testWidgets('uses headlineMedium text style for brand name', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      final textWidget = tester.widget<Text>(find.text('hexaTune'));
      expect(textWidget.style?.fontWeight, FontWeight.w600);
    });

    testWidgets('respects custom size parameter', (tester) async {
      const customSize = 120.0;
      await tester.pumpWidget(_buildApp(size: customSize));
      await tester.pump();

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.width, customSize);
      expect(image.height, customSize);
    });

    testWidgets('uses default size of 80', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.width, 80);
      expect(image.height, 80);
    });
  });
}
