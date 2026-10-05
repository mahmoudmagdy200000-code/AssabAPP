import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/final_daily_close/cashier_breakdown_entity.dart';

import '../../../model/manager_shift_management_models/final_daily_close/cashier_breakdown_model.dart';

extension CashierBreakdownMapper on CashierBreakdownModel {
  CashierBreakdownEntity toEntity() => CashierBreakdownEntity(
    cashierId: cashierId,
    cashierName: cashierName,
    cardPayments: cardPayments ?? 0,
    totalSales: sales ?? 0,
    cashCollected: cashCollected ?? 0,
    deliveryAppPayments: deliveryAppPayments ?? 0,
    variance: variance ?? 0,
  );
}
