// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/pages/shared/auth/widgets/password_strength_indicator.dart';

Widget _buildApp({required String password}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: Scaffold(body: PasswordStrengthIndicator(password: password)),
  );
}

void main() {
  group('PasswordStrengthIndicator', () {
    testWidgets('shows weak label for a short lowercase password', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp(password: 'abc'));
      await tester.pumpAndSettle();

      expect(find.text('weak'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('shows fair label for long password with uppercase', (
      tester,
    ) async {
      // length >= 8 (+0.25) + uppercase (+0.25) = 0.5 → fair
      await tester.pumpWidget(_buildApp(password: 'Abcdefgh'));
      await tester.pumpAndSettle();

      expect(find.text('fair'), findsOneWidget);
    });

    testWidgets('shows good label for length + uppercase + digit', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp(password: 'Abcdefg1'));
      await tester.pumpAndSettle();

      expect(find.text('good'), findsOneWidget);
    });

    testWidgets(
      'shows strong label for length + uppercase + digit + special char',
      (tester) async {
        await tester.pumpWidget(_buildApp(password: r'Abcdefg1!'));
        await tester.pumpAndSettle();

        expect(find.text('strong'), findsOneWidget);
      },
    );

    testWidgets('shows weak label for empty password', (tester) async {
      await tester.pumpWidget(_buildApp(password: ''));
      await tester.pumpAndSettle();

      expect(find.text('weak'), findsOneWidget);
    });

    testWidgets('contains a LinearProgressIndicator', (tester) async {
      await tester.pumpWidget(_buildApp(password: 'test'));
      await tester.pumpAndSettle();

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('uses Row layout with indicator and label', (tester) async {
      await tester.pumpWidget(_buildApp(password: 'test'));
      await tester.pumpAndSettle();

      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });
  });
}
