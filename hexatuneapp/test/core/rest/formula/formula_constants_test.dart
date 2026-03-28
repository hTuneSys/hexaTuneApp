// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:flutter_test/flutter_test.dart';

import 'package:hexatuneapp/src/core/rest/formula/formula_constants.dart';
import 'package:hexatuneapp/src/core/rest/formula/models/formula_item_response.dart';

void main() {
  group('FormulaConstants', () {
    test('maxTotalQuantity is 30', () {
      expect(FormulaConstants.maxTotalQuantity, 30);
    });

    test('maxUniqueItems is 10', () {
      expect(FormulaConstants.maxUniqueItems, 10);
    });

    test('maxInventorySelection is 10', () {
      expect(FormulaConstants.maxInventorySelection, 10);
    });
  });

  group('FormulaValidation', () {
    FormulaItemResponse makeItem(String id, String invId, int qty) {
      return FormulaItemResponse(
        id: id,
        inventoryId: invId,
        sortOrder: 1,
        quantity: qty,
        timeMs: 1000,
        createdAt: '2026-01-01T00:00:00Z',
      );
    }

    group('totalQuantity', () {
      test('returns 0 for empty list', () {
        expect(FormulaValidation.totalQuantity([]), 0);
      });

      test('sums quantities of all items', () {
        final items = [
          makeItem('i1', 'inv1', 10),
          makeItem('i2', 'inv2', 20),
          makeItem('i3', 'inv3', 5),
        ];
        expect(FormulaValidation.totalQuantity(items), 35);
      });

      test('returns single item quantity for one item', () {
        final items = [makeItem('i1', 'inv1', 42)];
        expect(FormulaValidation.totalQuantity(items), 42);
      });
    });

    group('remainingCapacity', () {
      test('returns max for empty list', () {
        expect(
          FormulaValidation.remainingCapacity([]),
          FormulaConstants.maxTotalQuantity,
        );
      });

      test('returns correct remaining capacity', () {
        final items = [makeItem('i1', 'inv1', 10), makeItem('i2', 'inv2', 8)];
        expect(FormulaValidation.remainingCapacity(items), 12);
      });

      test('returns 0 when at capacity', () {
        final items = [makeItem('i1', 'inv1', 30)];
        expect(FormulaValidation.remainingCapacity(items), 0);
      });

      test('returns negative when over capacity', () {
        final items = [makeItem('i1', 'inv1', 35)];
        expect(FormulaValidation.remainingCapacity(items), -5);
      });
    });

    group('canAddQuantity', () {
      test('returns true when under limit', () {
        final items = [makeItem('i1', 'inv1', 10)];
        expect(FormulaValidation.canAddQuantity(items, 5), true);
      });

      test('returns true when exactly at limit', () {
        final items = [makeItem('i1', 'inv1', 20)];
        expect(FormulaValidation.canAddQuantity(items, 10), true);
      });

      test('returns false when exceeding limit', () {
        final items = [makeItem('i1', 'inv1', 25)];
        expect(FormulaValidation.canAddQuantity(items, 6), false);
      });

      test('returns true for empty list with quantity under limit', () {
        expect(FormulaValidation.canAddQuantity([], 30), true);
      });

      test('returns false for empty list with quantity over limit', () {
        expect(FormulaValidation.canAddQuantity([], 31), false);
      });
    });

    group('canUpdateQuantity', () {
      test('returns true when new quantity fits', () {
        final items = [makeItem('i1', 'inv1', 15), makeItem('i2', 'inv2', 10)];
        expect(FormulaValidation.canUpdateQuantity(items, 'i1', 20), true);
      });

      test('returns true when new quantity exactly fills limit', () {
        final items = [makeItem('i1', 'inv1', 5), makeItem('i2', 'inv2', 10)];
        expect(FormulaValidation.canUpdateQuantity(items, 'i1', 20), true);
      });

      test('returns false when new quantity exceeds limit', () {
        final items = [makeItem('i1', 'inv1', 5), makeItem('i2', 'inv2', 10)];
        expect(FormulaValidation.canUpdateQuantity(items, 'i1', 21), false);
      });

      test('ignores target item current quantity in calculation', () {
        final items = [makeItem('i1', 'inv1', 20), makeItem('i2', 'inv2', 5)];
        // Other items total = 5, so max for i1 = 25
        expect(FormulaValidation.canUpdateQuantity(items, 'i1', 25), true);
        expect(FormulaValidation.canUpdateQuantity(items, 'i1', 26), false);
      });
    });

    group('canAddUniqueItem', () {
      test('returns true when under limit', () {
        final items = [makeItem('i1', 'inv1', 1)];
        expect(FormulaValidation.canAddUniqueItem(items), true);
      });

      test('returns true for empty list', () {
        expect(FormulaValidation.canAddUniqueItem([]), true);
      });

      test('returns false when at limit', () {
        final items = List.generate(
          FormulaConstants.maxUniqueItems,
          (i) => makeItem('i$i', 'inv$i', 1),
        );
        expect(FormulaValidation.canAddUniqueItem(items), false);
      });

      test('returns true when one below limit', () {
        final items = List.generate(
          FormulaConstants.maxUniqueItems - 1,
          (i) => makeItem('i$i', 'inv$i', 1),
        );
        expect(FormulaValidation.canAddUniqueItem(items), true);
      });
    });

    group('isDuplicateInventory', () {
      test('returns false for empty list', () {
        expect(FormulaValidation.isDuplicateInventory([], 'inv1'), false);
      });

      test('returns false when inventory not present', () {
        final items = [makeItem('i1', 'inv1', 10)];
        expect(FormulaValidation.isDuplicateInventory(items, 'inv2'), false);
      });

      test('returns true when inventory already exists', () {
        final items = [makeItem('i1', 'inv1', 10)];
        expect(FormulaValidation.isDuplicateInventory(items, 'inv1'), true);
      });

      test('returns true with multiple items', () {
        final items = [
          makeItem('i1', 'inv1', 10),
          makeItem('i2', 'inv2', 20),
          makeItem('i3', 'inv3', 5),
        ];
        expect(FormulaValidation.isDuplicateInventory(items, 'inv2'), true);
        expect(FormulaValidation.isDuplicateInventory(items, 'inv4'), false);
      });
    });
  });
}
