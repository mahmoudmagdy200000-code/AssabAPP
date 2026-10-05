import 'package:intl/intl.dart';

class RejectionDetailsEntity {
  final String rejectionReason;
  final int rejectionCount;
  final String firstRejectedAt;
  final String? secondRejectedAt;
  final bool isPermanentlyRejected;
  final bool canCashierEdit;
  final List<String> rejectionFiles;

  const RejectionDetailsEntity({
    required this.rejectionReason,
    required this.rejectionCount,
    required this.firstRejectedAt,
    this.secondRejectedAt,
    required this.isPermanentlyRejected,
    required this.canCashierEdit,
    required this.rejectionFiles,
  });

  String get formattedFirstRejectedAtDateTime {
    final dt = DateTime.tryParse(firstRejectedAt.replaceAll(' ', 'T'));
    if (dt == null) return firstRejectedAt;

    return DateFormat('MMM d, yyyy – h:mm a').format(dt);
  }
}
