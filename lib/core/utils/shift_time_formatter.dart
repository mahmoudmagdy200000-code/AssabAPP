import 'package:intl/intl.dart';

/// Robust, locale-independent 24-hour time parser and localized formatter.
///
/// Prevents the common `FormatException: Trying to read HH from ... at 0`
/// that occurs when `DateFormat('HH:mm').parse()` is invoked while
/// [Intl.defaultLocale] is set to an Arabic locale (e.g. 'ar', 'ar_EG', 'ar_SA').
class ShiftTimeFormatter {
  const ShiftTimeFormatter._();

  static final RegExp _apiClock = RegExp(
    r'^([01]?\d|2[0-3]):([0-5]\d)(?::([0-5]\d))?$',
  );

  /// Parse a 24-hour clock string (e.g. "14:55", "08:00", "14:55:00", "8:00")
  /// safely into a [DateTime] on an arbitrary reference day.
  ///
  /// This parser uses pure ASCII regex matching and never throws [FormatException],
  /// regardless of the current [Intl.defaultLocale].
  static DateTime? parseApiTime(
    String? time, {
    int year = 2000,
    int month = 1,
    int day = 1,
  }) {
    if (time == null) return null;
    final match = _apiClock.firstMatch(time.trim());
    if (match == null) return null;
    final hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    final second = match.group(3) != null ? int.parse(match.group(3)!) : 0;
    return DateTime(year, month, day, hour, minute, second);
  }

  /// Formats an API 24h clock string (e.g. "14:55") into localized 12h display
  /// (e.g. "02:55 PM" in English, "02:55 م" in Arabic).
  ///
  /// Returns [fallback] (default '—') if the time string is null or invalid.
  static String format(String? time24h, {String fallback = '—'}) {
    final parsed = parseApiTime(time24h);
    if (parsed == null) return fallback;
    return DateFormat('hh:mm a').format(parsed);
  }

  /// Calculates total planned duration in minutes between start and end times,
  /// safely accounting for overnight shifts crossing midnight (e.g. 22:00 to 06:00).
  ///
  /// Returns 0 if either time is null or invalid.
  static int plannedMinutes(String? startTime, String? endTime) {
    final start = parseApiTime(startTime);
    final end = parseApiTime(endTime);
    if (start == null || end == null) return 0;

    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    int minutes = endMinutes - startMinutes;
    if (minutes <= 0) {
      minutes += 24 * 60; // overnight shift
    }
    return minutes;
  }
}
