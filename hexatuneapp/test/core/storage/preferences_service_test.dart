// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hexatuneapp/src/core/storage/preferences_service.dart';

void main() {
  group('PreferencesService', () {
    late PreferencesService service;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      service = PreferencesService();
      await service.init();
    });

    group('String operations', () {
      test('setString and getString round-trip', () async {
        final result = await service.setString('key', 'value');
        expect(result, isTrue);
        expect(service.getString('key'), 'value');
      });

      test('getString returns null for missing key', () {
        expect(service.getString('nonexistent'), isNull);
      });

      test('setString overwrites existing value', () async {
        await service.setString('key', 'first');
        await service.setString('key', 'second');
        expect(service.getString('key'), 'second');
      });
    });

    group('Bool operations', () {
      test('setBool and getBool round-trip', () async {
        final result = await service.setBool('flag', true);
        expect(result, isTrue);
        expect(service.getBool('flag'), isTrue);
      });

      test('getBool returns null for missing key', () {
        expect(service.getBool('nonexistent'), isNull);
      });

      test('setBool stores false correctly', () async {
        await service.setBool('flag', false);
        expect(service.getBool('flag'), isFalse);
      });
    });

    group('Int operations', () {
      test('setInt and getInt round-trip', () async {
        final result = await service.setInt('count', 42);
        expect(result, isTrue);
        expect(service.getInt('count'), 42);
      });

      test('getInt returns null for missing key', () {
        expect(service.getInt('nonexistent'), isNull);
      });

      test('setInt stores zero correctly', () async {
        await service.setInt('count', 0);
        expect(service.getInt('count'), 0);
      });

      test('setInt stores negative values', () async {
        await service.setInt('count', -5);
        expect(service.getInt('count'), -5);
      });
    });

    group('Generic operations', () {
      test('containsKey returns false for missing key', () {
        expect(service.containsKey('nonexistent'), isFalse);
      });

      test('containsKey returns true after setting a value', () async {
        await service.setString('key', 'value');
        expect(service.containsKey('key'), isTrue);
      });

      test('remove deletes a key', () async {
        await service.setString('key', 'value');
        final result = await service.remove('key');
        expect(result, isTrue);
        expect(service.getString('key'), isNull);
        expect(service.containsKey('key'), isFalse);
      });

      test('clear removes all keys', () async {
        await service.setString('a', '1');
        await service.setInt('b', 2);
        await service.setBool('c', true);

        final result = await service.clear();
        expect(result, isTrue);
        expect(service.getString('a'), isNull);
        expect(service.getInt('b'), isNull);
        expect(service.getBool('c'), isNull);
      });
    });
  });
}
