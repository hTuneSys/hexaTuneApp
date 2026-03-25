// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';

/// Reusable auth page header showing the app logo and brand name.
class AuthHeader extends StatelessWidget {
  const AuthHeader({this.size = 175, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/icon/app_icon.svg',
          width: size,
          height: size,
          colorFilter: ColorFilter.mode(
            theme.colorScheme.onSurface,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.app,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
