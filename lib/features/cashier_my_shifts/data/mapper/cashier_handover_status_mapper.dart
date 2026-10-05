import 'package:assab/features/cashier_my_shifts/data/model/shifts_models/cashier_handover_status_model.dart';
import 'package:assab/features/cashier_my_shifts/domain/entities/cashier_handover_status_entity.dart';

extension Cashierhandoverstatusmapper on CashierHandoverStatusModel {
  CashierHandoverStatusEntity toEntity() {
    return CashierHandoverStatusEntity(status: status, reviewedBy: reviewedBy);
  }
}
