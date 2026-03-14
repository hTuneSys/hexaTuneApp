// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/dsp/dsp_asset_service.dart';

void main() {
  group('DspAssetService', () {
    group('fileNameToDisplayName', () {
      test('removes .wav extension', () {
        expect(
          DspAssetService.fileNameToDisplayName('forest_rain.wav'),
          'Forest Rain',
        );
      });

      test('removes .m4a extension', () {
        expect(
          DspAssetService.fileNameToDisplayName('ocean_waves.m4a'),
          'Ocean Waves',
        );
      });

      test('removes .mp3 extension', () {
        expect(
          DspAssetService.fileNameToDisplayName('bird_song.mp3'),
          'Bird Song',
        );
      });

      test('removes .ogg extension', () {
        expect(
          DspAssetService.fileNameToDisplayName('wind_chime.ogg'),
          'Wind Chime',
        );
      });

      test('replaces underscores with spaces', () {
        expect(
          DspAssetService.fileNameToDisplayName('deep_forest_rain.wav'),
          'Deep Forest Rain',
        );
      });

      test('replaces hyphens with spaces', () {
        expect(
          DspAssetService.fileNameToDisplayName('deep-forest-rain.wav'),
          'Deep Forest Rain',
        );
      });

      test('capitalizes each word', () {
        expect(
          DspAssetService.fileNameToDisplayName('soft_gentle_breeze.wav'),
          'Soft Gentle Breeze',
        );
      });

      test('removes trailing timestamp', () {
        expect(
          DspAssetService.fileNameToDisplayName('rain_1234567890.wav'),
          'Rain',
        );
      });

      test('handles mixed separators', () {
        expect(
          DspAssetService.fileNameToDisplayName('deep_forest-rain.wav'),
          'Deep Forest Rain',
        );
      });

      test('handles single word', () {
        expect(DspAssetService.fileNameToDisplayName('rain.wav'), 'Rain');
      });

      test('handles case-insensitive extension', () {
        expect(DspAssetService.fileNameToDisplayName('RAIN.WAV'), 'RAIN');
      });

      test('collapses multiple spaces', () {
        expect(
          DspAssetService.fileNameToDisplayName('rain__forest.wav'),
          'Rain Forest',
        );
      });

      test('handles path with subdirectory', () {
        expect(
          DspAssetService.fileNameToDisplayName('sub/rain_forest.wav'),
          'Sub/rain Forest',
        );
      });

      test('returns empty string for just extension', () {
        expect(DspAssetService.fileNameToDisplayName('.wav'), '');
      });
    });
  });
}
