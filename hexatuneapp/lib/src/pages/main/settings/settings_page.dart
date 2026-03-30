// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/config/env.dart';
import 'package:hexatuneapp/src/core/router/route_names.dart';
import 'package:hexatuneapp/src/pages/shared/app_bottom_bar.dart';

/// Main settings page accessible from the bottom navigation bar.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const _aboutUrl = 'https://hexatune.com/';
  static const _privacyUrl = 'https://hexatune.com/privacy/';
  static const _termsUrl = 'https://hexatune.com/terms/';

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
          _SettingsTile(
            icon: Icons.person_outline,
            title: l10n.settingsProfile,
            subtitle: l10n.settingsProfileSubtitle,
            onTap: () => context.go(RouteNames.settingsProfile),
          ),
          _SettingsTile(
            icon: Icons.account_balance_wallet_outlined,
            title: l10n.settingsWallet,
            subtitle: l10n.settingsWalletSubtitle,
            onTap: () => context.go(RouteNames.settingsWallet),
          ),
          _SettingsTile(
            icon: Icons.schedule_outlined,
            title: l10n.settingsSessions,
            subtitle: l10n.settingsSessionsSubtitle,
            onTap: () => context.go(RouteNames.settingsSessions),
          ),
          _SettingsTile(
            icon: Icons.devices_outlined,
            title: l10n.settingsDevices,
            subtitle: l10n.settingsDevicesSubtitle,
            onTap: () => context.go(RouteNames.settingsDevices),
          ),
          _SettingsTile(
            icon: Icons.link,
            title: l10n.settingsLinkedAccounts,
            subtitle: l10n.settingsLinkedAccountsSubtitle,
            onTap: () => context.go(RouteNames.providerManagement),
          ),
          if (!Env.isProd)
            _SettingsTile(
              icon: Icons.bug_report,
              title: l10n.settingsLogMonitor,
              subtitle: l10n.settingsLogMonitorSubtitle,
              onTap: () => context.go(RouteNames.settingsLogMonitor),
            ),
          Divider(color: theme.colorScheme.outlineVariant),
          _SettingsTile(
            icon: Icons.info_outline,
            title: l10n.settingsAbout,
            isExternal: true,
            onTap: () => _openUrl(_aboutUrl),
          ),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: l10n.settingsPrivacyPolicy,
            isExternal: true,
            onTap: () => _openUrl(_privacyUrl),
          ),
          _SettingsTile(
            icon: Icons.description_outlined,
            title: l10n.settingsTermsOfService,
            isExternal: true,
            onTap: () => _openUrl(_termsUrl),
          ),
        ],
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.isExternal = false,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool isExternal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(icon, color: theme.colorScheme.onPrimaryContainer),
        ),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing: Icon(
          isExternal ? Icons.open_in_new : Icons.chevron_right,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        onTap: onTap,
      ),
    );
  }
}
