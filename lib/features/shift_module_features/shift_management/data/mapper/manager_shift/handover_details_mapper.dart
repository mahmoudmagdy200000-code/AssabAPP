import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/handover_details_models/handover_details_item_model.dart';

import '../../../domain/entity/manager_shift/current_shift/handover_details_entity.dart';

extension HandoverDetailsMapper on HandoverDetailsItemModel {
  HandoverDetailsEntity toHandoverDetailsEntity() => HandoverDetailsEntity(
    handoverId: handoverId,
    cashierShiftId: cashierShiftId,
    cashierName: cashierName,
    handoverAmount: handoverAmount,
    handoverDate: handoverDate,
    handoverTime: handoverTime,
    handoverFrom: handoverFrom,
    handoverTo: handoverTo,
    varianceAmount: varianceAmount,
    totalSales: totalSales,
    handoverNotes: handoverNotes,
    handoverStatus: status,
    approvedAt: approvedAt ?? '0000-00-00 00:00:00',
    varianceReason: varianceReason,
    varianceType: varianceType,
  );
}
