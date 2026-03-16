// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/pages/shared/widgets/hexagonal_background.dart';

Widget _buildApp() {
  return MaterialApp(
    home: Scaffold(body: Stack(children: const [HexagonalBackground()])),
  );
}

void main() {
  group('HexagonalBackground', () {
    testWidgets('renders without errors', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(find.byType(HexagonalBackground), findsOneWidget);
    });

    testWidgets('contains a CustomPaint widget', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      expect(
        find.descendant(
          of: find.byType(HexagonalBackground),
          matching: find.byType(CustomPaint),
        ),
        findsOneWidget,
      );
    });

    testWidgets('uses Positioned.fill to cover the parent', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      final positioned = tester.widget<Positioned>(find.byType(Positioned));
      expect(positioned.left, 0.0);
      expect(positioned.right, 0.0);
      expect(positioned.top, 0.0);
      expect(positioned.bottom, 0.0);
    });
  });
}
