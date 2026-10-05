import 'package:assab/features/shift_module_features/shift_management/data/mapper/manager_shift/final_daily_close_mappers/totals_mapper.dart';

import '../../../../domain/entity/manager_shift/current_shift/final_daily_close/final_daily_close_entity.dart';
import '../../../model/manager_shift_management_models/final_daily_close/final_daily_close_model.dart';
import 'cashier_breakdown_mapper.dart';

extension FinalDailyCloseMapper on FinalDailyCloseResponse {
  FinalDailyCloseEntity toEntity() => FinalDailyCloseEntity(
    cashierBreakDowns: data.cashierBreakdown.map((e) => e.toEntity()).toList(),
    totals: data.totals.toEntity(),
  );
}
