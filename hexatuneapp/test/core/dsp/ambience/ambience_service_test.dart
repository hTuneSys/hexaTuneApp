// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hexatuneapp/src/core/dsp/ambience/ambience_service.dart';
import 'package:hexatuneapp/src/core/dsp/ambience/models/ambience_config.dart';
import 'package:hexatuneapp/src/core/dsp/dsp_constants.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/storage/preferences_service.dart';

class MockPreferencesService extends Mock implements PreferencesService {}

class MockLogService extends Mock implements LogService {}

void main() {
  late MockPreferencesService mockPrefs;
  late MockLogService mockLog;
  late AmbienceService service;

  setUp(() {
    mockPrefs = MockPreferencesService();
    mockLog = MockLogService();
    service = AmbienceService(mockPrefs, mockLog);

    // Default stubs
    when(() => mockPrefs.getString(any())).thenReturn(null);
    when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
  });

  group('AmbienceService', () {
    group('load', () {
      test('loads empty list when no data', () async {
        await service.load();
        expect(service.configs, isEmpty);
      });

      test('loads empty list when empty string', () async {
        when(() => mockPrefs.getString('ambience_configs')).thenReturn('');
        await service.load();
        expect(service.configs, isEmpty);
      });

      test('loads configs from stored JSON', () async {
        final now = DateTime.now().toUtc().toIso8601String();
        final json =
            '[{"id":"a","name":"Test","baseAssetId":null,'
            '"textureAssetIds":[],"eventAssetIds":[],'
            '"baseGain":0.6,"textureGain":0.3,"eventGain":0.4,'
            '"masterGain":1.0,"createdAt":"$now","updatedAt":"$now"}]';
        when(() => mockPrefs.getString('ambience_configs')).thenReturn(json);

        await service.load();
        expect(service.configs, hasLength(1));
        expect(service.configs.first.id, 'a');
        expect(service.configs.first.name, 'Test');
      });

      test('handles corrupt JSON gracefully', () async {
        when(
          () => mockPrefs.getString('ambience_configs'),
        ).thenReturn('not json');
        await service.load();
        expect(service.configs, isEmpty);
      });
    });

    group('create', () {
      test('creates config with defaults', () async {
        final config = await service.create(name: 'Forest Night');

        expect(config.name, 'Forest Night');
        expect(config.id, isNotEmpty);
        expect(config.baseAssetId, isNull);
        expect(config.textureAssetIds, isEmpty);
        expect(config.eventAssetIds, isEmpty);
        expect(config.baseGain, DspConstants.defaultBaseGain);
        expect(config.textureGain, DspConstants.defaultTextureGain);
        expect(config.eventGain, DspConstants.defaultEventGain);
        expect(config.masterGain, DspConstants.defaultMasterGain);
        expect(config.createdAt, isNotEmpty);
        expect(config.updatedAt, isNotEmpty);

        expect(service.configs, hasLength(1));
        verify(() => mockPrefs.setString('ambience_configs', any())).called(1);
      });

      test('creates config with all fields', () async {
        final config = await service.create(
          name: 'Full Preset',
          baseAssetId: 'forest',
          textureAssetIds: ['wave', 'wind_through_trees'],
          eventAssetIds: ['bird', 'thunder'],
          baseGain: 0.8,
          textureGain: 0.5,
          eventGain: 0.6,
          masterGain: 0.95,
        );

        expect(config.baseAssetId, 'forest');
        expect(config.textureAssetIds, ['wave', 'wind_through_trees']);
        expect(config.eventAssetIds, ['bird', 'thunder']);
        expect(config.baseGain, 0.8);
      });

      test('trims whitespace from name', () async {
        final config = await service.create(name: '  Padded Name  ');
        expect(config.name, 'Padded Name');
      });

      test('clamps gains to 0.0-1.0', () async {
        final config = await service.create(
          name: 'Clamped',
          baseGain: 1.5,
          textureGain: -0.3,
          masterGain: 2.0,
        );
        expect(config.baseGain, 1.0);
        expect(config.textureGain, 0.0);
        expect(config.masterGain, 1.0);
      });

      test('throws on empty name', () async {
        expect(() => service.create(name: ''), throwsA(isA<ArgumentError>()));
        expect(
          () => service.create(name: '   '),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws when textures exceed max', () async {
        expect(
          () => service.create(
            name: 'Too Many',
            textureAssetIds: List.generate(
              DspConstants.maxTextureLayers + 1,
              (i) => 'tex$i',
            ),
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws when events exceed max', () async {
        expect(
          () => service.create(
            name: 'Too Many',
            eventAssetIds: List.generate(
              DspConstants.maxEventSlots + 1,
              (i) => 'evt$i',
            ),
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('multiple configs are sorted by updatedAt descending', () async {
        await service.create(name: 'First');
        await Future<void>.delayed(const Duration(milliseconds: 10));
        await service.create(name: 'Second');

        expect(service.configs.first.name, 'Second');
        expect(service.configs.last.name, 'First');
      });
    });

    group('findById', () {
      test('returns config when found', () async {
        final config = await service.create(name: 'Find Me');
        final found = service.findById(config.id);
        expect(found, equals(config));
      });

      test('returns null when not found', () {
        expect(service.findById('nonexistent'), isNull);
      });
    });

    group('update', () {
      test('updates name only', () async {
        final config = await service.create(
          name: 'Original',
          baseAssetId: 'forest',
        );

        final updated = await service.update(config.id, name: 'Renamed');
        expect(updated.name, 'Renamed');
        expect(updated.baseAssetId, 'forest');
        expect(updated.id, config.id);
      });

      test('updates layers', () async {
        final config = await service.create(name: 'Layers');

        final updated = await service.update(
          config.id,
          baseAssetId: 'ocean',
          textureAssetIds: ['wave'],
          eventAssetIds: ['bird', 'cat'],
        );
        expect(updated.baseAssetId, 'ocean');
        expect(updated.textureAssetIds, ['wave']);
        expect(updated.eventAssetIds, ['bird', 'cat']);
      });

      test('clears base with clearBase flag', () async {
        final config = await service.create(
          name: 'Base Test',
          baseAssetId: 'forest',
        );

        final updated = await service.update(config.id, clearBase: true);
        expect(updated.baseAssetId, isNull);
      });

      test('updates gains', () async {
        final config = await service.create(name: 'Gains');

        final updated = await service.update(
          config.id,
          baseGain: 0.9,
          masterGain: 0.5,
        );
        expect(updated.baseGain, 0.9);
        expect(updated.masterGain, 0.5);
        expect(updated.textureGain, DspConstants.defaultTextureGain);
      });

      test('updatedAt changes on update', () async {
        final config = await service.create(name: 'Timestamp');
        await Future<void>.delayed(const Duration(milliseconds: 10));
        final updated = await service.update(config.id, name: 'Updated');
        expect(updated.updatedAt, isNot(equals(config.updatedAt)));
      });

      test('throws on nonexistent id', () async {
        expect(
          () => service.update('nonexistent', name: 'X'),
          throwsA(isA<StateError>()),
        );
      });

      test('throws on empty name', () async {
        final config = await service.create(name: 'Valid');
        expect(
          () => service.update(config.id, name: ''),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws on too many textures', () async {
        final config = await service.create(name: 'Layers');
        expect(
          () => service.update(
            config.id,
            textureAssetIds: List.generate(
              DspConstants.maxTextureLayers + 1,
              (i) => 'tex$i',
            ),
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('persists after update', () async {
        final config = await service.create(name: 'Persist');
        await service.update(config.id, name: 'New Name');

        // 1 for create, 1 for update
        verify(() => mockPrefs.setString('ambience_configs', any())).called(2);
      });
    });

    group('delete', () {
      test('removes existing config', () async {
        final config = await service.create(name: 'Delete Me');
        expect(service.configs, hasLength(1));

        final result = await service.delete(config.id);
        expect(result, isTrue);
        expect(service.configs, isEmpty);
      });

      test('returns false for nonexistent id', () async {
        final result = await service.delete('nonexistent');
        expect(result, isFalse);
      });

      test('persists after delete', () async {
        final config = await service.create(name: 'Delete Me');
        await service.delete(config.id);

        // 1 for create, 1 for delete
        verify(() => mockPrefs.setString('ambience_configs', any())).called(2);
      });
    });

    group('clearAll', () {
      test('removes all configs', () async {
        await service.create(name: 'A');
        await service.create(name: 'B');
        expect(service.configs, hasLength(2));

        await service.clearAll();
        expect(service.configs, isEmpty);
      });
    });

    group('configs immutability', () {
      test('returned list is unmodifiable', () async {
        await service.create(name: 'Test');
        expect(
          () => service.configs.add(
            AmbienceConfig(id: 'x', name: 'X', createdAt: '', updatedAt: ''),
          ),
          throwsA(isA<UnsupportedError>()),
        );
      });
    });
  });
}
