// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'package:hexatuneapp/src/core/di/injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: false)
Future<void> configureDependencies() async => getIt.init();
