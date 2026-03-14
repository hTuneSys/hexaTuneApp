// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// Bootstrap integration: full service init sequence → correct
/// initial route based on auth state.
///
/// NOTE: These tests require http_mock_adapter or a mock backend.
/// They will be completed when the OpenAPI spec is provided.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Bootstrap integration', () {
    testWidgets('all services initialize in correct order', (tester) async {
      // TODO: Implement when API models from OpenAPI spec are available.
      // 1. Mock all platform channels (secure_storage, shared_prefs, etc.)
      // 2. Boot app (DI + bootstrap)
      // 3. Verify all services are registered and initialized
      // 4. Verify correct initial route (login or home)
    }, skip: true);
  });
}
