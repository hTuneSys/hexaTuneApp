// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

/// Firebase configuration for the **stage** environment.
///
/// To regenerate, run:
/// ```bash
/// flutterfire configure \
///   --project=hexatune-stage \
///   --out=lib/src/core/config/firebase_options_stage.dart
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
    apiKey: 'AIzaSyBVXu8qGtvG_KwtPPF0v9PmaUq3ZMDV3vI',
    appId: '1:13216909410:android:4823a3aedc5ad99522293b',
    messagingSenderId: '13216909410',
    projectId: 'hexatune-stage',
    storageBucket: 'hexatune-stage.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDCmBhQj9Rn-MbIJ_3skxAPhvBA9fJDdbI',
    appId: '1:13216909410:ios:3c6e96f36da3ef3d22293b',
    messagingSenderId: '13216909410',
    projectId: 'hexatune-stage',
    storageBucket: 'hexatune-stage.firebasestorage.app',
    iosClientId:
        '13216909410-q8fk2cd0rqti4et43r7c89no05419p14.apps.googleusercontent.com',
    iosBundleId: 'com.hexatune.hexatuneapp',
  );
}
