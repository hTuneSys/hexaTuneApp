// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

/// Firebase configuration for the **dev** environment.
///
/// To regenerate, run:
/// ```bash
/// flutterfire configure \
///   --project=hexatune-dev \
///   --out=lib/src/core/config/firebase_options_dev.dart
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDjXVoKTEpU9WGaaBOfK5YZHUHafHai1WY',
    appId: '1:1028765878289:android:ffe5b0330cb2e10a93c9b0',
    messagingSenderId: '1028765878289',
    projectId: 'hexatune-dev',
    storageBucket: 'hexatune-dev.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAqdXXcu5lgm_zQg1fV1Ku5XhuZHhwrj2w',
    appId: '1:1028765878289:ios:34ad007d0770f71193c9b0',
    messagingSenderId: '1028765878289',
    projectId: 'hexatune-dev',
    storageBucket: 'hexatune-dev.firebasestorage.app',
    androidClientId:
        '1028765878289-jp352on9ptv0a5m1bc9km0v87e0fot1h.apps.googleusercontent.com',
    iosClientId:
        '1028765878289-25ffio977as63bm4lg9m8jp0luq3n006.apps.googleusercontent.com',
    iosBundleId: 'com.hexatune.hexatuneapp',
  );
}
