import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/final_handover_entity.dart';

import '../../model/manager_shift_management_models/final_handover.dart';

extension FinalHandoverMapper on FinalHandover {
  FinalHandoverEntity toEntity() => FinalHandoverEntity(
    handoverAmount: handoverAmount ?? 0,
    status: status,
    handoverFrom: handoverFrom,
    handoverTo: handoverTo,
    handoverDate: handoverDate,
    handoverTime: handoverTime,
    currentTime: currentTime,
    currentTimeSetting: currentTimeSetting,
    handoverNotes: handoverNotes,
    openingBalance: openingBalance ?? 0,
    closingBalance: closingBalance ?? 0,
    expectedBalance: expectedBalance ?? 0,
    variance: variance ?? 0,
    varianceType: varianceType,
    pettyCash: pettyCash ?? 0,
    lastDeposit: lastDeposit ?? 0,
  );
}
