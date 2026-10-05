import 'package:intl/intl.dart';

class CashierShiftDateFormatter {
  const CashierShiftDateFormatter._();

  static String format(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
}
