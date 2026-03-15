// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

/// Firebase configuration for the **test** environment.
///
/// To regenerate, run:
/// ```bash
/// flutterfire configure \
///   --project=hexatune-core \
///   --out=lib/src/core/config/firebase_options_test.dart
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
    apiKey: 'AIzaSyAaqb-Vbb1JMjbvY_dRzCulhE6SiXZuQz0',
    appId: '1:1096689897838:android:43f066dd99fc98c635317f',
    messagingSenderId: '1096689897838',
    projectId: 'hexatune-core',
    storageBucket: 'hexatune-core.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB9ZMz2dxMj-i9hdSkGHDHchFUccW3iGAE',
    appId: '1:1096689897838:ios:5312ecaf14709df935317f',
    messagingSenderId: '1096689897838',
    projectId: 'hexatune-core',
    storageBucket: 'hexatune-core.firebasestorage.app',
    androidClientId:
        '1096689897838-s88sk14ee6l0k3obto3m0oklba590rq4.apps.googleusercontent.com',
    iosClientId:
        '1096689897838-gu7l9ooauihl1j9oe2bjq933ij389q5j.apps.googleusercontent.com',
    iosBundleId: 'com.hexatune.hexatuneapp',
  );
}
