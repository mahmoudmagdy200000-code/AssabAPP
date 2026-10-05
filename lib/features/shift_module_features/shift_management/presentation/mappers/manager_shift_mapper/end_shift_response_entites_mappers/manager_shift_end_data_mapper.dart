import '../../../../data/model/manager_shift_management_models/end_shift_models/end_shift_response_models/manager_shift_end_data_model.dart';
import '../../../../domain/entity/manager_shift/end_shift_response_entites/final_handover_end_shift_entity.dart';
import '../../../../domain/entity/manager_shift/end_shift_response_entites/manager_shift_end_data_entity.dart';
import 'daily_totals_mapper.dart';
import 'final_handover_mapper.dart';

extension ManagerShiftEndDataMapper on ManagerShiftEndDataModel {
  ManagerShiftEndDataEntity toEntity() {
    return ManagerShiftEndDataEntity(
      finalHandover:
          finalHandover?.toEntity() ??
          const FinalHandoverEndShiftEntity(
            status: 's',
            handoverAmount: 2,
            handoverDate: '2025-10-15',
            handoverFrom: 'sad',
            handoverTime: 'asdas',
            handoverNotes: 'asda',
            handoverTo: 'asd',
          ),
      dailyTotals: dailyTotals!.toEntity(),
    );
  }
}
