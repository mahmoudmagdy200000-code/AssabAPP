import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/final_daily_close/cashier_breakdown_entity.dart';

import '../../../model/manager_shift_management_models/final_daily_close/cashier_breakdown_model.dart';

extension CashierBreakdownMapper on CashierBreakdownModel {
  CashierBreakdownEntity toEntity() {
    final cash = cashCollected ?? 0.0;
    final card = cardPayments ?? 0.0;
    final delivery = deliveryAppPayments ?? 0.0;
    final total = sales ?? 0.0;

    return CashierBreakdownEntity(
      cashierId: cashierId,
      cashierShiftId: cashierShiftId,
      expectedRevision: expectedRevision,
      cashierName: cashierName,
      cardPayments: card,
      totalSales: total,
      cashCollected: cash,
      deliveryAppPayments: delivery,
      variance: variance ?? 0.0,
      initialCashCollected: cash,
      initialCardPayments: card,
      initialDeliveryAppPayments: delivery,
      initialTotalSales: total,
    );
  }
}
