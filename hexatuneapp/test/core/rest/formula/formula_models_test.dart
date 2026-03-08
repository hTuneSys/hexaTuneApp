// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/formula/models/add_formula_item_entry.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/add_formula_items_request.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/create_formula_request.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/formula_detail_response.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/formula_item_response.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/formula_response.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/reorder_entry.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/reorder_formula_items_request.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/update_formula_item_quantity_request.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/update_formula_request.dart';

void main() {
  group('FormulaResponse', () {
    test('fromJson creates instance', () {
      final json = {
        'id': 'frm-001',
        'name': 'Formula',
        'labels': ['a', 'b'],
        'createdAt': '2025-01-01T00:00:00Z',
        'updatedAt': '2025-01-02T00:00:00Z',
      };
      final response = FormulaResponse.fromJson(json);
      expect(response.id, 'frm-001');
      expect(response.name, 'Formula');
      expect(response.labels, ['a', 'b']);
    });

    test('toJson produces correct keys', () {
      const response = FormulaResponse(
        id: 'frm-001',
        name: 'Formula',
        labels: [],
        createdAt: '2025-01-01T00:00:00Z',
        updatedAt: '2025-01-02T00:00:00Z',
      );
      final json = response.toJson();
      expect(json['id'], 'frm-001');
      expect(json['name'], 'Formula');
    });
  });

  group('FormulaDetailResponse', () {
    test('fromJson creates instance with items', () {
      final json = {
        'id': 'frm-001',
        'name': 'Formula',
        'labels': ['a'],
        'items': [
          {
            'id': 'item-001',
            'inventoryId': 'inv-001',
            'sortOrder': 1,
            'quantity': 5,
          },
        ],
        'createdAt': '2025-01-01T00:00:00Z',
        'updatedAt': '2025-01-02T00:00:00Z',
      };
      final response = FormulaDetailResponse.fromJson(json);
      expect(response.items, hasLength(1));
      expect(response.items.first.inventoryId, 'inv-001');
    });
  });

  group('FormulaItemResponse', () {
    test('fromJson creates instance', () {
      final json = {
        'id': 'item-001',
        'inventoryId': 'inv-001',
        'sortOrder': 1,
        'quantity': 10,
      };
      final item = FormulaItemResponse.fromJson(json);
      expect(item.id, 'item-001');
      expect(item.inventoryId, 'inv-001');
      expect(item.sortOrder, 1);
      expect(item.quantity, 10);
    });

    test('toJson produces correct keys', () {
      const item = FormulaItemResponse(
        id: 'item-001',
        inventoryId: 'inv-001',
        sortOrder: 1,
        quantity: 10,
      );
      final json = item.toJson();
      expect(json['id'], 'item-001');
      expect(json['sortOrder'], 1);
    });
  });

  group('CreateFormulaRequest', () {
    test('fromJson creates instance', () {
      final json = {
        'name': 'Formula',
        'labels': ['a'],
      };
      final request = CreateFormulaRequest.fromJson(json);
      expect(request.name, 'Formula');
      expect(request.labels, ['a']);
    });

    test('labels is optional', () {
      const request = CreateFormulaRequest(name: 'Formula');
      expect(request.labels, isNull);
    });
  });

  group('UpdateFormulaRequest', () {
    test('all fields are optional', () {
      const request = UpdateFormulaRequest();
      expect(request.name, isNull);
      expect(request.labels, isNull);
    });
  });

  group('AddFormulaItemEntry', () {
    test('fromJson creates instance', () {
      final json = {'inventoryId': 'inv-001', 'quantity': 5, 'sortOrder': 1};
      final entry = AddFormulaItemEntry.fromJson(json);
      expect(entry.inventoryId, 'inv-001');
      expect(entry.quantity, 5);
      expect(entry.sortOrder, 1);
    });

    test('optional fields default to null', () {
      const entry = AddFormulaItemEntry(inventoryId: 'inv-001');
      expect(entry.quantity, isNull);
      expect(entry.sortOrder, isNull);
    });
  });

  group('AddFormulaItemsRequest', () {
    test('fromJson creates instance with items', () {
      final json = {
        'items': [
          {'inventoryId': 'inv-001'},
        ],
      };
      final request = AddFormulaItemsRequest.fromJson(json);
      expect(request.items, hasLength(1));
      expect(request.items.first.inventoryId, 'inv-001');
    });

    test('toJson produces correct structure', () {
      const request = AddFormulaItemsRequest(
        items: [AddFormulaItemEntry(inventoryId: 'inv-001', quantity: 3)],
      );
      final json = request.toJson();
      expect(json['items'], isList);
      final items = json['items'] as List;
      expect(items.first, isA<AddFormulaItemEntry>());
      expect((items.first as AddFormulaItemEntry).inventoryId, 'inv-001');
    });
  });

  group('ReorderEntry', () {
    test('fromJson creates instance', () {
      final json = {'itemId': 'item-001', 'sortOrder': 2};
      final entry = ReorderEntry.fromJson(json);
      expect(entry.itemId, 'item-001');
      expect(entry.sortOrder, 2);
    });
  });

  group('ReorderFormulaItemsRequest', () {
    test('toJson produces correct structure', () {
      const request = ReorderFormulaItemsRequest(
        items: [ReorderEntry(itemId: 'item-001', sortOrder: 1)],
      );
      final json = request.toJson();
      expect(json['items'], isList);
    });
  });

  group('UpdateFormulaItemQuantityRequest', () {
    test('fromJson creates instance', () {
      final json = {'quantity': 20};
      final request = UpdateFormulaItemQuantityRequest.fromJson(json);
      expect(request.quantity, 20);
    });

    test('toJson produces correct keys', () {
      const request = UpdateFormulaItemQuantityRequest(quantity: 15);
      expect(request.toJson()['quantity'], 15);
    });
  });
}
