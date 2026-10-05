import '../../../../domain/entity/shift/shift_cashier_entity.dart';
import '../../../../domain/entity/shift/shift_entity.dart';

class ReassignShiftParams {
  final ShiftEntity shift;
  final ShiftCashierEntity? previousCashier;
  final ShiftCashierEntity? nextCashier;

  ReassignShiftParams({
    required this.shift,
    required this.previousCashier,
    required this.nextCashier,
  });
}
