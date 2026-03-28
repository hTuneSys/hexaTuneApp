// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/storage/preferences_service.dart';
import 'package:hexatuneapp/src/core/workspace/harmonize_history_service.dart';
import 'package:hexatuneapp/src/core/workspace/models/harmonize_history_entry.dart';

class MockPreferencesService extends Mock implements PreferencesService {}

class MockLogService extends Mock implements LogService {}

HarmonizeHistoryEntry _makeEntry({
  String sourceType = 'Formula',
  String? formulaId = 'f1',
  String? formulaName = 'Test Formula',
  List<HistoryInventoryItem> inventories = const [],
  String generationType = 'Monaural',
  int? repeatCount = 1,
}) {
  return HarmonizeHistoryEntry(
    sourceType: sourceType,
    formulaId: formulaId,
    formulaName: formulaName,
    inventories: inventories,
    generationType: generationType,
    repeatCount: repeatCount,
    harmonizedAt: DateTime.now().toUtc().toIso8601String(),
  );
}

void main() {
  late MockPreferencesService mockPrefs;
  late MockLogService mockLog;
  late HarmonizeHistoryService service;

  setUp(() {
    mockPrefs = MockPreferencesService();
    mockLog = MockLogService();
    service = HarmonizeHistoryService(mockPrefs, mockLog);

    when(() => mockPrefs.getString(any())).thenReturn(null);
    when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
    when(
      () => mockLog.info(any(), category: any(named: 'category')),
    ).thenReturn(null);
    when(
      () => mockLog.error(
        any(),
        category: any(named: 'category'),
        exception: any(named: 'exception'),
        stackTrace: any(named: 'stackTrace'),
      ),
    ).thenReturn(null);
  });

  group('HarmonizeHistoryService', () {
    group('load', () {
      test('initializes empty when no stored data', () async {
        await service.load();
        expect(service.entries, isEmpty);
      });

      test('initializes empty when stored value is empty string', () async {
        when(
          () => mockPrefs.getString('workspace_harmonize_history'),
        ).thenReturn('');
        await service.load();
        expect(service.entries, isEmpty);
      });

      test('loads persisted entries', () async {
        final entries = [_makeEntry(), _makeEntry(formulaId: 'f2')];
        final jsonStr = json.encode(entries.map((e) => e.toJson()).toList());
        when(
          () => mockPrefs.getString('workspace_harmonize_history'),
        ).thenReturn(jsonStr);

        await service.load();
        expect(service.entries, hasLength(2));
        expect(service.entries[0].formulaId, 'f1');
        expect(service.entries[1].formulaId, 'f2');
      });

      test('handles corrupt JSON gracefully', () async {
        when(
          () => mockPrefs.getString('workspace_harmonize_history'),
        ).thenReturn('{not valid json');

        await service.load();
        expect(service.entries, isEmpty);
      });

      test('only reads from prefs once, preserving add() entries', () async {
        await service.load();
        await service.add(_makeEntry(formulaId: 'new'));

        // Second load should be a no-op — in-memory state is authoritative
        await service.load();
        expect(service.entries, hasLength(1));
        expect(service.entries[0].formulaId, 'new');
      });
    });

    group('add', () {
      test('inserts entry at front', () async {
        await service.add(_makeEntry(formulaId: 'first'));
        await service.add(_makeEntry(formulaId: 'second'));

        expect(service.entries, hasLength(2));
        expect(service.entries[0].formulaId, 'second');
        expect(service.entries[1].formulaId, 'first');
      });

      test('persists to preferences on add', () async {
        await service.add(_makeEntry());

        verify(
          () => mockPrefs.setString('workspace_harmonize_history', any()),
        ).called(1);
      });

      test('enforces max 20 entries', () async {
        for (var i = 0; i < 25; i++) {
          await service.add(_makeEntry(formulaId: 'f-$i'));
        }

        expect(service.entries, hasLength(20));
        expect(service.entries[0].formulaId, 'f-24');
        expect(service.entries[19].formulaId, 'f-5');
      });

      test('stores inventory source type', () async {
        final entry = _makeEntry(
          sourceType: 'Inventory',
          formulaId: null,
          formulaName: null,
          inventories: const [
            HistoryInventoryItem(id: 'i1', name: 'Inv 1'),
            HistoryInventoryItem(id: 'i2', name: 'Inv 2'),
          ],
        );
        await service.add(entry);

        expect(service.entries[0].sourceType, 'Inventory');
        expect(service.entries[0].inventories, hasLength(2));
      });

      test('stores null repeat count for infinite', () async {
        await service.add(_makeEntry(repeatCount: null));
        expect(service.entries[0].repeatCount, isNull);
      });
    });

    group('clear', () {
      test('removes all entries', () async {
        await service.add(_makeEntry());
        await service.add(_makeEntry());
        await service.clear();
        expect(service.entries, isEmpty);
      });

      test('persists empty list on clear', () async {
        await service.add(_makeEntry());
        reset(mockPrefs);
        when(
          () => mockPrefs.setString(any(), any()),
        ).thenAnswer((_) async => true);

        await service.clear();
        verify(
          () => mockPrefs.setString('workspace_harmonize_history', '[]'),
        ).called(1);
      });
    });

    test('entries list is unmodifiable', () {
      expect(
        () => service.entries.add(_makeEntry()),
        throwsA(isA<UnsupportedError>()),
      );
    });
  });
}
