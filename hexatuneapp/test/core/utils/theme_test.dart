// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/utils/theme.dart';

class MockLogService extends Mock implements LogService {}

void main() {
  group('createTextTheme', () {
    late MockLogService mockLogService;

    setUp(() {
      mockLogService = MockLogService();
      final getIt = GetIt.instance;
      if (getIt.isRegistered<LogService>()) {
        getIt.unregister<LogService>();
      }
      getIt.registerSingleton<LogService>(mockLogService);
    });

    tearDown(() {
      final getIt = GetIt.instance;
      if (getIt.isRegistered<LogService>()) {
        getIt.unregister<LogService>();
      }
    });

    testWidgets('returns a TextTheme with Inter for body styles', (
      tester,
    ) async {
      late TextTheme result;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              result = createTextTheme(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(result.bodyLarge?.fontFamily, 'Inter');
      expect(result.bodyMedium?.fontFamily, 'Inter');
      expect(result.bodySmall?.fontFamily, 'Inter');
    });

    testWidgets('returns a TextTheme with Inter for label styles', (
      tester,
    ) async {
      late TextTheme result;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              result = createTextTheme(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(result.labelLarge?.fontFamily, 'Inter');
      expect(result.labelMedium?.fontFamily, 'Inter');
      expect(result.labelSmall?.fontFamily, 'Inter');
    });

    testWidgets('returns a TextTheme with Rajdhani for display styles', (
      tester,
    ) async {
      late TextTheme result;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              result = createTextTheme(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(result.displayLarge?.fontFamily, 'Rajdhani');
      expect(result.displayMedium?.fontFamily, 'Rajdhani');
      expect(result.displaySmall?.fontFamily, 'Rajdhani');
    });

    testWidgets('returns a TextTheme with Rajdhani for headline styles', (
      tester,
    ) async {
      late TextTheme result;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              result = createTextTheme(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(result.headlineLarge?.fontFamily, 'Rajdhani');
      expect(result.headlineMedium?.fontFamily, 'Rajdhani');
      expect(result.headlineSmall?.fontFamily, 'Rajdhani');
    });

    testWidgets('returns a TextTheme with Rajdhani for title styles', (
      tester,
    ) async {
      late TextTheme result;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              result = createTextTheme(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(result.titleLarge?.fontFamily, 'Rajdhani');
      expect(result.titleMedium?.fontFamily, 'Rajdhani');
      expect(result.titleSmall?.fontFamily, 'Rajdhani');
    });

    testWidgets('logs active font families', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              createTextTheme(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      verify(
        () => mockLogService.info(
          any(that: contains('Body:')),
          category: LogCategory.app,
        ),
      ).called(1);
    });
  });
}
