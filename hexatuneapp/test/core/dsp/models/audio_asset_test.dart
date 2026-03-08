// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/dsp/models/audio_asset.dart';

void main() {
  group('AudioAsset', () {
    test('can be created with all required fields', () {
      const asset = AudioAsset(
        layerType: 'base',
        name: 'forest_rain',
        assetPath: 'assets/audio/ambience/base/forest_rain.wav',
      );
      expect(asset.layerType, 'base');
      expect(asset.name, 'forest_rain');
      expect(asset.assetPath, 'assets/audio/ambience/base/forest_rain.wav');
    });

    test('equality works correctly', () {
      const a = AudioAsset(
        layerType: 'texture',
        name: 'wind',
        assetPath: 'assets/audio/ambience/texture/wind.wav',
      );
      const b = AudioAsset(
        layerType: 'texture',
        name: 'wind',
        assetPath: 'assets/audio/ambience/texture/wind.wav',
      );
      expect(a, equals(b));
    });

    test('inequality when fields differ', () {
      const a = AudioAsset(
        layerType: 'base',
        name: 'river',
        assetPath: 'assets/audio/ambience/base/river.wav',
      );
      const b = AudioAsset(
        layerType: 'base',
        name: 'ocean',
        assetPath: 'assets/audio/ambience/base/ocean.wav',
      );
      expect(a, isNot(equals(b)));
    });

    test('different layer types are not equal', () {
      const a = AudioAsset(
        layerType: 'base',
        name: 'rain',
        assetPath: 'assets/audio/ambience/base/rain.wav',
      );
      const b = AudioAsset(
        layerType: 'texture',
        name: 'rain',
        assetPath: 'assets/audio/ambience/texture/rain.wav',
      );
      expect(a, isNot(equals(b)));
    });

    test('copyWith creates modified copy', () {
      const original = AudioAsset(
        layerType: 'events',
        name: 'bird',
        assetPath: 'assets/audio/ambience/events/bird.wav',
      );
      final modified = original.copyWith(name: 'cricket');
      expect(modified.name, 'cricket');
      expect(modified.layerType, 'events');
      expect(modified.assetPath, 'assets/audio/ambience/events/bird.wav');
    });

    test('toString produces readable output', () {
      const asset = AudioAsset(
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
        layerType: 'base',
        name: 'rain',
        assetPath: 'assets/audio/ambience/base/rain.wav',
      );
      const b = AudioAsset(
        layerType: 'base',
        name: 'rain',
        assetPath: 'assets/audio/ambience/base/rain.wav',
      );
      expect(a.hashCode, equals(b.hashCode));
    });

    test('handles paths with special characters', () {
      const asset = AudioAsset(
        layerType: 'events',
        name: 'bird#1',
        assetPath: 'assets/audio/ambience/events/bird#1.wav',
      );
      expect(asset.assetPath, contains('#'));
    });
  });
}
