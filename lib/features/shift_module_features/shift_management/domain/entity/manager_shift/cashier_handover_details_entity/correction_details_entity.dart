import 'package:intl/intl.dart';

class CorrectionDetailsEntity {
  final String requestedBy;
  final String requestedById;
  final String requestedByType;
  final String? managerComment;
  final String requestedAt;
  final bool canCashierEdit;

  CorrectionDetailsEntity({
    required this.requestedBy,
    required this.requestedById,
    required this.requestedByType,
    required this.managerComment,
    required this.requestedAt,
    required this.canCashierEdit,
  });

  String get formattedRequestedAtDate {
    try {
      final dateTime = DateTime.parse(requestedAt);
      return DateFormat('MMM dd, yyyy - hh:mm a').format(dateTime);
    } catch (_) {
      return '-';
    }
  }
}
