// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/payment/models/iap_status.dart';

void main() {
  group('IapStatus', () {
    test('has all expected values', () {
      expect(IapStatus.values, hasLength(8));
      expect(IapStatus.values, contains(IapStatus.idle));
      expect(IapStatus.values, contains(IapStatus.loading));
      expect(IapStatus.values, contains(IapStatus.pending));
      expect(IapStatus.values, contains(IapStatus.verifying));
      expect(IapStatus.values, contains(IapStatus.success));
      expect(IapStatus.values, contains(IapStatus.error));
      expect(IapStatus.values, contains(IapStatus.canceled));
      expect(IapStatus.values, contains(IapStatus.unavailable));
    });

    test('name returns correct string', () {
      expect(IapStatus.idle.name, 'idle');
      expect(IapStatus.loading.name, 'loading');
      expect(IapStatus.pending.name, 'pending');
      expect(IapStatus.verifying.name, 'verifying');
      expect(IapStatus.success.name, 'success');
      expect(IapStatus.error.name, 'error');
      expect(IapStatus.canceled.name, 'canceled');
      expect(IapStatus.unavailable.name, 'unavailable');
    });
  });
}
