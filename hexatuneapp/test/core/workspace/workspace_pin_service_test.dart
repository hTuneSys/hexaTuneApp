// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/storage/preferences_service.dart';
import 'package:hexatuneapp/src/core/workspace/workspace_pin_service.dart';

class MockPreferencesService extends Mock implements PreferencesService {}

class MockLogService extends Mock implements LogService {}

void main() {
  late MockPreferencesService mockPrefs;
  late MockLogService mockLog;
  late WorkspacePinService service;

  setUp(() {
    mockPrefs = MockPreferencesService();
    mockLog = MockLogService();
    service = WorkspacePinService(mockPrefs, mockLog);

    when(() => mockPrefs.getString(any())).thenReturn(null);
    when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
  });

  group('WorkspacePinService', () {
    group('load', () {
      test('loads empty list when no data', () async {
        await service.load();
        expect(service.pins, isEmpty);
      });

      test('loads empty list when empty string', () async {
        when(
          () => mockPrefs.getString('workspace_pinned_formulas'),
        ).thenReturn('');
        await service.load();
        expect(service.pins, isEmpty);
      });

      test('loads pins from stored JSON', () async {
        const json = '[{"id":"f1","name":"Alpha"},{"id":"f2","name":"Beta"}]';
        when(
          () => mockPrefs.getString('workspace_pinned_formulas'),
        ).thenReturn(json);

        await service.load();
        expect(service.pins, hasLength(2));
        expect(service.pins.first.id, 'f1');
        expect(service.pins.first.name, 'Alpha');
        expect(service.pins.last.id, 'f2');
        expect(service.pins.last.name, 'Beta');
      });

      test('handles corrupt JSON gracefully', () async {
        when(
          () => mockPrefs.getString('workspace_pinned_formulas'),
        ).thenReturn('not json');
        await service.load();
        expect(service.pins, isEmpty);
      });
    });

    group('pin', () {
      test('adds formula and persists', () async {
        await service.pin('f1', 'Formula A');

        expect(service.pins, hasLength(1));
        expect(service.pins.first.id, 'f1');
        expect(service.pins.first.name, 'Formula A');
        verify(
          () => mockPrefs.setString('workspace_pinned_formulas', any()),
        ).called(1);
      });

      test('does not add duplicate', () async {
        await service.pin('f1', 'Formula A');
        await service.pin('f1', 'Formula A');

        expect(service.pins, hasLength(1));
        verify(
          () => mockPrefs.setString('workspace_pinned_formulas', any()),
        ).called(1);
      });

      test('pins multiple different formulas', () async {
        await service.pin('f1', 'Formula A');
        await service.pin('f2', 'Formula B');
        await service.pin('f3', 'Formula C');

        expect(service.pins, hasLength(3));
      });
    });

    group('unpin', () {
      test('removes existing pin and persists', () async {
        await service.pin('f1', 'Formula A');
        await service.pin('f2', 'Formula B');

        await service.unpin('f1');

        expect(service.pins, hasLength(1));
        expect(service.pins.first.id, 'f2');
      });

      test('no-op for nonexistent id', () async {
        await service.pin('f1', 'Formula A');
        await service.unpin('nonexistent');

        expect(service.pins, hasLength(1));
        // Only 1 call from pin, not from unpin
        verify(
          () => mockPrefs.setString('workspace_pinned_formulas', any()),
        ).called(1);
      });
    });

    group('isPinned', () {
      test('returns true for pinned formula', () async {
        await service.pin('f1', 'Formula A');
        expect(service.isPinned('f1'), isTrue);
      });

      test('returns false for non-pinned formula', () {
        expect(service.isPinned('f1'), isFalse);
      });

      test('returns false after unpin', () async {
        await service.pin('f1', 'Formula A');
        await service.unpin('f1');
        expect(service.isPinned('f1'), isFalse);
      });
    });

    group('pins immutability', () {
      test('returned list is unmodifiable', () async {
        await service.pin('f1', 'Formula A');
        expect(
          () => service.pins.removeAt(0),
          throwsA(isA<UnsupportedError>()),
        );
      });
    });
  });
}
