// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:hexatuneapp/src/core/bootstrap/app_bootstrap.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
