import '../enums/cashier_my_shifts_handover_status.dart';

class CashierHandoverStatusEntity {
  final CashierMyShiftsHandoverStatus? status;
  final String? reviewedBy;

  const CashierHandoverStatusEntity({this.status, this.reviewedBy});
}
