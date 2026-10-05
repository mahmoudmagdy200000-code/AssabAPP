import 'package:intl/intl.dart';

class CashierShiftTimeFormatter {
  const CashierShiftTimeFormatter._();

  static String format(String time) {
    final parsed = DateFormat('HH:mm').parse(time);
    return DateFormat('hh:mm a').format(parsed);
  }
}
