// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/bootstrap/app_bootstrap.dart';
import 'package:hexatuneapp/src/core/bootstrap/bootstrap_step.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/theme/hexatune.dart';
import 'package:hexatuneapp/src/app.dart';
import 'package:hexatuneapp/src/pages/shared/auth/splash_page.dart';

/// Root widget that manages the bootstrap-to-app lifecycle.
///
/// Shows [SplashPage] with live progress during initialization,
/// then switches to [HexaTuneApp] once all services are ready.
class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  bool _ready = false;
  bool _diCompleted = false;

  late final ValueNotifier<List<BootstrapStep>> _steps;

  static const _diLabel = 'Dependency Injection';

  @override
  void initState() {
    super.initState();
    _steps = ValueNotifier(_buildInitialSteps());
    _runBootstrap();
  }

  @override
  void dispose() {
    _steps.dispose();
    super.dispose();
  }

  List<BootstrapStep> _buildInitialSteps() {
    return [
      const BootstrapStep(label: _diLabel),
      ...AppBootstrap.stepLabels.map((l) => BootstrapStep(label: l)),
    ];
  }

  void _updateStep(int index, BootstrapStepStatus status, [String? error]) {
    final list = List<BootstrapStep>.of(_steps.value);
    list[index] = list[index].copyWith(status: status, error: error);
    _steps.value = list;
  }

  Future<void> _runBootstrap() async {
    // Step 0: Dependency Injection.
    if (!_diCompleted) {
      _updateStep(0, BootstrapStepStatus.running);
      try {
        await configureDependencies();
        _diCompleted = true;
        _updateStep(0, BootstrapStepStatus.done);
      } catch (e) {
        _updateStep(0, BootstrapStepStatus.error, e.toString());
        return;
      }
    } else {
      _updateStep(0, BootstrapStepStatus.done);
    }

    // Steps 1–N: Service bootstrap (indices shifted by 1 for DI).
    try {
      await AppBootstrap.initialize(
        onProgress: (stepIndex, status, [error]) {
          _updateStep(stepIndex + 1, status, error);
        },
      );
    } catch (e) {
      getIt<LogService>().critical(
        'App startup failed',
        category: LogCategory.app,
        exception: e,
      );
      return;
    }

    if (mounted) {
      setState(() => _ready = true);
    }
  }

  void _retry() {
    setState(() {
      _ready = false;
      _steps.value = _buildInitialSteps();
    });
    _runBootstrap();
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) return const HexaTuneApp();

    // Pre-DI splash uses a default TextTheme (createTextTheme depends on DI).
    final theme = MaterialTheme(ThemeData().textTheme);
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: theme.light(),
      darkTheme: theme.dark(),
      home: SplashPage(steps: _steps, onRetry: _retry),
    );
  }
}
