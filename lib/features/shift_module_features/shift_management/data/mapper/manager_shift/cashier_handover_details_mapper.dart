import 'package:assab/features/shift_module_features/shift_management/data/mapper/manager_shift/correction_details_mapper.dart';

import '../../../domain/entity/manager_shift/cashier_handover_details_entity/cashier_handover_details_entity.dart';
import '../../model/manager_shift_management_models/cashier_handover_models/cashier_handover_details_model.dart';

extension CashierHandoverDetailsMapper on CashierHandover {
  CashierHandoverDetailsEntity toEntity() => CashierHandoverDetailsEntity(
    cardPayments: cardPayments,
    cashCollected: cashCollected,
    deliveryAppPayments: deliveryAppPayments,
    handoverAmount: handoverAmount,
    handoverDate: handoverDate,
    totalSales: totalSales,
    handoverFrom: cashierName,
    handoverTo: handoverTo,
    handoverTime: handoverTime,
    correctionDetails: correctionDetails?.toEntity(),
    varianceAmount: varianceAmount,
    handoverStatus: status,
    approvedAt: approvedAt,
  );
}
