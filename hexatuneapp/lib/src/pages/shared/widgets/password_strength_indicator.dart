// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';

/// Visual password strength indicator bar with a label.
class PasswordStrengthIndicator extends StatelessWidget {
  const PasswordStrengthIndicator({required this.password, super.key});

  final String password;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final strength = _calculateStrength(password);
    final label = _strengthLabel(l10n, strength);
    final color = _strengthColor(theme, strength);

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: strength,
              minHeight: 6,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(label, style: theme.textTheme.labelMedium?.copyWith(color: color)),
      ],
    );
  }

  double _calculateStrength(String password) {
    if (password.isEmpty) return 0;
    var score = 0.0;
    if (password.length >= 8) score += 0.25;
    if (password.contains(RegExp('[A-Z]'))) score += 0.25;
    if (password.contains(RegExp('[0-9]'))) score += 0.25;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score += 0.25;
    return score;
  }

  String _strengthLabel(AppLocalizations l10n, double strength) {
    if (strength <= 0.25) return l10n.passwordStrengthWeak;
    if (strength <= 0.5) return l10n.passwordStrengthFair;
    if (strength <= 0.75) return l10n.passwordStrengthGood;
    return l10n.passwordStrengthStrong;
  }

  Color _strengthColor(ThemeData theme, double strength) {
    if (strength <= 0.25) return theme.colorScheme.error;
    if (strength <= 0.5) return theme.colorScheme.tertiary;
    if (strength <= 0.75) return theme.colorScheme.secondary;
    return theme.colorScheme.primary;
  }
}
