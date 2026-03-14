// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

import 'package:hexatuneapp/l10n/app_localizations.dart';
import 'package:hexatuneapp/src/core/di/injection.dart';
import 'package:hexatuneapp/src/core/router/app_router.dart';
import 'package:hexatuneapp/src/core/theme/hexatune.dart';
import 'package:hexatuneapp/src/core/utils/theme.dart';

class HexaTuneApp extends StatelessWidget {
  const HexaTuneApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context);
    MaterialTheme theme = MaterialTheme(textTheme);
    final appRouter = getIt<AppRouter>();

    return MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'hexaTune',
      debugShowCheckedModeBanner: false,
      theme: theme.light(),
      darkTheme: theme.dark(),
      routerConfig: appRouter.router,
    );
  }
}
