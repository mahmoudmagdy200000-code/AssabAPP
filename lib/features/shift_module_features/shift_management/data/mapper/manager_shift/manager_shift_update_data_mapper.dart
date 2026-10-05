import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/end_shift_models/end_shift_response_models/manager_shift_update_data_model.dart';

import '../../../domain/entity/manager_shift/end_shift_response_entites/manager_shift_update_data_entity.dart';
import '../../../presentation/mappers/manager_shift_mapper/end_shift_response_entites_mappers/daily_totals_mapper.dart';
import '../../../presentation/mappers/manager_shift_mapper/end_shift_response_entites_mappers/final_handover_mapper.dart';

extension ManagerShiftUpdateDataMapper on ManagerShiftUpdateDataModel {
  ManagerShiftUpdateDataEntity toEntity() => ManagerShiftUpdateDataEntity(
    shift: shift.toEntity(),
    dailyTotals: dailyTotals.toEntity(),
  );
}

extension ManagerHandoverShiftMapper on ManagerHandoverShiftModel {
  ManagerHandoverShiftEntity toEntity() =>
      ManagerHandoverShiftEntity(finalHandover: finalHandover.toEntity());
}
