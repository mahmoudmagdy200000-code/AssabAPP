import '../../../domain/entity/manager_shift/current_shift/cashier_shift_status_breakdown_entity.dart';
import '../../model/manager_shift_management_models/will_be_deleted/cashier_shift_breakdown_model.dart';

extension CashierShiftStatusBreakdownMapper
    on CashierShiftStatusBreakdownModel {
  CashierShiftStatusBreakdownEntity toEntity() =>
      CashierShiftStatusBreakdownEntity(
        notStarted: notStarted,
        inProgress: inProgress,
        completed: completed,
        reassigned: reassigned,
      );
}
