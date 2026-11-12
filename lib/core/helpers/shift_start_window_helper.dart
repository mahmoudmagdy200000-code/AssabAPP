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
  /// Evaluates whether a cashier shift is currently within its unified start window:
  /// - Opens 2 hours before scheduled start time
  /// - Closes 2 hours after scheduled end time
  /// - Midnight crossing (end_time <= start_time) automatically extends to the following calendar day
  /// - Accepts String ("YYYY-MM-DD") or DateTime for shiftDate
  static ShiftStartWindowStatus evaluate({
    required dynamic shiftDate,
    required String? startTime,
    required String? endTime,
    DateTime? now,
  }) {
    final current = now ?? DateTime.now();

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

    if (current.isAfter(windowClosesAt)) {
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
