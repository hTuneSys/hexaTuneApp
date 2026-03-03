// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:hexatuneapp/src/core/auth/auth_service.dart';
import 'package:hexatuneapp/src/core/config/env.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/log/log_category.dart';
import 'package:hexatuneapp/src/core/log/log_service.dart';

/// Dummy home page for testing — will be replaced with production UI.
class DummyHomePage extends StatelessWidget {
  const DummyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('hexaTune App'),
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
      body: const Center(
        child: Text('hexaTune App', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
