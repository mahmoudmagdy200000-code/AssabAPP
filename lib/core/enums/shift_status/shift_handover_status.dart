enum HandoverStatus { pending, accepted, rejected, notSubmitted }

HandoverStatus handoverStatusFromJson(String? value) {
  switch (value) {
    case 'pending':
    case 'Pending':
      return HandoverStatus.pending;

    case 'accepted':
    case 'approved':
    case 'Approved':
      return HandoverStatus.accepted;

    case 'rejected':
    case 'Rejected':
      return HandoverStatus.rejected;

    case 'notSubmitted':
    case 'NotSubmitted':
    case 'not_submitted':
      return HandoverStatus.notSubmitted;

    default:
      return HandoverStatus.notSubmitted; // safe fallback
  }
}

String handoverStatusToJson(HandoverStatus status) {
  switch (status) {
    case HandoverStatus.pending:
      return 'pending';
    case HandoverStatus.accepted:
      return 'accepted'; // canonical value
    case HandoverStatus.rejected:
      return 'rejected';
    case HandoverStatus.notSubmitted:
      return 'notSubmitted';
  }
}
