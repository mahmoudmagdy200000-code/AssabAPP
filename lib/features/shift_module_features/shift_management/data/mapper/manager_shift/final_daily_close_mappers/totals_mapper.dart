import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/final_daily_close/final_daily_close_model.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/final_daily_close/totals_entity.dart';

extension TotalsMapper on Totals {
  TotalsEntity toEntity() => TotalsEntity(
    totalCashCollected: totalCashCollected ?? 0,
    totalCardPayments: totalCardPayments ?? 0,
    totalDeliveryApps: totalDeliveryApps ?? 0,
    totalVariance: totalVariance ?? 0,
    totalSales: totalSales ?? 0,
  );
}
