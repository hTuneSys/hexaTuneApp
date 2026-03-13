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

  // TODO: Replace with actual values from `flutterfire configure`.
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'PLACEHOLDER',
    appId: 'PLACEHOLDER',
    messagingSenderId: 'PLACEHOLDER',
    projectId: 'hexatune-dev',
    storageBucket: 'hexatune-dev.firebasestorage.app',
  );

  // TODO: Replace with actual values from `flutterfire configure`.
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'PLACEHOLDER',
    appId: 'PLACEHOLDER',
    messagingSenderId: 'PLACEHOLDER',
    projectId: 'hexatune-dev',
    storageBucket: 'hexatune-dev.firebasestorage.app',
    iosBundleId: 'com.hexatune.hexatuneapp',
  );
}
