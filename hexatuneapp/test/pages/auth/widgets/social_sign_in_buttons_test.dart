// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/pages/auth/widgets/social_sign_in_buttons.dart';

Widget _buildApp({
  VoidCallback? onApplePressed,
  VoidCallback? onGooglePressed,
  bool isLoading = false,
}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: Scaffold(
      body: SocialSignInButtons(
        onApplePressed: onApplePressed,
        onGooglePressed: onGooglePressed,
        isLoading: isLoading,
      ),
    ),
  );
}

void main() {
  group('SocialSignInButtons', () {
    testWidgets('renders Apple and Google button labels', (tester) async {
      await tester.pumpWidget(
        _buildApp(onApplePressed: () {}, onGooglePressed: () {}),
      );
      await tester.pumpAndSettle();

      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Google'), findsOneWidget);
    });

    testWidgets('renders "or continue with" divider text', (tester) async {
      await tester.pumpWidget(
        _buildApp(onApplePressed: () {}, onGooglePressed: () {}),
      );
      await tester.pumpAndSettle();

      expect(find.text('or continue with'), findsOneWidget);
    });

    testWidgets('renders Apple icon', (tester) async {
      await tester.pumpWidget(
        _buildApp(onApplePressed: () {}, onGooglePressed: () {}),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.apple), findsOneWidget);
    });

    testWidgets('renders Google "G" text icon', (tester) async {
      await tester.pumpWidget(
        _buildApp(onApplePressed: () {}, onGooglePressed: () {}),
      );
      await tester.pumpAndSettle();

      expect(find.text('G'), findsOneWidget);
    });

    testWidgets('fires onApplePressed callback when Apple button is tapped', (
      tester,
    ) async {
      var appleTapped = false;
      await tester.pumpWidget(
        _buildApp(
          onApplePressed: () => appleTapped = true,
          onGooglePressed: () {},
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Apple'));
      await tester.pump();

      expect(appleTapped, isTrue);
    });

    testWidgets('fires onGooglePressed callback when Google button is tapped', (
      tester,
    ) async {
      var googleTapped = false;
      await tester.pumpWidget(
        _buildApp(
          onApplePressed: () {},
          onGooglePressed: () => googleTapped = true,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Google'));
      await tester.pump();

      expect(googleTapped, isTrue);
    });

    testWidgets('disables buttons when isLoading is true', (tester) async {
      var appleTapped = false;
      var googleTapped = false;
      await tester.pumpWidget(
        _buildApp(
          onApplePressed: () => appleTapped = true,
          onGooglePressed: () => googleTapped = true,
          isLoading: true,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Apple'));
      await tester.tap(find.text('Google'));
      await tester.pump();

      expect(appleTapped, isFalse);
      expect(googleTapped, isFalse);
    });

    testWidgets('renders two FilledButton widgets', (tester) async {
      await tester.pumpWidget(
        _buildApp(onApplePressed: () {}, onGooglePressed: () {}),
      );
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate((w) => w is FilledButton),
        findsNWidgets(2),
      );
    });
  });
}
