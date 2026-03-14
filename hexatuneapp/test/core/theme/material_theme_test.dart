// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/theme/hexatune.dart';

void main() {
  group('MaterialTheme', () {
    group('lightScheme', () {
      test('returns a light color scheme', () {
        final scheme = MaterialTheme.lightScheme();
        expect(scheme.brightness, Brightness.light);
      });

      test('primary color is teal-based', () {
        final scheme = MaterialTheme.lightScheme();
        expect(scheme.primary, const Color(0xff006874));
      });

      test('has all required color scheme fields', () {
        final scheme = MaterialTheme.lightScheme();
        expect(scheme.onPrimary, isNotNull);
        expect(scheme.secondary, isNotNull);
        expect(scheme.onSecondary, isNotNull);
        expect(scheme.error, isNotNull);
        expect(scheme.onError, isNotNull);
        expect(scheme.surface, isNotNull);
        expect(scheme.onSurface, isNotNull);
      });
    });

    group('darkScheme', () {
      test('returns a dark color scheme', () {
        final scheme = MaterialTheme.darkScheme();
        expect(scheme.brightness, Brightness.dark);
      });

      test('has all required color scheme fields', () {
        final scheme = MaterialTheme.darkScheme();
        expect(scheme.primary, isNotNull);
        expect(scheme.onPrimary, isNotNull);
        expect(scheme.secondary, isNotNull);
        expect(scheme.error, isNotNull);
        expect(scheme.surface, isNotNull);
      });
    });

    group('theme builders', () {
      test('light() returns ThemeData with light scheme', () {
        const theme = MaterialTheme(TextTheme());
        final themeData = theme.light();
        expect(themeData.brightness, Brightness.light);
        expect(themeData.colorScheme.primary, const Color(0xff006874));
      });

      test('dark() returns ThemeData with dark scheme', () {
        const theme = MaterialTheme(TextTheme());
        final themeData = theme.dark();
        expect(themeData.brightness, Brightness.dark);
      });

      test('lightMediumContrast() returns ThemeData', () {
        const theme = MaterialTheme(TextTheme());
        final themeData = theme.lightMediumContrast();
        expect(themeData.brightness, Brightness.light);
      });

      test('darkMediumContrast() returns ThemeData', () {
        const theme = MaterialTheme(TextTheme());
        final themeData = theme.darkMediumContrast();
        expect(themeData.brightness, Brightness.dark);
      });

      test('lightHighContrast() returns ThemeData', () {
        const theme = MaterialTheme(TextTheme());
        final themeData = theme.lightHighContrast();
        expect(themeData.brightness, Brightness.light);
      });

      test('darkHighContrast() returns ThemeData', () {
        const theme = MaterialTheme(TextTheme());
        final themeData = theme.darkHighContrast();
        expect(themeData.brightness, Brightness.dark);
      });
    });
  });
}
