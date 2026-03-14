// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

/// Firebase configuration for the **prod** environment.
///
/// To regenerate, run:
/// ```bash
/// flutterfire configure \
///   --project=hexatune-prod \
///   --out=lib/src/core/config/firebase_options_prod.dart
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
    apiKey: 'AIzaSyCFpQiGzvyOqurab0Z481EIsYmL9ovsIpw',
    appId: '1:54713508717:android:3881315f1dca6599027064',
    messagingSenderId: '54713508717',
    projectId: 'hexatune-prod',
    storageBucket: 'hexatune-prod.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAaQ03BQU0ADMhnAs3_d4kdmmkBfyPvseA',
    appId: '1:54713508717:ios:4237e031b72c1c7b027064',
    messagingSenderId: '54713508717',
    projectId: 'hexatune-prod',
    storageBucket: 'hexatune-prod.firebasestorage.app',
    iosClientId:
        '54713508717-urf6k0crhqff4k2p00d49smvo4n1jr0q.apps.googleusercontent.com',
    iosBundleId: 'com.hexatune.hexatuneapp',
  );
}
