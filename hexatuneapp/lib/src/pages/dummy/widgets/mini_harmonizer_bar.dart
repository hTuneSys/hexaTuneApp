// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/harmonizer/harmonizer_service.dart';
import 'package:hexatuneapp/src/core/harmonizer/models/harmonizer_state.dart';

/// A compact mini-harmonizer bar that shows at the bottom of the screen
/// when the harmonizer is harmonizing and the user navigates away from
/// the harmonizer page.
class MiniHarmonizerBar extends StatefulWidget {
  const MiniHarmonizerBar({super.key});

  @override
  State<MiniHarmonizerBar> createState() => _MiniHarmonizerBarState();
}

class _MiniHarmonizerBarState extends State<MiniHarmonizerBar>
    with SingleTickerProviderStateMixin {
  late final HarmonizerService _harmonizer;
  StreamSubscription<HarmonizerState>? _sub;
  HarmonizerState _state = const HarmonizerState();

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  Timer? _immediateTimer;
  bool _fadingOut = false;

  @override
  void initState() {
    super.initState();
    _harmonizer = getIt<HarmonizerService>();
    _state = _harmonizer.currentState;

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _sub = _harmonizer.state.listen((s) {
      if (!mounted) return;
      final wasPlaying =
          _state.status == HarmonizerStatus.playing ||
          _state.status == HarmonizerStatus.stopping;
      final isIdle = s.status == HarmonizerStatus.idle;

      setState(() => _state = s);

      // Trigger fade-out when transitioning from playing/stopping to idle.
      if (wasPlaying && isIdle && !_fadingOut) {
        _fadingOut = true;
        _fadeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _immediateTimer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isVisible =
        _state.status == HarmonizerStatus.playing ||
        _state.status == HarmonizerStatus.stopping ||
        _fadingOut;

    if (!isVisible) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final totalDur = _state.isFirstCycle
        ? _state.firstCycleDuration
        : _state.totalCycleDuration;

    Widget bar = Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Total duration
          Text(
            _formatDuration(totalDur),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const Spacer(),

          // Stop / Loading button
          if (_state.status == HarmonizerStatus.stopping)
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: colorScheme.error,
              ),
            )
          else
            GestureDetector(
              onLongPressStart: (_) => _startImmediateTimer(),
              onLongPressEnd: (_) => _cancelImmediateTimer(),
              child: IconButton(
                icon: const Icon(Icons.stop),
                tooltip: l10n.harmonizerGracefulStopHint,
                onPressed: _harmonizer.stopGraceful,
                color: colorScheme.error,
              ),
            ),

          const Spacer(),

          // Remaining countdown
          Text(
            _formatDuration(_state.remainingInCycle),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );

    if (_fadingOut) {
      bar = FadeTransition(
        opacity: ReverseAnimation(_fadeAnimation),
        child: bar,
      );
    }

    return bar;
  }

  void _startImmediateTimer() {
    _immediateTimer?.cancel();
    _immediateTimer = Timer(const Duration(seconds: 3), () {
      _harmonizer.stopImmediate();
    });
  }

  void _cancelImmediateTimer() {
    _immediateTimer?.cancel();
    _immediateTimer = null;
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}
