// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

// Integration tests require a running emulator or device.
// Run with: flutter test integration_test/

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// Full auth flow: boot → splash → login → credentials → home →
/// token expires → silent refresh → continue usage.
///
/// NOTE: These tests require http_mock_adapter or a mock backend
/// to simulate API responses. They will be completed when the
/// OpenAPI spec is provided and real API endpoints are configured.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Auth flow integration', () {
    testWidgets('boot → login → home flow', (tester) async {
      // TODO: Implement when API models from OpenAPI spec are available.
      // 1. Set up mock API responses for login endpoint
      // 2. Boot app (DI + bootstrap)
      // 3. Verify splash → login redirect
      // 4. Enter credentials, tap login
      // 5. Verify navigation to home
    }, skip: true);

    testWidgets('token expiry triggers silent refresh', (tester) async {
      // TODO: Implement when API models from OpenAPI spec are available.
      // 1. Set up authenticated state with short-lived token
      // 2. Simulate 401 response
      // 3. Mock refresh endpoint success
      // 4. Verify app continues without interruption
    }, skip: true);
  });
}
