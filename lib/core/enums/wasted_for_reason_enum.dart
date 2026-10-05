import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

enum WastedForReasonEnum {
  // Wasted Reasons
  productionError('production_error'),
  portionHandlingIssue('portion_handling_issue'),
  orderCancellation('order_cancellation'),
  operationalMismanagement('operational_mismanagement'),

  // Damage Reasons
  expiredProduct('expired_product'),
  storageDamage('storage_damage'),
  supplierIssue('supplier_issue'),
  equipmentFailure('equipment_failure'),

  other('other');

  final String _value;

  const WastedForReasonEnum(this._value);

  String get value => _value;

  static WastedForReasonEnum fromString(String value) {
    return WastedForReasonEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () =>
          throw ArgumentError('Invalid WastedForReasonEnum value: $value'),
    );
  }

  String label(BuildContext context) {
    switch (this) {
      case WastedForReasonEnum.productionError:
        return context.tr.productionPreparationError;
      case WastedForReasonEnum.portionHandlingIssue:
        return context.tr.portionHandlingIssue;
      case WastedForReasonEnum.orderCancellation:
        return context.tr.orderCancellationReturn;
      case WastedForReasonEnum.operationalMismanagement:
        return context.tr.operationalMismanagement;
      case WastedForReasonEnum.expiredProduct:
        return context.tr.expired;
      case WastedForReasonEnum.storageDamage:
        return context.tr.storageTemperatureDamage;
      case WastedForReasonEnum.supplierIssue:
        return context.tr.supplierDeliveryIssue;
      case WastedForReasonEnum.equipmentFailure:
        return context.tr.equipmentFailure;
      case WastedForReasonEnum.other:
        return context.tr.other;
    }
  }
}
