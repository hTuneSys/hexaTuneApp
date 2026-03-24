// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/bootstrap/bootstrap_step.dart';

/// Splash screen shown during app initialization.
///
/// When [steps] is provided (bootstrap phase), displays live progress
/// for each initialization step. When used from the router (no steps),
/// shows only the logo.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key, this.steps, this.onRetry});

  final ValueNotifier<List<BootstrapStep>>? steps;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appName = AppLocalizations.of(context)?.app ?? 'hexaTune';

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/icon/app_icon.png', width: 100, height: 100),
              const SizedBox(height: 16),
              Text(
                appName,
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (steps != null) ...[
                const SizedBox(height: 32),
                _BootstrapProgress(steps: steps!, onRetry: onRetry),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BootstrapProgress extends StatelessWidget {
  const _BootstrapProgress({required this.steps, this.onRetry});

  final ValueNotifier<List<BootstrapStep>> steps;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<BootstrapStep>>(
      valueListenable: steps,
      builder: (context, stepList, _) {
        final hasError = stepList.any(
          (s) => s.status == BootstrapStepStatus.error,
        );

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...stepList.map((step) => _StepRow(step: step)),
              if (hasError && onRetry != null) ...[
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step});

  final BootstrapStep step;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          _statusIcon(step.status, theme),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                if (step.error != null)
                  Text(
                    step.error!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusIcon(BootstrapStepStatus status, ThemeData theme) {
    return switch (status) {
      BootstrapStepStatus.pending => Icon(
        Icons.circle_outlined,
        size: 18,
        color: theme.colorScheme.outline,
      ),
      BootstrapStepStatus.running => SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: theme.colorScheme.primary,
        ),
      ),
      BootstrapStepStatus.done => Icon(
        Icons.check_circle,
        size: 18,
        color: theme.colorScheme.primary,
      ),
      BootstrapStepStatus.error => Icon(
        Icons.error,
        size: 18,
        color: theme.colorScheme.error,
      ),
    };
  }
}
