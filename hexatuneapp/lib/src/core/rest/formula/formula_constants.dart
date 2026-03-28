// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:hexatuneapp/src/core/rest/formula/models/formula_item_response.dart';

/// Business rule constants for formula operations.
abstract final class FormulaConstants {
  /// Maximum total quantity allowed across all items in a formula.
  static const int maxTotalQuantity = 30;

  /// Maximum number of unique inventory items allowed in a formula.
  static const int maxUniqueItems = 10;

  /// Maximum number of inventory IDs allowed in a harmonics generate request.
  static const int maxInventorySelection = 10;
}

/// Validation helpers for formula business rules.
abstract final class FormulaValidation {
  /// Calculates the total quantity across all formula items.
  static int totalQuantity(List<FormulaItemResponse> items) {
    return items.fold<int>(0, (sum, item) => sum + item.quantity);
  }

  /// Returns the remaining quantity capacity for a formula.
  static int remainingCapacity(List<FormulaItemResponse> items) {
    return FormulaConstants.maxTotalQuantity - totalQuantity(items);
  }

  /// Checks whether adding [newQuantity] would exceed the max total quantity.
  static bool canAddQuantity(List<FormulaItemResponse> items, int newQuantity) {
    return totalQuantity(items) + newQuantity <=
        FormulaConstants.maxTotalQuantity;
  }

  /// Checks whether updating an item's quantity to [newQuantity] would exceed
  /// the max total quantity.
  static bool canUpdateQuantity(
    List<FormulaItemResponse> items,
    String itemId,
    int newQuantity,
  ) {
    final totalWithout = items
        .where((i) => i.id != itemId)
        .fold<int>(0, (sum, item) => sum + item.quantity);
    return totalWithout + newQuantity <= FormulaConstants.maxTotalQuantity;
  }

  /// Checks whether the given [inventoryId] already exists in the item list.
  static bool isDuplicateInventory(
    List<FormulaItemResponse> items,
    String inventoryId,
  ) {
    return items.any((i) => i.inventoryId == inventoryId);
  }

  /// Checks whether adding another unique item would exceed the limit.
  static bool canAddUniqueItem(List<FormulaItemResponse> items) {
    return items.length < FormulaConstants.maxUniqueItems;
  }
}
