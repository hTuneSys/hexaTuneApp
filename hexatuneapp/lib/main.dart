// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:hexatuneapp/src/core/bootstrap/app_bootstrap.dart';
import 'package:hexatuneapp/src/core/config/env.dart';
import 'package:hexatuneapp/src/core/config/firebase_options_dev.dart'
    as fb_dev;
import 'package:hexatuneapp/src/core/config/firebase_options_test.dart'
    as fb_test;
import 'package:hexatuneapp/src/core/config/firebase_options_stage.dart'
    as fb_stage;
import 'package:hexatuneapp/src/core/config/firebase_options_prod.dart'
    as fb_prod;
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with environment-specific configuration.
  try {
    await Firebase.initializeApp(
      options: switch (Env.environment) {
        'prod' => fb_prod.DefaultFirebaseOptions.currentPlatform,
        'stage' => fb_stage.DefaultFirebaseOptions.currentPlatform,
        'test' => fb_test.DefaultFirebaseOptions.currentPlatform,
        _ => fb_dev.DefaultFirebaseOptions.currentPlatform,
      },
    );
  } catch (e) {
    // Firebase may not be configured yet — run `flutterfire configure`
    // for each environment to generate firebase_options_*.dart files.
    // The app works without Firebase, but FCM notifications will be
    // unavailable.
    // LogService is not available yet (pre-DI), so use debugPrint.
    if (Env.isDev) {
      debugPrint('[BOOTSTRAP] Firebase init failed — FCM unavailable: $e');
    }
  }

  // Register all services via get_it + injectable.
  await configureDependencies();

  // Run sequential bootstrap (storage, device, tokens, notifications, auth).
  try {
    await AppBootstrap.initialize();
  } catch (e) {
    getIt<LogService>().critical(
      'App startup failed',
      category: LogCategory.app,
      exception: e,
    );
  }

  runApp(const HexaTuneApp());
}
