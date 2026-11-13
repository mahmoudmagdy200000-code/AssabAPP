import 'package:flutter/material.dart';

class ShiftStartWindowStatus {
  final bool canStart;
  final String? disabledReason;
  final DateTime windowOpensAt;
  final DateTime windowClosesAt;
  final DateTime scheduledStart;
  final DateTime scheduledEnd;

  const ShiftStartWindowStatus({
    required this.canStart,
    this.disabledReason,
    required this.windowOpensAt,
    required this.windowClosesAt,
    required this.scheduledStart,
    required this.scheduledEnd,
  });
}

class ShiftStartWindowHelper {
  static Duration _serverClockSkew = Duration.zero;
  static bool _isSyncedWithServer = false;

  /// Synchronizes local clock with server time (Asia/Riyadh, UTC+3).
  static void syncServerTime(DateTime serverDateTime) {
    final serverUtc = serverDateTime.toUtc();
    final localUtc = DateTime.now().toUtc();
    _serverClockSkew = serverUtc.difference(localUtc);
    _isSyncedWithServer = true;
  }

  /// Explicitly sets clock skew from raw duration if needed (useful for tests).
  @visibleForTesting
  static void setClockSkew(Duration skew) {
    _serverClockSkew = skew;
    _isSyncedWithServer = true;
  }

  /// Resets clock skew back to zero (for clean unit testing).
  @visibleForTesting
  static void resetSync() {
    _serverClockSkew = Duration.zero;
    _isSyncedWithServer = false;
  }

  /// Returns whether server time has been synchronized at least once.
  static bool get isSyncedWithServer => _isSyncedWithServer;

  /// Returns the current synchronized server time in Asia/Riyadh (UTC+3) wall-clock representation.
  static DateTime get now {
    final effectiveUtc = DateTime.now().toUtc().add(_serverClockSkew);
    // Asia/Riyadh is always UTC+3 (no daylight saving time)
    final riyadh = effectiveUtc.add(const Duration(hours: 3));
    return DateTime(
      riyadh.year,
      riyadh.month,
      riyadh.day,
      riyadh.hour,
      riyadh.minute,
      riyadh.second,
      riyadh.millisecond,
    );
  }

  /// Evaluates whether a cashier shift is currently within its unified start window:
  /// - Opens 2 hours before scheduled start time
  /// - Closes 2 hours after scheduled end time (strictly disabled at close timestamp)
  /// - Midnight crossing (end_time <= start_time) automatically extends to the following calendar day
  /// - Accepts String ("YYYY-MM-DD") or DateTime for shiftDate
  static ShiftStartWindowStatus evaluate({
    required dynamic shiftDate,
    required String? startTime,
    required String? endTime,
    DateTime? now,
  }) {
    final current = now ?? ShiftStartWindowHelper.now;

    DateTime? baseDate;
    if (shiftDate is DateTime) {
      baseDate = shiftDate;
    } else if (shiftDate is String && shiftDate.isNotEmpty) {
      baseDate = DateTime.tryParse(shiftDate);
    }
    baseDate ??= current;

    final startParsed = _parseTime(startTime);
    final endParsed = _parseTime(endTime);

    final scheduledStart = DateTime(
      baseDate.year,
      baseDate.month,
      baseDate.day,
      startParsed.hour,
      startParsed.minute,
    );

    var scheduledEnd = DateTime(
      baseDate.year,
      baseDate.month,
      baseDate.day,
      endParsed.hour,
      endParsed.minute,
    );

    // Midnight crossing: when end_time <= start_time, shift ends next day
    if (!scheduledEnd.isAfter(scheduledStart)) {
      scheduledEnd = scheduledEnd.add(const Duration(days: 1));
    }

    final windowOpensAt = scheduledStart.subtract(const Duration(hours: 2));
    final windowClosesAt = scheduledEnd.add(const Duration(hours: 2));

    if (current.isBefore(windowOpensAt)) {
      final opensFormatted = _formatTime(windowOpensAt);
      return ShiftStartWindowStatus(
        canStart: false,
        disabledReason: 'تفتح نافذة البدء الساعة $opensFormatted',
        windowOpensAt: windowOpensAt,
        windowClosesAt: windowClosesAt,
        scheduledStart: scheduledStart,
        scheduledEnd: scheduledEnd,
      );
    }

    if (!current.isBefore(windowClosesAt)) {
      final closesFormatted = _formatTime(windowClosesAt);
      return ShiftStartWindowStatus(
        canStart: false,
        disabledReason: 'انتهت نافذة بدء الوردية (أُغلقت $closesFormatted)',
        windowOpensAt: windowOpensAt,
        windowClosesAt: windowClosesAt,
        scheduledStart: scheduledStart,
        scheduledEnd: scheduledEnd,
      );
    }

    return ShiftStartWindowStatus(
      canStart: true,
      disabledReason: null,
      windowOpensAt: windowOpensAt,
      windowClosesAt: windowClosesAt,
      scheduledStart: scheduledStart,
      scheduledEnd: scheduledEnd,
    );
  }

