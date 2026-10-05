import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/strategies/purchase_source_strategy.dart';
import 'package:flutter/material.dart';

enum PurchaseSourcesTypes {
  non('non'),
  supplier('direct_supplier'),
  officer('via_purchasing_officer'),
  branch('internal_transfer');

  final String _value;

  const PurchaseSourcesTypes(this._value);

  static PurchaseSourcesTypes fromValue(String value) {
    return PurchaseSourcesTypes.values.firstWhere(
      (element) => element._value == value,
      orElse: () => PurchaseSourcesTypes.non,
    );
  }

  @override
  String toString() => _value;

  static PurchaseSourceStrategy getStrategy(PurchaseSourcesTypes type) {
    switch (type) {
      case PurchaseSourcesTypes.supplier:
        return DirectSupplierPurchaseSourceStrategy();
      case PurchaseSourcesTypes.officer:
        return OfficerPurchaseSourceStrategy();
      case PurchaseSourcesTypes.branch:
        return BranchPurchaseSourceStrategy();
      case PurchaseSourcesTypes.non:
        return NonPurchaseSourceStrategy();
    }
  }

  static String formatSourceType(
    BuildContext context,
    PurchaseSourcesTypes type,
  ) {
    switch (type) {
      case PurchaseSourcesTypes.supplier:
        return context.tr.otherSupplier;
      case PurchaseSourcesTypes.officer:
        return context.tr.viaPurchasingOfficer;
      case PurchaseSourcesTypes.branch:
        return context.tr.branchManager;
      case PurchaseSourcesTypes.non:
        return 'N/A';
    }
  }

  String getRejectionType(BuildContext context) {
    switch (this) {
      case PurchaseSourcesTypes.supplier:
        return context.tr.supplier;
      case PurchaseSourcesTypes.officer:
        return context.tr.officer;
      case PurchaseSourcesTypes.branch:
        return context.tr.branchManager;
      case PurchaseSourcesTypes.non:
        return 'N/A';
    }
  }
}
