// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/theme/hexatune.dart';

void main() {
  group('MaterialTheme', () {
    late MaterialTheme theme;

    setUp(() {
      theme = const MaterialTheme(TextTheme());
    });

    test('light scheme has correct brightness', () {
      final scheme = MaterialTheme.lightScheme();
      expect(scheme.brightness, Brightness.light);
    });

    test('dark scheme has correct brightness', () {
      final scheme = MaterialTheme.darkScheme();
      expect(scheme.brightness, Brightness.dark);
    });

    test('light medium contrast scheme has correct brightness', () {
      final scheme = MaterialTheme.lightMediumContrastScheme();
      expect(scheme.brightness, Brightness.light);
    });

    test('dark medium contrast scheme has correct brightness', () {
      final scheme = MaterialTheme.darkMediumContrastScheme();
      expect(scheme.brightness, Brightness.dark);
    });

    test('light high contrast scheme has correct brightness', () {
      final scheme = MaterialTheme.lightHighContrastScheme();
      expect(scheme.brightness, Brightness.light);
    });

    test('dark high contrast scheme has correct brightness', () {
      final scheme = MaterialTheme.darkHighContrastScheme();
      expect(scheme.brightness, Brightness.dark);
    });

    test('light theme uses Material 3', () {
      final td = theme.light();
      expect(td.useMaterial3, isTrue);
    });

    test('dark theme uses Material 3', () {
      final td = theme.dark();
      expect(td.useMaterial3, isTrue);
    });

    test('light theme has correct color scheme', () {
      final td = theme.light();
      expect(td.colorScheme.brightness, Brightness.light);
      expect(td.colorScheme.primary, const Color(0xff006874));
    });

    test('dark theme has correct color scheme', () {
      final td = theme.dark();
      expect(td.colorScheme.brightness, Brightness.dark);
      expect(td.colorScheme.primary, const Color(0xff82d3e1));
    });

    test('theme method creates valid ThemeData', () {
      final scheme = MaterialTheme.lightScheme();
      final td = theme.theme(scheme);
      expect(td.useMaterial3, isTrue);
      expect(td.colorScheme, scheme);
      expect(td.scaffoldBackgroundColor, scheme.surface);
    });

    test('all six theme variants produce valid ThemeData', () {
      expect(theme.light(), isA<ThemeData>());
      expect(theme.dark(), isA<ThemeData>());
      expect(theme.lightMediumContrast(), isA<ThemeData>());
      expect(theme.darkMediumContrast(), isA<ThemeData>());
      expect(theme.lightHighContrast(), isA<ThemeData>());
      expect(theme.darkHighContrast(), isA<ThemeData>());
    });

    test('extendedColors returns empty list', () {
      expect(theme.extendedColors, isEmpty);
    });
  });

  group('ExtendedColor', () {
    test('can be created with required fields', () {
      const family = ColorFamily(
        color: Colors.red,
        onColor: Colors.white,
        colorContainer: Colors.redAccent,
        onColorContainer: Colors.black,
      );
      const extended = ExtendedColor(
        seed: Colors.red,
        value: Colors.red,
        light: family,
        lightHighContrast: family,
        lightMediumContrast: family,
        dark: family,
        darkHighContrast: family,
        darkMediumContrast: family,
      );
      expect(extended.seed, Colors.red);
      expect(extended.value, Colors.red);
    });
  });

  group('ColorFamily', () {
    test('can be created with required fields', () {
      const family = ColorFamily(
        color: Colors.blue,
        onColor: Colors.white,
        colorContainer: Colors.blueAccent,
        onColorContainer: Colors.black,
      );
      expect(family.color, Colors.blue);
      expect(family.onColor, Colors.white);
      expect(family.colorContainer, Colors.blueAccent);
      expect(family.onColorContainer, Colors.black);
    });
  });
}
