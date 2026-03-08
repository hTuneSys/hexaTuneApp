// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/dsp/models/audio_asset.dart';

void main() {
  group('AudioAsset', () {
    test('can be created with all required fields', () {
      const asset = AudioAsset(
        id: 'forest_rain',
        layerType: 'base',
        name: 'forest_rain',
        assetPath: 'assets/audio/ambience/base/forest_rain.wav',
      );
      expect(asset.id, 'forest_rain');
      expect(asset.layerType, 'base');
      expect(asset.name, 'forest_rain');
      expect(asset.assetPath, 'assets/audio/ambience/base/forest_rain.wav');
      expect(asset.iconAsset, '');
      expect(asset.nameKey, '');
    });

    test('optional fields can be set', () {
      const asset = AudioAsset(
        id: 'forest',
        layerType: 'base',
        name: 'Forest',
        assetPath: 'assets/audio/ambience/base/forest.wav',
        iconAsset: 'assets/icons/ambience/base/forest.png',
        nameKey: 'ambienceBaseForest',
      );
      expect(asset.iconAsset, 'assets/icons/ambience/base/forest.png');
      expect(asset.nameKey, 'ambienceBaseForest');
    });

    test('equality works correctly', () {
      const a = AudioAsset(
        id: 'wind',
        layerType: 'texture',
        name: 'wind',
        assetPath: 'assets/audio/ambience/texture/wind.wav',
      );
      const b = AudioAsset(
        id: 'wind',
        layerType: 'texture',
        name: 'wind',
        assetPath: 'assets/audio/ambience/texture/wind.wav',
      );
      expect(a, equals(b));
    });

    test('inequality when fields differ', () {
      const a = AudioAsset(
        id: 'river',
        layerType: 'base',
        name: 'river',
        assetPath: 'assets/audio/ambience/base/river.wav',
      );
      const b = AudioAsset(
        id: 'ocean',
        layerType: 'base',
        name: 'ocean',
        assetPath: 'assets/audio/ambience/base/ocean.wav',
      );
      expect(a, isNot(equals(b)));
    });

    test('different layer types are not equal', () {
      const a = AudioAsset(
        id: 'rain',
        layerType: 'base',
        name: 'rain',
        assetPath: 'assets/audio/ambience/base/rain.wav',
      );
      const b = AudioAsset(
        id: 'rain',
        layerType: 'texture',
        name: 'rain',
        assetPath: 'assets/audio/ambience/texture/rain.wav',
      );
      expect(a, isNot(equals(b)));
    });

    test('copyWith creates modified copy', () {
      const original = AudioAsset(
        id: 'bird',
        layerType: 'events',
        name: 'bird',
        assetPath: 'assets/audio/ambience/events/bird.wav',
      );
      final modified = original.copyWith(name: 'cricket');
      expect(modified.name, 'cricket');
      expect(modified.id, 'bird');
      expect(modified.layerType, 'events');
      expect(modified.assetPath, 'assets/audio/ambience/events/bird.wav');
    });

    test('toString produces readable output', () {
      const asset = AudioAsset(
        id: 'rain',
        layerType: 'base',
        name: 'rain',
        assetPath: 'assets/audio/ambience/base/rain.wav',
      );
      final str = asset.toString();
      expect(str, contains('AudioAsset'));
      expect(str, contains('rain'));
    });

    test('hashCode consistent with equality', () {
      const a = AudioAsset(
        id: 'rain',
        layerType: 'base',
        name: 'rain',
        assetPath: 'assets/audio/ambience/base/rain.wav',
      );
      const b = AudioAsset(
        id: 'rain',
        layerType: 'base',
        name: 'rain',
        assetPath: 'assets/audio/ambience/base/rain.wav',
      );
      expect(a.hashCode, equals(b.hashCode));
    });

    test('handles paths with special characters', () {
      const asset = AudioAsset(
        id: 'bird1',
        layerType: 'events',
        name: 'bird#1',
        assetPath: 'assets/audio/ambience/events/bird#1.wav',
      );
      expect(asset.assetPath, contains('#'));
    });
  });
}
