enum CashierMyShiftsHandoverStatus {
  pending,
  accepted,
  rejected,
  notStarted,
  noHandover,
}

CashierMyShiftsHandoverStatus cashierMyShiftsHandoverStatusFromJson(
  String? value,
) {
  switch (value) {
    case 'pending':
      return CashierMyShiftsHandoverStatus.pending;

    case 'accepted':
    case 'approved':
      return CashierMyShiftsHandoverStatus.accepted;

    case 'rejected':
      return CashierMyShiftsHandoverStatus.rejected;

    case 'not_started':
      return CashierMyShiftsHandoverStatus.notStarted;

    case 'no_handover':
      return CashierMyShiftsHandoverStatus.noHandover;

    default:
      return CashierMyShiftsHandoverStatus.notStarted;
  }
}
