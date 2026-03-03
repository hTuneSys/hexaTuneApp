// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/formula/models/formula_response.dart';
import 'package:hexatuneapp/src/core/formula/models/formula_item_response.dart';
import 'package:hexatuneapp/src/core/formula/models/formula_detail_response.dart';
import 'package:hexatuneapp/src/core/formula/models/create_formula_request.dart';
import 'package:hexatuneapp/src/core/formula/models/update_formula_request.dart';
import 'package:hexatuneapp/src/core/formula/models/add_formula_item_entry.dart';
import 'package:hexatuneapp/src/core/formula/models/add_formula_items_request.dart';
import 'package:hexatuneapp/src/core/formula/models/update_formula_item_quantity_request.dart';
import 'package:hexatuneapp/src/core/formula/models/reorder_entry.dart';
import 'package:hexatuneapp/src/core/formula/models/reorder_formula_items_request.dart';

void main() {
  group('FormulaResponse', () {
    test('fromJson creates instance', () {
      final json = {
        'id': 'form-001',
        'name': 'Formula A',
        'labels': ['base', 'premium'],
        'createdAt': '2025-01-01T00:00:00Z',
        'updatedAt': '2025-06-01T00:00:00Z',
      };
      final response = FormulaResponse.fromJson(json);
      expect(response.id, 'form-001');
      expect(response.name, 'Formula A');
      expect(response.labels, ['base', 'premium']);
      expect(response.createdAt, '2025-01-01T00:00:00Z');
      expect(response.updatedAt, '2025-06-01T00:00:00Z');
    });

    test('toJson produces correct keys', () {
      const response = FormulaResponse(
        id: 'form-001',
        name: 'Formula A',
        labels: ['base'],
        createdAt: '2025-01-01T00:00:00Z',
        updatedAt: '2025-06-01T00:00:00Z',
      );
      final json = response.toJson();
      expect(json['id'], 'form-001');
      expect(json['name'], 'Formula A');
      expect(json['labels'], ['base']);
    });

    test('round-trip preserves values', () {
      const original = FormulaResponse(
        id: 'f',
        name: 'n',
        labels: ['l'],
        createdAt: 'c',
        updatedAt: 'u',
      );
      final restored = FormulaResponse.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('FormulaItemResponse', () {
    test('fromJson creates instance', () {
      final json = {
        'id': 'item-001',
        'inventoryId': 'inv-001',
        'sortOrder': 1,
        'quantity': 5,
      };
      final item = FormulaItemResponse.fromJson(json);
      expect(item.id, 'item-001');
      expect(item.inventoryId, 'inv-001');
      expect(item.sortOrder, 1);
      expect(item.quantity, 5);
    });

    test('toJson produces correct keys', () {
      const item = FormulaItemResponse(
        id: 'item-001',
        inventoryId: 'inv-001',
        sortOrder: 2,
        quantity: 10,
      );
      final json = item.toJson();
      expect(json['id'], 'item-001');
      expect(json['inventoryId'], 'inv-001');
      expect(json['sortOrder'], 2);
      expect(json['quantity'], 10);
    });

    test('round-trip preserves values', () {
      const original = FormulaItemResponse(
        id: 'i',
        inventoryId: 'v',
        sortOrder: 0,
        quantity: 1,
      );
      final restored = FormulaItemResponse.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('FormulaDetailResponse', () {
    test('fromJson with items list', () {
      final json = {
        'id': 'form-001',
        'name': 'Detail Formula',
        'labels': ['detail'],
        'items': [
          {
            'id': 'item-001',
            'inventoryId': 'inv-001',
            'sortOrder': 1,
            'quantity': 3,
          },
          {
            'id': 'item-002',
            'inventoryId': 'inv-002',
            'sortOrder': 2,
            'quantity': 7,
          },
        ],
        'createdAt': '2025-01-01T00:00:00Z',
        'updatedAt': '2025-06-01T00:00:00Z',
      };
      final detail = FormulaDetailResponse.fromJson(json);
      expect(detail.id, 'form-001');
      expect(detail.name, 'Detail Formula');
      expect(detail.labels, ['detail']);
      expect(detail.items.length, 2);
      expect(detail.items[0].id, 'item-001');
      expect(detail.items[1].quantity, 7);
      expect(detail.createdAt, '2025-01-01T00:00:00Z');
    });

    test('fromJson with empty items', () {
      final json = {
        'id': 'form-002',
        'name': 'Empty Formula',
        'labels': <String>[],
        'items': <Map<String, dynamic>>[],
        'createdAt': '2025-01-01T00:00:00Z',
        'updatedAt': '2025-06-01T00:00:00Z',
      };
      final detail = FormulaDetailResponse.fromJson(json);
      expect(detail.items, isEmpty);
    });

    test('toJson produces correct keys', () {
      const detail = FormulaDetailResponse(
        id: 'form-001',
        name: 'F',
        labels: ['l'],
        items: [
          FormulaItemResponse(
            id: 'item-001',
            inventoryId: 'inv-001',
            sortOrder: 1,
            quantity: 2,
          ),
        ],
        createdAt: '2025-01-01T00:00:00Z',
        updatedAt: '2025-06-01T00:00:00Z',
      );
      final json = detail.toJson();
      expect(json['id'], 'form-001');
      expect(json['name'], 'F');
      expect(json['items'], isList);
      expect((json['items'] as List).length, 1);
    });

    test('round-trip preserves values', () {
      const original = FormulaDetailResponse(
        id: 'f',
        name: 'n',
        labels: ['l'],
        items: [
          FormulaItemResponse(
            id: 'i',
            inventoryId: 'v',
            sortOrder: 0,
            quantity: 1,
          ),
        ],
        createdAt: 'c',
        updatedAt: 'u',
      );
      final json = jsonDecode(jsonEncode(original.toJson()))
          as Map<String, dynamic>;
      final restored = FormulaDetailResponse.fromJson(json);
      expect(restored, original);
    });
  });

  group('CreateFormulaRequest', () {
    test('fromJson with labels', () {
      final json = {
        'name': 'New Formula',
        'labels': ['tag'],
      };
      final request = CreateFormulaRequest.fromJson(json);
      expect(request.name, 'New Formula');
      expect(request.labels, ['tag']);
    });

    test('fromJson without optional labels', () {
      final json = {'name': 'Simple Formula'};
      final request = CreateFormulaRequest.fromJson(json);
      expect(request.name, 'Simple Formula');
      expect(request.labels, isNull);
    });

    test('toJson produces correct keys', () {
      const request = CreateFormulaRequest(
        name: 'F',
        labels: ['a'],
      );
      final json = request.toJson();
      expect(json['name'], 'F');
      expect(json['labels'], ['a']);
    });

    test('round-trip preserves values', () {
      const original = CreateFormulaRequest(name: 'n');
      final restored = CreateFormulaRequest.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('UpdateFormulaRequest', () {
    test('fromJson with all fields', () {
      final json = {
        'name': 'Updated Name',
        'labels': ['updated'],
      };
      final request = UpdateFormulaRequest.fromJson(json);
      expect(request.name, 'Updated Name');
      expect(request.labels, ['updated']);
    });

    test('fromJson with no fields', () {
      final json = <String, dynamic>{};
      final request = UpdateFormulaRequest.fromJson(json);
      expect(request.name, isNull);
      expect(request.labels, isNull);
    });

    test('round-trip preserves values', () {
      const original = UpdateFormulaRequest(name: 'n', labels: ['l']);
      final restored = UpdateFormulaRequest.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('AddFormulaItemEntry', () {
    test('fromJson with all fields', () {
      final json = {
        'inventoryId': 'inv-001',
        'quantity': 5,
        'sortOrder': 1,
      };
      final entry = AddFormulaItemEntry.fromJson(json);
      expect(entry.inventoryId, 'inv-001');
      expect(entry.quantity, 5);
      expect(entry.sortOrder, 1);
    });

    test('fromJson with only required fields', () {
      final json = {'inventoryId': 'inv-002'};
      final entry = AddFormulaItemEntry.fromJson(json);
      expect(entry.inventoryId, 'inv-002');
      expect(entry.quantity, isNull);
      expect(entry.sortOrder, isNull);
    });

    test('toJson produces correct keys', () {
      const entry = AddFormulaItemEntry(
        inventoryId: 'inv-001',
        quantity: 3,
        sortOrder: 2,
      );
      final json = entry.toJson();
      expect(json['inventoryId'], 'inv-001');
      expect(json['quantity'], 3);
      expect(json['sortOrder'], 2);
    });

    test('round-trip preserves values', () {
      const original = AddFormulaItemEntry(inventoryId: 'v');
      final restored = AddFormulaItemEntry.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('AddFormulaItemsRequest', () {
    test('fromJson creates instance', () {
      final json = {
        'items': [
          {'inventoryId': 'inv-001', 'quantity': 2},
          {'inventoryId': 'inv-002'},
        ],
      };
      final request = AddFormulaItemsRequest.fromJson(json);
      expect(request.items.length, 2);
      expect(request.items[0].inventoryId, 'inv-001');
      expect(request.items[0].quantity, 2);
      expect(request.items[1].quantity, isNull);
    });

    test('toJson produces correct keys', () {
      const request = AddFormulaItemsRequest(
        items: [AddFormulaItemEntry(inventoryId: 'inv-001')],
      );
      final json = request.toJson();
      expect(json['items'], isList);
      expect((json['items'] as List).length, 1);
    });

    test('round-trip preserves values', () {
      const original = AddFormulaItemsRequest(
        items: [AddFormulaItemEntry(inventoryId: 'v', quantity: 1)],
      );
      final json = jsonDecode(jsonEncode(original.toJson()))
          as Map<String, dynamic>;
      final restored = AddFormulaItemsRequest.fromJson(json);
      expect(restored, original);
    });
  });

  group('UpdateFormulaItemQuantityRequest', () {
    test('fromJson creates instance', () {
      final json = {'quantity': 42};
      final request = UpdateFormulaItemQuantityRequest.fromJson(json);
      expect(request.quantity, 42);
    });

    test('toJson produces correct keys', () {
      const request = UpdateFormulaItemQuantityRequest(quantity: 42);
      final json = request.toJson();
      expect(json['quantity'], 42);
    });

    test('round-trip preserves values', () {
      const original = UpdateFormulaItemQuantityRequest(quantity: 7);
      final restored =
          UpdateFormulaItemQuantityRequest.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('ReorderEntry', () {
    test('fromJson creates instance', () {
      final json = {'itemId': 'item-001', 'sortOrder': 3};
      final entry = ReorderEntry.fromJson(json);
      expect(entry.itemId, 'item-001');
      expect(entry.sortOrder, 3);
    });

    test('toJson produces correct keys', () {
      const entry = ReorderEntry(itemId: 'item-001', sortOrder: 3);
      final json = entry.toJson();
      expect(json['itemId'], 'item-001');
      expect(json['sortOrder'], 3);
    });

    test('round-trip preserves values', () {
      const original = ReorderEntry(itemId: 'i', sortOrder: 0);
      final restored = ReorderEntry.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('ReorderFormulaItemsRequest', () {
    test('fromJson creates instance', () {
      final json = {
        'items': [
          {'itemId': 'item-001', 'sortOrder': 1},
          {'itemId': 'item-002', 'sortOrder': 2},
        ],
      };
      final request = ReorderFormulaItemsRequest.fromJson(json);
      expect(request.items.length, 2);
      expect(request.items[0].itemId, 'item-001');
      expect(request.items[1].sortOrder, 2);
    });

    test('toJson produces correct keys', () {
      const request = ReorderFormulaItemsRequest(
        items: [ReorderEntry(itemId: 'item-001', sortOrder: 1)],
      );
      final json = request.toJson();
      expect(json['items'], isList);
    });

    test('round-trip preserves values', () {
      const original = ReorderFormulaItemsRequest(
        items: [ReorderEntry(itemId: 'i', sortOrder: 0)],
      );
      final json = jsonDecode(jsonEncode(original.toJson()))
          as Map<String, dynamic>;
      final restored = ReorderFormulaItemsRequest.fromJson(json);
      expect(restored, original);
    });
  });
}
