// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/dsp/dsp_constants.dart';

void main() {
  group('DspConstants', () {
    group('layer limits', () {
      test('maxTextureLayers is 3', () {
        expect(DspConstants.maxTextureLayers, 3);
      });

      test('maxEventSlots is 5', () {
        expect(DspConstants.maxEventSlots, 5);
      });

      test('layer limits are positive', () {
        expect(DspConstants.maxTextureLayers, greaterThan(0));
        expect(DspConstants.maxEventSlots, greaterThan(0));
      });
    });

    group('default gain values', () {
      test('defaultBaseGain is 0.6', () {
        expect(DspConstants.defaultBaseGain, 0.6);
      });

      test('defaultTextureGain is 0.3', () {
        expect(DspConstants.defaultTextureGain, 0.3);
      });

      test('defaultEventGain is 0.4', () {
        expect(DspConstants.defaultEventGain, 0.4);
      });

      test('defaultBinauralGain is 0.15', () {
        expect(DspConstants.defaultBinauralGain, 0.15);
      });

      test('defaultMasterGain is 1.0', () {
        expect(DspConstants.defaultMasterGain, 1.0);
      });

      test('all gains are in valid range 0.0-1.0', () {
        final gains = [
          DspConstants.defaultBaseGain,
          DspConstants.defaultTextureGain,
          DspConstants.defaultEventGain,
          DspConstants.defaultBinauralGain,
          DspConstants.defaultMasterGain,
        ];
        for (final gain in gains) {
          expect(gain, greaterThanOrEqualTo(0.0));
          expect(gain, lessThanOrEqualTo(1.0));
        }
      });
    });

    group('audio configuration', () {
      test('sampleRate is 48 kHz', () {
        expect(DspConstants.sampleRate, 48000.0);
      });

      test('bufferSize is 1024 frames', () {
        expect(DspConstants.bufferSize, 1024);
      });

      test('stereoChannels is 2', () {
        expect(DspConstants.stereoChannels, 2);
      });

      test('defaultCrossfadeFrames is 2048', () {
        expect(DspConstants.defaultCrossfadeFrames, 2048);
      });

      test('crossfade duration is approximately 42ms at 48kHz', () {
        final crossfadeMs =
            DspConstants.defaultCrossfadeFrames /
            DspConstants.sampleRate *
            1000;
        expect(crossfadeMs, closeTo(42.67, 0.1));
      });
    });

    group('binaural configuration', () {
      test('carrierFrequency is 220 Hz', () {
        expect(DspConstants.carrierFrequency, 220.0);
      });

      test('defaultFrequencyDelta is 5 Hz', () {
        expect(DspConstants.defaultFrequencyDelta, 5.0);
      });

      test('defaultCycleDuration is 30 seconds', () {
        expect(DspConstants.defaultCycleDuration, 30.0);
      });
    });

    group('event timing defaults', () {
      test('defaultEventMinIntervalMs is 3000', () {
        expect(DspConstants.defaultEventMinIntervalMs, 3000);
      });

      test('defaultEventMaxIntervalMs is 8000', () {
        expect(DspConstants.defaultEventMaxIntervalMs, 8000);
      });

      test('min interval is less than max interval', () {
        expect(
          DspConstants.defaultEventMinIntervalMs,
          lessThan(DspConstants.defaultEventMaxIntervalMs),
        );
      });

      test('event volume defaults are valid', () {
        expect(DspConstants.defaultEventVolumeMin, greaterThanOrEqualTo(0.0));
        expect(DspConstants.defaultEventVolumeMax, lessThanOrEqualTo(1.0));
        expect(
          DspConstants.defaultEventVolumeMin,
          lessThan(DspConstants.defaultEventVolumeMax),
        );
      });

      test('event pan defaults are symmetric', () {
        expect(DspConstants.defaultEventPanMin, -0.5);
        expect(DspConstants.defaultEventPanMax, 0.5);
        expect(
          DspConstants.defaultEventPanMin,
          equals(-DspConstants.defaultEventPanMax),
        );
      });
    });

    group('asset discovery', () {
      test('audioAssetRoot is correct path', () {
        expect(DspConstants.audioAssetRoot, 'assets/audio/ambience');
      });

      test('supportedExtensions contains expected formats', () {
        expect(DspConstants.supportedExtensions, contains('.wav'));
        expect(DspConstants.supportedExtensions, contains('.m4a'));
        expect(DspConstants.supportedExtensions, contains('.mp3'));
        expect(DspConstants.supportedExtensions, contains('.ogg'));
      });

      test('supportedExtensions all start with dot', () {
        for (final ext in DspConstants.supportedExtensions) {
          expect(ext, startsWith('.'));
        }
      });
    });

    group('method channel', () {
      test('methodChannelName is correct', () {
        expect(DspConstants.methodChannelName, 'com.hexatune/dsp_audio');
      });
    });

    group('log interval', () {
      test('logInterval is 3 seconds', () {
        expect(DspConstants.logInterval, const Duration(seconds: 3));
      });
    });
  });

  group('HtdError', () {
    test('ok has code 0', () {
      expect(HtdError.ok.code, 0);
    });

    test('all error codes are negative except ok', () {
      for (final error in HtdError.values) {
        if (error == HtdError.ok) {
          expect(error.code, 0);
        } else {
          expect(error.code, isNegative);
        }
      }
    });

    test('all error codes are unique', () {
      final codes = HtdError.values.map((e) => e.code).toSet();
      expect(codes.length, HtdError.values.length);
    });

    test('error codes match C header values', () {
      expect(HtdError.ok.code, 0);
      expect(HtdError.nullPointer.code, -1);
      expect(HtdError.invalidConfig.code, -2);
      expect(HtdError.initFailed.code, -3);
      expect(HtdError.invalidUtf8.code, -4);
      expect(HtdError.bufferTooSmall.code, -5);
      expect(HtdError.loadFailed.code, -6);
      expect(HtdError.layerLimitExceeded.code, -7);
      expect(HtdError.baseRequired.code, -8);
    });

    test('fromCode returns correct enum value', () {
      expect(HtdError.fromCode(0), HtdError.ok);
      expect(HtdError.fromCode(-1), HtdError.nullPointer);
      expect(HtdError.fromCode(-8), HtdError.baseRequired);
    });

    test('fromCode returns ok for unknown codes', () {
      expect(HtdError.fromCode(99), HtdError.ok);
      expect(HtdError.fromCode(-99), HtdError.ok);
    });

    test('all errors have non-empty description', () {
      for (final error in HtdError.values) {
        expect(error.description, isNotEmpty);
      }
    });

    test('description returns expected strings', () {
      expect(HtdError.ok.description, 'Success');
      expect(HtdError.nullPointer.description, 'Null pointer');
      expect(HtdError.baseRequired.description, 'Base layer required');
    });
  });
}
