import 'package:intl/intl.dart';

class CashierShiftTimeFormatter {
  const CashierShiftTimeFormatter._();

  static final RegExp _apiClock = RegExp(
    r'^([01]\d|2[0-3]):([0-5]\d)(?::([0-5]\d))?$',
  );

  static DateTime? parseApiTime(String time) {
    final match = _apiClock.firstMatch(time.trim());
    if (match == null) return null;
    return DateTime(
      2000,
      1,
      1,
      int.parse(match.group(1)!),
      int.parse(match.group(2)!),
      int.parse(match.group(3) ?? '0'),
    );
  }

  static String format(String time) {
    final parsed = parseApiTime(time);
    if (parsed == null) return '—';
    return DateFormat('hh:mm a').format(parsed);
  }
}