  /// Returns whether a given shiftDate (DateTime or String "YYYY-MM-DD") falls
  /// strictly within the 7-day rolling window (today through today+6 inclusive)
  /// according to server branch time (Asia/Riyadh, UTC+3).
  static bool isWithin7DayWindow(dynamic shiftDate, {DateTime? referenceNow}) {
    final current = referenceNow ?? ShiftStartWindowHelper.now;
    final today = DateTime(current.year, current.month, current.day);
    final maxDate = DateTime(today.year, today.month, today.day + 6, 23, 59, 59, 999);

    DateTime? targetDate;
    if (shiftDate is DateTime) {
      targetDate = DateTime(shiftDate.year, shiftDate.month, shiftDate.day);
    } else if (shiftDate is String && shiftDate.isNotEmpty) {
      final parsed = DateTime.tryParse(shiftDate);
      if (parsed != null) {
        targetDate = DateTime(parsed.year, parsed.month, parsed.day);
      }
    }

    if (targetDate == null) return false;
    return !targetDate.isBefore(today) && !targetDate.isAfter(maxDate);
  }

  /// Chronologically compares two shifts by date ASC then start time ASC.
  static int compareShiftsChronologically({
    required dynamic dateA,
    required String? startTimeA,
    required dynamic dateB,
    required String? startTimeB,
  }) {
    DateTime? dtA;
    if (dateA is DateTime) {
      dtA = DateTime(dateA.year, dateA.month, dateA.day);
    } else if (dateA is String && dateA.isNotEmpty) {
      dtA = DateTime.tryParse(dateA);
    }

    DateTime? dtB;
    if (dateB is DateTime) {
      dtB = DateTime(dateB.year, dateB.month, dateB.day);
    } else if (dateB is String && dateB.isNotEmpty) {
      dtB = DateTime.tryParse(dateB);
    }

    if (dtA != null && dtB != null) {
      final comp = dtA.compareTo(dtB);
      if (comp != 0) return comp;
    }

    final startA = startTimeA ?? '';
    final startB = startTimeB ?? '';
    return startA.compareTo(startB);
  }

  static TimeOfDay _parseTime(String? timeStr) {
    if (timeStr == null || timeStr.trim().isEmpty || timeStr == 'N/A') {
      return const TimeOfDay(hour: 0, minute: 0);
    }
    final clean = timeStr.trim();
    final parts = clean.split(':');
    if (parts.length >= 2) {
      final h = int.tryParse(parts[0]) ?? 0;
      final m = int.tryParse(parts[1]) ?? 0;
      return TimeOfDay(hour: h.clamp(0, 23), minute: m.clamp(0, 59));
    }
    return const TimeOfDay(hour: 0, minute: 0);
  }

  static String _formatTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
