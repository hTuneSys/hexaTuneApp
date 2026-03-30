// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/log/debug_log_buffer.dart';
import 'package:hexatuneapp/src/pages/debug/log_monitor_page.dart';

Widget _buildApp() {
  return const MaterialApp(home: LogMonitorPage());
}

void main() {
  setUp(() {
    DebugLogBuffer.instance.clear();
  });

  tearDown(() {
    DebugLogBuffer.instance.clear();
  });

  group('LogMonitorPage', () {
    testWidgets('shows appbar title with count', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Log Monitor (0)'), findsOneWidget);
    });

    testWidgets('shows empty state when no logs', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('No log entries yet'), findsOneWidget);
    });

    testWidgets('shows action buttons', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.copy), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('displays log entries', (tester) async {
      DebugLogBuffer.instance.add('INFO', 'Test message one');
      DebugLogBuffer.instance.add('ERROR', 'Test error msg');

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Log Monitor (2)'), findsOneWidget);
      expect(find.textContaining('Test message one'), findsOneWidget);
      expect(find.textContaining('Test error msg'), findsOneWidget);
    });

    testWidgets('displays level badges in entries', (tester) async {
      DebugLogBuffer.instance.add('INFO', 'Hello world');

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('[INFO]'), findsOneWidget);
    });

    testWidgets('clear button removes all entries', (tester) async {
      DebugLogBuffer.instance.add('INFO', 'Will be cleared');

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('Will be cleared'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      expect(find.text('No log entries yet'), findsOneWidget);
      expect(find.text('Log Monitor (0)'), findsOneWidget);
    });

    testWidgets('search filters entries', (tester) async {
      DebugLogBuffer.instance.add('INFO', 'Alpha message');
      DebugLogBuffer.instance.add('ERROR', 'Beta error');

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('Alpha message'), findsOneWidget);
      expect(find.textContaining('Beta error'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Beta');
      await tester.pumpAndSettle();

      expect(find.textContaining('Alpha message'), findsNothing);
      // Beta error still in the log entry (search field also has "Beta")
      expect(find.textContaining('Beta error'), findsOneWidget);
    });

    testWidgets('level filter shows matching entries only', (tester) async {
      DebugLogBuffer.instance.add('INFO', 'Info log');
      DebugLogBuffer.instance.add('ERROR', 'Error log');
      DebugLogBuffer.instance.add('DEBUG', 'Debug log');

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // All entries visible
      expect(find.textContaining('Info log'), findsOneWidget);
      expect(find.textContaining('Error log'), findsOneWidget);
      expect(find.textContaining('Debug log'), findsOneWidget);

      // Open dropdown and select ERROR
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('ERROR').last);
      await tester.pumpAndSettle();

      expect(find.textContaining('Error log'), findsOneWidget);
      expect(find.textContaining('Info log'), findsNothing);
      expect(find.textContaining('Debug log'), findsNothing);
    });

    testWidgets('copy all copies entries to clipboard', (tester) async {
      DebugLogBuffer.instance.add('INFO', 'Copyable message');

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('Copyable message'), findsOneWidget);

      // Tap copy — clipboard is async via platform channel so we verify
      // the DebugLogBuffer.toClipboardText() content instead.
      expect(
        DebugLogBuffer.instance.toClipboardText(),
        contains('Copyable message'),
      );

      await tester.tap(find.byIcon(Icons.copy));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Entries remain after copy (not cleared)
      expect(find.textContaining('Copyable message'), findsOneWidget);
    });

    testWidgets('copy all with empty logs shows message', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.copy));
      await tester.pumpAndSettle();

      expect(find.text('No log entries to copy'), findsOneWidget);
    });

    testWidgets('auto-scroll toggle changes icon', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Initially auto-scroll is ON
      expect(find.byIcon(Icons.vertical_align_bottom), findsOneWidget);

      await tester.tap(find.byIcon(Icons.vertical_align_bottom));
      await tester.pumpAndSettle();

      // Now paused
      expect(find.byIcon(Icons.pause), findsOneWidget);
    });

    testWidgets('new entries appear via stream', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Log Monitor (0)'), findsOneWidget);

      DebugLogBuffer.instance.add('INFO', 'Late arrival');
      await tester.pumpAndSettle();

      expect(find.text('Log Monitor (1)'), findsOneWidget);
      expect(find.textContaining('Late arrival'), findsOneWidget);
    });

    testWidgets('HTTP entries display correctly', (tester) async {
      DebugLogBuffer.instance.add(
        'HTTP-REQ',
        '→ POST https://api.example.com/inventory\n'
            '  Headers: {Authorization: Bearer ***}\n'
            '  Body: [FormData] fields=2, files=1',
      );
      DebugLogBuffer.instance.add(
        'HTTP-RES',
        '← 201 POST https://api.example.com/inventory\n'
            '  Body: {"id": "inv-001"}',
      );

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('[HTTP-REQ]'), findsOneWidget);
      expect(find.textContaining('[HTTP-RES]'), findsOneWidget);
      expect(find.textContaining('POST'), findsNWidgets(2));
    });
  });
}
