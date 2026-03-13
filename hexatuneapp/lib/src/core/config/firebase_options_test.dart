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
///   --project=hexatune-test \
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
    apiKey: 'AIzaSyDqWiv97lAf9s1-achxgaR3g2DA1rpOKPs',
    appId: '1:151652565114:android:fc0d47a5c2b205f69e7bc3',
    messagingSenderId: '151652565114',
    projectId: 'hexatune-test',
    storageBucket: 'hexatune-test.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAEEnDOstpYjh4qh9L_kJYOuvHdRxpS33Y',
    appId: '1:151652565114:ios:e388f8ead951d2259e7bc3',
    messagingSenderId: '151652565114',
    projectId: 'hexatune-test',
    storageBucket: 'hexatune-test.firebasestorage.app',
    iosClientId:
        '151652565114-9abfc026sf6cm67q6cl8ms39c7vhbfsq.apps.googleusercontent.com',
    iosBundleId: 'com.hexatune.hexatuneapp',
  );
}
