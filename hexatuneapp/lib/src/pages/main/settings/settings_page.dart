// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/router/route_names.dart';
import 'package:hexatuneapp/src/pages/shared/app_bottom_bar.dart';

/// Main settings page accessible from the bottom navigation bar.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          16 + AppBottomBar.scrollPadding,
        ),
        children: [
          Card(
            child: ListTile(
              leading: Icon(Icons.link, color: theme.colorScheme.primary),
              title: Text(l10n.settingsLinkedAccounts),
              subtitle: Text(l10n.settingsLinkedAccountsSubtitle),
              trailing: Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              onTap: () => context.go(RouteNames.providerManagement),
            ),
          ),
        ],
      ),
    );
  }
}
