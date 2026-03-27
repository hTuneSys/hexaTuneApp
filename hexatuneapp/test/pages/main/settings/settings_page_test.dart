// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/pages/main/settings/settings_page.dart';

Widget _buildApp() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: const SettingsPage(),
  );
}

void main() {
  group('SettingsPage', () {
    testWidgets('shows appbar title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('shows linked accounts item', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Linked Accounts'), findsOneWidget);
      expect(find.text('Manage your authentication providers'), findsOneWidget);
    });

    testWidgets('shows link icon', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.link), findsOneWidget);
    });

    testWidgets('shows chevron trailing icon', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('linked accounts item is tappable', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final listTile = find.byType(ListTile);
      expect(listTile, findsOneWidget);
      expect(tester.widget<ListTile>(listTile).onTap, isNotNull);
    });
  });
}
