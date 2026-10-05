import '../../../../domain/entity/manager_shift/current_shift/final_daily_close/AggregatorFinalDailyCloseEntity.dart';
import '../../../model/manager_shift_management_models/final_daily_close/final_daily_close_model.dart';

extension AggregatorFinalDailyCloseMapper on AggregatorFinalDailyCloseModel {
  AggregatorFinalDailyCloseEntity toEntity() => AggregatorFinalDailyCloseEntity(
    id: id,
    name: name,
    logo: logo,
    total: total,
    cashierBreakdown: cashierBreakdown,
  );
}
