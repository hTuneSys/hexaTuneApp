// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/dsp/ambience/models/ambience_config.dart';

void main() {
  group('AmbienceConfig', () {
    final now = DateTime.now().toUtc().toIso8601String();

    test('can be created with required fields only', () {
      final config = AmbienceConfig(
        id: 'abc-123',
        name: 'My Forest',
        createdAt: now,
        updatedAt: now,
      );
      expect(config.id, 'abc-123');
      expect(config.name, 'My Forest');
      expect(config.baseAssetId, isNull);
      expect(config.textureAssetIds, isEmpty);
      expect(config.eventAssetIds, isEmpty);
      expect(config.baseGain, 0.6);
      expect(config.textureGain, 0.3);
      expect(config.eventGain, 0.4);
      expect(config.masterGain, 1.0);
    });

    test('can be created with all fields', () {
      final config = AmbienceConfig(
        id: 'abc-123',
        name: 'Full Preset',
        baseAssetId: 'forest',
        textureAssetIds: ['wave', 'wind_through_trees'],
        eventAssetIds: ['bird', 'thunder'],
        baseGain: 0.8,
        textureGain: 0.5,
        eventGain: 0.6,
        masterGain: 0.9,
        createdAt: now,
        updatedAt: now,
      );
      expect(config.baseAssetId, 'forest');
      expect(config.textureAssetIds, ['wave', 'wind_through_trees']);
      expect(config.eventAssetIds, ['bird', 'thunder']);
      expect(config.baseGain, 0.8);
      expect(config.masterGain, 0.9);
    });

    test('equality works correctly', () {
      final a = AmbienceConfig(
        id: 'x',
        name: 'A',
        createdAt: now,
        updatedAt: now,
      );
      final b = AmbienceConfig(
        id: 'x',
        name: 'A',
        createdAt: now,
        updatedAt: now,
      );
      expect(a, equals(b));
    });

    test('inequality when fields differ', () {
      final a = AmbienceConfig(
        id: 'x',
        name: 'A',
        createdAt: now,
        updatedAt: now,
      );
      final b = AmbienceConfig(
        id: 'y',
        name: 'B',
        createdAt: now,
        updatedAt: now,
      );
      expect(a, isNot(equals(b)));
    });

    test('copyWith updates selected fields', () {
      final original = AmbienceConfig(
        id: 'x',
        name: 'Original',
        baseAssetId: 'forest',
        createdAt: now,
        updatedAt: now,
      );
      final modified = original.copyWith(name: 'Modified', baseGain: 0.9);
      expect(modified.name, 'Modified');
      expect(modified.baseGain, 0.9);
      expect(modified.baseAssetId, 'forest');
      expect(modified.id, 'x');
    });

    test('serializes to JSON and back', () {
      final config = AmbienceConfig(
        id: 'abc-123',
        name: 'Forest Night',
        baseAssetId: 'forest',
        textureAssetIds: ['wave'],
        eventAssetIds: ['bird', 'cat'],
        baseGain: 0.7,
        textureGain: 0.4,
        eventGain: 0.5,
        masterGain: 0.95,
        createdAt: now,
        updatedAt: now,
      );
      final json = config.toJson();
      final restored = AmbienceConfig.fromJson(json);
      expect(restored, equals(config));
    });

    test('JSON contains expected keys', () {
      final config = AmbienceConfig(
        id: 'x',
        name: 'Test',
        createdAt: now,
        updatedAt: now,
      );
      final json = config.toJson();
      expect(json.containsKey('id'), isTrue);
      expect(json.containsKey('name'), isTrue);
      expect(json.containsKey('baseAssetId'), isTrue);
      expect(json.containsKey('textureAssetIds'), isTrue);
      expect(json.containsKey('eventAssetIds'), isTrue);
      expect(json.containsKey('baseGain'), isTrue);
      expect(json.containsKey('textureGain'), isTrue);
      expect(json.containsKey('eventGain'), isTrue);
      expect(json.containsKey('masterGain'), isTrue);
      expect(json.containsKey('createdAt'), isTrue);
      expect(json.containsKey('updatedAt'), isTrue);
    });

    test('toString produces readable output', () {
      final config = AmbienceConfig(
        id: 'x',
        name: 'My Ambience',
        createdAt: now,
        updatedAt: now,
      );
      final str = config.toString();
      expect(str, contains('AmbienceConfig'));
      expect(str, contains('My Ambience'));
    });

    test('hashCode consistent with equality', () {
      final a = AmbienceConfig(
        id: 'x',
        name: 'A',
        createdAt: now,
        updatedAt: now,
      );
      final b = AmbienceConfig(
        id: 'x',
        name: 'A',
        createdAt: now,
        updatedAt: now,
      );
      expect(a.hashCode, equals(b.hashCode));
    });
  });
}
