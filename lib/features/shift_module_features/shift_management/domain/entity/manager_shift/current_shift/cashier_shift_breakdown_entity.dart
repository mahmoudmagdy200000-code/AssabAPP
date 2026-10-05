import 'cashier_shift_status_breakdown_entity.dart';
import 'handover_status_breakdown_entity.dart';

class CashierShiftBreakdownEntity {
  final CashierShiftStatusBreakdownEntity byStatus;
  final List<dynamic> byCashier;
  final HandoverStatusBreakdownEntity handoverStatus;

  CashierShiftBreakdownEntity({
    required this.byStatus,
    required this.byCashier,
    required this.handoverStatus,
  });
}
