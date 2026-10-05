import 'shift_cashier_entity.dart';

class ReassignmentEntity {
  final ShiftCashierEntity? reassignedFrom;
  final ShiftCashierEntity? reassignedBy;
  final ShiftCashierEntity? reassignedTo;

  ReassignmentEntity({
    required this.reassignedFrom,
    required this.reassignedBy,
    required this.reassignedTo,
  });
}
