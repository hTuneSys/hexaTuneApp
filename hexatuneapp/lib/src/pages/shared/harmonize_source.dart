// SPDX-FileCopyrightText: 2025 hexaTune LLC
// SPDX-License-Identifier: MIT

import 'package:hexatuneapp/src/core/rest/formula/models/formula_response.dart';
import 'package:hexatuneapp/src/core/rest/inventory/models/inventory_response.dart';

/// Represents the source from which a harmonize session is initiated.
sealed class HarmonizeSource {
  const HarmonizeSource();
}

/// Source from a selected formula (formula list or view page).
class FormulaSource extends HarmonizeSource {
  const FormulaSource({required this.formula});

  final FormulaResponse formula;
}

/// Source from selected inventories (inventory list page).
class InventorySource extends HarmonizeSource {
  const InventorySource({required this.inventories});

  final List<InventoryResponse> inventories;
}

/// Source from a selected flow (future use).
class FlowSource extends HarmonizeSource {
  const FlowSource({required this.flowId});

  final String flowId;
}
