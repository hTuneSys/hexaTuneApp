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

    group('internal menu items', () {
      final internalItems = <Map<String, dynamic>>[
        {
          'title': 'Profile',
          'subtitle': 'Account info and profile settings',
          'icon': Icons.person_outline,
        },
        {
          'title': 'Wallet',
          'subtitle': 'Balance and transactions',
          'icon': Icons.account_balance_wallet_outlined,
        },
        {
          'title': 'Sessions',
          'subtitle': 'Manage active sessions',
          'icon': Icons.schedule_outlined,
        },
        {
          'title': 'Devices',
          'subtitle': 'Manage registered devices',
          'icon': Icons.devices_outlined,
        },
        {
          'title': 'Linked Accounts',
          'subtitle': 'Manage your authentication providers',
          'icon': Icons.link,
        },
        {
          'title': 'Log Monitor',
          'subtitle': 'Real-time debug logs and diagnostics',
          'icon': Icons.bug_report,
        },
      ];

      for (final item in internalItems) {
        testWidgets('shows ${item['title']} item', (tester) async {
          await tester.pumpWidget(_buildApp());
          await tester.pumpAndSettle();

          await tester.scrollUntilVisible(
            find.text(item['title'] as String),
            200,
          );
          expect(find.text(item['title'] as String), findsOneWidget);
          expect(find.text(item['subtitle'] as String), findsOneWidget);
        });
      }

      testWidgets('shows chevron_right trailing icons', (tester) async {
        await tester.pumpWidget(_buildApp());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.chevron_right), findsNWidgets(6));
      });
    });

    group('external menu items', () {
      final externalItems = <Map<String, dynamic>>[
        {'title': 'About', 'icon': Icons.info_outline},
        {'title': 'Privacy Policy', 'icon': Icons.privacy_tip_outlined},
        {'title': 'Terms of Service', 'icon': Icons.description_outlined},
      ];

      for (final item in externalItems) {
        testWidgets('shows ${item['title']} item', (tester) async {
          await tester.pumpWidget(_buildApp());
          await tester.pumpAndSettle();

          await tester.scrollUntilVisible(
            find.text(item['title'] as String),
            200,
          );
          expect(find.text(item['title'] as String), findsOneWidget);
        });
      }

      testWidgets('shows open_in_new trailing icons', (tester) async {
        await tester.pumpWidget(_buildApp());
        await tester.pumpAndSettle();

        await tester.scrollUntilVisible(find.text('Terms of Service'), 200);
        expect(find.byIcon(Icons.open_in_new), findsNWidgets(3));
      });
    });

    testWidgets('shows divider between internal and external items', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('shows all 9 leading icons', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(
        find.byIcon(Icons.account_balance_wallet_outlined),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.schedule_outlined), findsOneWidget);
      expect(find.byIcon(Icons.devices_outlined), findsOneWidget);
      expect(find.byIcon(Icons.link), findsOneWidget);
      expect(find.byIcon(Icons.bug_report), findsOneWidget);

      await tester.scrollUntilVisible(find.text('Terms of Service'), 200);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
      expect(find.byIcon(Icons.privacy_tip_outlined), findsOneWidget);
      expect(find.byIcon(Icons.description_outlined), findsOneWidget);
    });

    testWidgets('all items are tappable', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      final listTiles = find.byType(ListTile, skipOffstage: false);
      expect(listTiles, findsNWidgets(9));

      for (var i = 0; i < 9; i++) {
        expect(
          tester.widget<ListTile>(listTiles.at(i)).onTap,
          isNotNull,
          reason: 'ListTile at index $i should be tappable',
        );
      }
    });

    testWidgets('renders 9 Card widgets for menu items', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(Card, skipOffstage: false), findsNWidgets(9));
    });
  });
}
