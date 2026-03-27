// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/bootstrap/app_bootstrap.dart';
import 'package:hexatuneapp/src/core/bootstrap/bootstrap_step.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/harmonizer/harmonizer_service.dart';
import 'package:hexatuneapp/src/core/harmonizer/hexatune_audio_handler.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/permission/permission_service.dart';
import 'package:hexatuneapp/src/core/storage/preferences_service.dart';
import 'package:hexatuneapp/src/core/theme/hexatune.dart';
import 'package:hexatuneapp/src/app.dart';
import 'package:hexatuneapp/src/pages/auth/splash_page.dart';

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
      // Request notification permission (required for Android 13+ foreground
      // service notification visibility).
      await _requestNotificationPermission();

      // Configure audio session for music playback.
      await _configureAudioSession();

      // Initialize audio service (one-isolate mode) before other services.
      await _initAudioService();

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

  /// Requests the `POST_NOTIFICATIONS` runtime permission on Android 13+.
  ///
  /// Without this, the foreground service notification is invisible and some
  /// devices may not keep the service alive. Non-fatal — the app works without
  /// it but background playback may be unreliable.
  Future<void> _requestNotificationPermission() async {
    try {
      final log = getIt<LogService>();
      final result = await getIt<PermissionService>().requestNotification();
      log.info(
        'Notification permission result: ${result.name}',
        category: LogCategory.permission,
      );
    } catch (e) {
      getIt<LogService>().warning(
        'Notification permission request failed: $e',
        category: LogCategory.permission,
      );
    }
  }

  /// Configures the [AudioSession] for music playback.
  ///
  /// Tells the OS this app plays long-form audio, enabling proper audio focus
  /// management and interruption handling (e.g. phone calls, other media apps).
  Future<void> _configureAudioSession() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());
      getIt<LogService>().info(
        'AudioSession configured for music playback',
        category: LogCategory.dsp,
      );
    } catch (e) {
      getIt<LogService>().warning(
        'AudioSession configuration failed: $e',
        category: LogCategory.dsp,
      );
    }
  }

  /// Initializes the [AudioService] in one-isolate mode and registers the
  /// [HexaTuneAudioHandler] singleton.  Non-fatal — the app works without it.
  Future<void> _initAudioService() async {
    try {
      final handler = await AudioService.init(
        builder: () => HexaTuneAudioHandler(
          getIt<HarmonizerService>(),
          getIt<PreferencesService>(),
          getIt<LogService>(),
        ),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.hexatune.audio',
          androidNotificationChannelName: 'HexaTune Audio',
          androidStopForegroundOnPause: false,
        ),
      );
      getIt.registerSingleton<HexaTuneAudioHandler>(
        handler,
        dispose: (h) => h.dispose(),
      );

      getIt<LogService>().info(
        'AudioService initialized successfully',
        category: LogCategory.dsp,
      );
    } catch (e) {
      getIt<LogService>().warning(
        'AudioService init failed: $e',
        category: LogCategory.app,
      );
    }
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
