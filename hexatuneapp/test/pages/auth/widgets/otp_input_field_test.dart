// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/pages/auth/widgets/otp_input_field.dart';

Widget _buildApp({
  required ValueChanged<String> onCompleted,
  ValueChanged<String>? onChanged,
  int length = 6,
}) {
  return MaterialApp(
    home: Scaffold(
      body: OtpInputField(
        onCompleted: onCompleted,
        onChanged: onChanged,
        length: length,
      ),
    ),
  );
}

void main() {
  group('OtpInputField', () {
    testWidgets('renders the expected number of text fields', (tester) async {
      await tester.pumpWidget(_buildApp(onCompleted: (_) {}));
      await tester.pump();

      expect(find.byType(TextField), findsNWidgets(6));
    });

    testWidgets('renders custom length of text fields', (tester) async {
      await tester.pumpWidget(_buildApp(onCompleted: (_) {}, length: 6));
      await tester.pump();

      expect(find.byType(TextField), findsNWidgets(6));
    });

    testWidgets('accepts digit input in a field', (tester) async {
      await tester.pumpWidget(_buildApp(onCompleted: (_) {}));
      await tester.pump();

      final firstField = find.byType(TextField).first;
      await tester.tap(firstField);
      await tester.enterText(firstField, '5');
      await tester.pump();

      final controller = tester.widget<TextField>(firstField).controller;
      expect(controller?.text, '5');
    });

    testWidgets('fires onChanged callback when text is entered', (
      tester,
    ) async {
      String? changedValue;
      await tester.pumpWidget(
        _buildApp(
          onCompleted: (_) {},
          onChanged: (value) => changedValue = value,
        ),
      );
      await tester.pump();

      final firstField = find.byType(TextField).first;
      await tester.tap(firstField);
      await tester.enterText(firstField, '3');
      await tester.pump();

      expect(changedValue, isNotNull);
    });

    testWidgets('fires onCompleted when all fields are filled', (tester) async {
      String? completedValue;
      const length = 4;
      await tester.pumpWidget(
        _buildApp(
          onCompleted: (value) => completedValue = value,
          length: length,
        ),
      );
      await tester.pump();

      for (var i = 0; i < length; i++) {
        final field = find.byType(TextField).at(i);
        await tester.tap(field);
        await tester.enterText(field, '${i + 1}');
        await tester.pump();
      }

      expect(completedValue, '1234');
    });

    testWidgets('contains a Row as top-level layout', (tester) async {
      await tester.pumpWidget(_buildApp(onCompleted: (_) {}));
      await tester.pump();

      expect(find.byType(Row), findsOneWidget);
    });
  });
}
