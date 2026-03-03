// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:hexatuneapp/src/core/auth/auth_service.dart';
import 'package:hexatuneapp/src/core/config/env.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';
import 'package:hexatuneapp/src/core/router/route_names.dart';

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
      icon: Icons.category,
      title: 'Categories',
      subtitle: 'CRUD + search',
      route: RouteNames.categories,
    ),
    _NavItem(
      icon: Icons.inventory_2,
      title: 'Inventories',
      subtitle: 'CRUD + image upload/view',
      route: RouteNames.inventories,
    ),
    _NavItem(
      icon: Icons.science,
      title: 'Formulas',
      subtitle: 'CRUD + item management',
      route: RouteNames.formulas,
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
              if (Env.isDev) {
                log.devLog(
                  '→ Logout button tapped',
                  category: LogCategory.ui,
                );
              }
              await getIt<AuthService>().logout();
              if (Env.isDev) {
                log.devLog(
                  '✓ Logout complete',
                  category: LogCategory.ui,
                );
              }
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
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
