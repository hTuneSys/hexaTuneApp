// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:hexatuneapp/src/core/rest/auth/auth_service.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/router/route_names.dart';
import 'package:hexatuneapp/src/pages/shared/app_bottom_bar.dart';

/// Dummy home page — navigation hub for testing all API endpoints.
class DummyHomePage extends StatelessWidget {
  const DummyHomePage({super.key});

  static const _sections = <_NavItem>[
    _NavItem(
      icon: Icons.vpn_key,
      title: 'Auth Extras',
      subtitle: 'Forgot/reset password, re-auth, refresh',
      route: RouteNames.authExtras,
    ),
    _NavItem(
      icon: Icons.person,
      title: 'Account & Profile',
      subtitle: 'Account info, profile view/edit',
      route: RouteNames.account,
    ),
    _NavItem(
      icon: Icons.devices,
      title: 'Sessions',
      subtitle: 'Active sessions, revoke',
      route: RouteNames.sessions,
    ),
    _NavItem(
      icon: Icons.phone_android,
      title: 'Devices & Approvals',
      subtitle: 'Push token, device approval flow',
      route: RouteNames.devices,
    ),
    _NavItem(
      icon: Icons.link,
      title: 'Providers',
      subtitle: 'Link/unlink auth providers',
      route: RouteNames.providers,
    ),
    _NavItem(
      icon: Icons.business,
      title: 'Tenants',
      subtitle: 'Memberships, switch tenant',
      route: RouteNames.tenants,
    ),
    _NavItem(
      icon: Icons.task,
      title: 'Tasks',
      subtitle: 'Create, status, cancel',
      route: RouteNames.tasks,
    ),
    _NavItem(
      icon: Icons.history,
      title: 'Audit Logs',
      subtitle: 'Query with filters',
      route: RouteNames.audit,
    ),
    _NavItem(
      icon: Icons.music_note,
      title: 'Harmonics',
      subtitle: 'Generate harmonic numbers',
      route: RouteNames.harmonics,
    ),
    _NavItem(
      icon: Icons.equalizer,
      title: 'DSP Audio Engine',
      subtitle: 'Multi-layer audio with binaural beats',
      route: RouteNames.dsp,
    ),
    _NavItem(
      icon: Icons.cable,
      title: 'hexaGen Device',
      subtitle: 'Hardware connection, RGB, freq sweep, operations',
      route: RouteNames.hexagen,
    ),
    _NavItem(
      icon: Icons.play_circle_outline,
      title: 'Harmonizer',
      subtitle: 'Multi-mode harmonic generator',
      route: RouteNames.harmonizer,
    ),
    _NavItem(
      icon: Icons.verified_user,
      title: 'OTP / Email Verify',
      subtitle: 'Verify email OTP, resend verification',
      route: RouteNames.otp,
    ),
    _NavItem(
      icon: Icons.account_balance_wallet,
      title: 'Wallet',
      subtitle: 'Balance, packages, purchases, transactions',
      route: RouteNames.wallet,
    ),
    _NavItem(
      icon: Icons.bug_report,
      title: 'Log Monitor',
      subtitle: 'Real-time debug logs, REST traffic, FFI events',
      route: RouteNames.logMonitor,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('hexaTune Dev'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              final log = getIt<LogService>();
              log.devLog('→ Logout button tapped', category: LogCategory.ui);
              await getIt<AuthService>().logout();
              log.devLog('✓ Logout complete', category: LogCategory.ui);
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          16 + AppBottomBar.scrollPadding,
        ),
        itemCount: _sections.length,
        separatorBuilder: (_, a) => const SizedBox(height: 8),
        itemBuilder: (ctx, i) {
          final item = _sections[i];
          return Card(
            child: ListTile(
              leading: Icon(item.icon),
              title: Text(item.title, style: theme.textTheme.titleSmall),
              subtitle: Text(item.subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(item.route),
            ),
          );
        },
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
}
