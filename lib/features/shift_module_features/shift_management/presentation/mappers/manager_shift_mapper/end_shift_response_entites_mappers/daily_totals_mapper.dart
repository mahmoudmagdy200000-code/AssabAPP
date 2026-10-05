import '../../../../data/model/manager_shift_management_models/end_shift_models/end_shift_response_models/daily_totals_model.dart';
import '../../../../domain/entity/manager_shift/end_shift_response_entites/daily_totals_entity.dart';

extension DailyTotalsMapper on DailyTotalsModel {
  DailyTotalsEntity toEntity() {
    return DailyTotalsEntity(
      totalCashCollected: totalCashCollected ?? 0,
      totalCardPayments: totalCardPayments ?? 0,
      totalDeliveryApps: totalDeliveryApps ?? 0,
      totalVariance: totalVariance ?? 0,
      totalSales: totalSales ?? 0,
      shiftDate: shiftDate ?? '',
    );
  }
}
