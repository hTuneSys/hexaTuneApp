// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/log/debug_log_buffer.dart';

void main() {
  group('DebugLogBuffer', () {
    late DebugLogBuffer buffer;

    setUp(() {
      buffer = DebugLogBuffer.instance;
      buffer.clear();
    });

    test('instance returns the same singleton', () {
      final a = DebugLogBuffer.instance;
      final b = DebugLogBuffer.instance;
      expect(identical(a, b), isTrue);
    });

    test('starts empty after clear', () {
      expect(buffer.entries, isEmpty);
      expect(buffer.length, 0);
    });

    test('add() stores entries in order', () {
      buffer.add('INFO', 'first');
      buffer.add('DEBUG', 'second');

      expect(buffer.length, 2);
      expect(buffer.entries[0].level, 'INFO');
      expect(buffer.entries[0].message, 'first');
      expect(buffer.entries[1].level, 'DEBUG');
      expect(buffer.entries[1].message, 'second');
    });

    test('entries list is unmodifiable', () {
      buffer.add('INFO', 'test');
      expect(
        () => buffer.entries.add(
          DebugLogEntry(timestamp: DateTime.now(), level: 'X', message: 'x'),
        ),
        throwsUnsupportedError,
      );
    });

    test('clear() removes all entries', () {
      buffer.add('INFO', 'a');
      buffer.add('DEBUG', 'b');
      expect(buffer.length, 2);

      buffer.clear();
      expect(buffer.entries, isEmpty);
      expect(buffer.length, 0);
    });

    test('stream emits new entries as they are added', () async {
      final completer = Completer<DebugLogEntry>();
      final sub = buffer.stream.listen(completer.complete);

      buffer.add('WARN', 'streamed');

      final entry = await completer.future;
      expect(entry.level, 'WARN');
      expect(entry.message, 'streamed');
      await sub.cancel();
    });

    test('stream is broadcast and supports multiple listeners', () async {
      final entries1 = <DebugLogEntry>[];
      final entries2 = <DebugLogEntry>[];
      final sub1 = buffer.stream.listen(entries1.add);
      final sub2 = buffer.stream.listen(entries2.add);

      buffer.add('INFO', 'broadcast');

      await Future<void>.delayed(Duration.zero);
      expect(entries1, hasLength(1));
      expect(entries2, hasLength(1));
      await sub1.cancel();
      await sub2.cancel();
    });

    test('toClipboardText() returns empty string when no entries', () {
      expect(buffer.toClipboardText(), '');
    });

    test('toClipboardText() formats entries with formatted output', () {
      buffer.add('INFO', 'hello');
      buffer.add('ERROR', 'world');

      final text = buffer.toClipboardText();
      final lines = text.split('\n');
      expect(lines, hasLength(2));
      expect(lines[0], contains('[INFO]'));
      expect(lines[0], contains('hello'));
      expect(lines[1], contains('[ERROR]'));
      expect(lines[1], contains('world'));
    });
  });

  group('DebugLogEntry', () {
    test('formatted contains timestamp, level, and message', () {
      final entry = DebugLogEntry(
        timestamp: DateTime(2025, 1, 15, 10, 30, 45, 123),
        level: 'DEBUG',
        message: 'test message',
      );

      final formatted = entry.formatted;
      expect(formatted, contains('[10:30:45.123]'));
      expect(formatted, contains('[DEBUG]'));
      expect(formatted, contains('test message'));
    });
  });
}
