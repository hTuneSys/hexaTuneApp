// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/router/route_names.dart';

void main() {
  group('RouteNames', () {
    test('public routes have correct paths', () {
      expect(RouteNames.splash, '/');
      expect(RouteNames.login, '/login');
      expect(RouteNames.register, '/register');
      expect(RouteNames.verifyEmail, '/verify-email');
      expect(RouteNames.forgotPassword, '/forgot-password');
      expect(RouteNames.resetPassword, '/reset-password');
    });

    test('protected routes have correct paths', () {
      expect(RouteNames.home, '/home');
      expect(RouteNames.reAuth, '/re-auth');
      expect(RouteNames.deviceApproval, '/device-approval');
    });

    test('dev test pages have /dev/ prefix', () {
      expect(RouteNames.authExtras, startsWith('/dev/'));
      expect(RouteNames.providers, startsWith('/dev/'));
      expect(RouteNames.tenants, startsWith('/dev/'));
      expect(RouteNames.tasks, startsWith('/dev/'));
      expect(RouteNames.audit, startsWith('/dev/'));
    });

    test('settings sub-routes have /settings/ prefix', () {
      expect(RouteNames.settingsProfile, '/settings/profile');
      expect(RouteNames.settingsWallet, '/settings/wallet');
      expect(RouteNames.settingsSessions, '/settings/sessions');
      expect(RouteNames.settingsDevices, '/settings/devices');
      expect(RouteNames.providerManagement, '/settings/providers');
    });

    test('inventory production routes have correct paths', () {
      expect(RouteNames.inventoryList, '/inventories');
      expect(RouteNames.inventoryCreate, '/inventories/create');
      expect(RouteNames.inventoryEdit, '/inventories/:inventoryId/edit');
      expect(RouteNames.inventoryView, '/inventories/:inventoryId');
    });

    test('inventory helper methods generate correct paths', () {
      expect(RouteNames.inventoryEditFor('abc'), '/inventories/abc/edit');
      expect(RouteNames.inventoryViewFor('abc'), '/inventories/abc');
    });

    test('formula production routes have correct paths', () {
      expect(RouteNames.formulaList, '/formulas');
      expect(RouteNames.formulaCreate, '/formulas/create');
      expect(RouteNames.formulaEdit, '/formulas/:formulaId/edit');
      expect(RouteNames.formulaView, '/formulas/:formulaId');
    });

    test('formula helper methods generate correct paths', () {
      expect(RouteNames.formulaEditFor('abc'), '/formulas/abc/edit');
      expect(RouteNames.formulaViewFor('abc'), '/formulas/abc');
    });

    test('ambience production routes have correct paths', () {
      expect(RouteNames.ambienceList, '/ambiences');
      expect(RouteNames.ambienceCreate, '/ambiences/create');
      expect(RouteNames.ambienceEdit, '/ambiences/:ambienceId/edit');
      expect(RouteNames.ambienceView, '/ambiences/:ambienceId');
    });

    test('ambience helper methods generate correct paths', () {
      expect(RouteNames.ambienceEditFor('abc'), '/ambiences/abc/edit');
      expect(RouteNames.ambienceViewFor('abc'), '/ambiences/abc');
    });
  });
}
