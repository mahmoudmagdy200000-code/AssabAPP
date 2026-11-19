import 'package:flutter/material.dart';

enum ShiftWindowPhase { beforeOpen, normal, late, expired }

class ShiftStartWindowStatus {
  final bool canStart;
  final bool isLateStart;
  final bool canLateStart;
  final ShiftWindowPhase windowPhase;
  final String? disabledReason;
  final DateTime windowOpensAt;
  final DateTime windowClosesAt;
  final DateTime normalOpensAt;
  final DateTime normalClosesAt;
  final DateTime lateClosesAt;
  final DateTime scheduledStart;
  final DateTime scheduledEnd;

  const ShiftStartWindowStatus({
    required this.canStart,
    this.isLateStart = false,
    this.canLateStart = false,
    this.windowPhase = ShiftWindowPhase.normal,
    this.disabledReason,
    required this.windowOpensAt,
    required this.windowClosesAt,
    DateTime? normalOpensAt,
    DateTime? normalClosesAt,
    DateTime? lateClosesAt,
    required this.scheduledStart,
    required this.scheduledEnd,
  })  : normalOpensAt = normalOpensAt ?? windowOpensAt,
        normalClosesAt = normalClosesAt ?? windowClosesAt,
        lateClosesAt = lateClosesAt ?? windowClosesAt;
}

typedef StartEligibilityResult = ({
  bool canStart,
  bool canStartLate,
  bool isLateStart,
  bool requiresManagerAuthorization,
  String? reason,
  ShiftStartWindowStatus windowStatus,
});

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
    String languageCode = 'ar',
  }) {
    final current = now ?? ShiftStartWindowHelper.now;
    final isEn = languageCode.toLowerCase().startsWith('en');

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
    final normalClosesAt = scheduledStart.add(const Duration(hours: 2));
    final nextMidnight = DateTime(baseDate.year, baseDate.month, baseDate.day + 1);
    final endPlusGrace = scheduledEnd.add(const Duration(hours: 2));
    final lateClosesAt = endPlusGrace.isAfter(nextMidnight) ? endPlusGrace : nextMidnight;
    final effectiveLateClose = normalClosesAt.isAfter(lateClosesAt) ? normalClosesAt : lateClosesAt;

    if (current.isBefore(windowOpensAt)) {
      final opensFormatted = _formatTime(windowOpensAt);
      return ShiftStartWindowStatus(
        canStart: false,
        windowPhase: ShiftWindowPhase.beforeOpen,
        disabledReason: isEn
            ? 'Start window opens at $opensFormatted'
            : 'تفتح نافذة البدء الساعة $opensFormatted',
        windowOpensAt: windowOpensAt,
        windowClosesAt: normalClosesAt,
        normalOpensAt: windowOpensAt,
        normalClosesAt: normalClosesAt,
        lateClosesAt: effectiveLateClose,
        scheduledStart: scheduledStart,
        scheduledEnd: scheduledEnd,
      );
    }

    if (current.isAfter(normalClosesAt)) {
      if (current.isBefore(effectiveLateClose)) {
        final normalClosedFormatted = _formatTime(normalClosesAt);
        return ShiftStartWindowStatus(
          canStart: false,
          isLateStart: true,
          canLateStart: true,
          windowPhase: ShiftWindowPhase.late,
          disabledReason: isEn
              ? 'Starting after the scheduled window (closed at $normalClosedFormatted). Manager authorization may be required.'
              : 'تجاوزت الوردية نافذة البدء الطبيعية (أُغلقت في $normalClosedFormatted)؛ يتطلب البدء المتأخر موافقة مدير الفرع',
          windowOpensAt: windowOpensAt,
          windowClosesAt: normalClosesAt,
          normalOpensAt: windowOpensAt,
          normalClosesAt: normalClosesAt,
          lateClosesAt: effectiveLateClose,
          scheduledStart: scheduledStart,
          scheduledEnd: scheduledEnd,
        );
      }

      final closesFormatted = _formatTime(effectiveLateClose);
      return ShiftStartWindowStatus(
        canStart: false,
        windowPhase: ShiftWindowPhase.expired,
        disabledReason: isEn
            ? 'Shift start window has ended (closed at $closesFormatted)'
            : 'انتهت نافذة بدء الوردية (أُغلقت في $closesFormatted)',
        windowOpensAt: windowOpensAt,
        windowClosesAt: normalClosesAt,
        normalOpensAt: windowOpensAt,
        normalClosesAt: normalClosesAt,
        lateClosesAt: effectiveLateClose,
        scheduledStart: scheduledStart,
        scheduledEnd: scheduledEnd,
      );
    }

    return ShiftStartWindowStatus(
      canStart: true,
      windowPhase: ShiftWindowPhase.normal,
      disabledReason: null,
      windowOpensAt: windowOpensAt,
      windowClosesAt: normalClosesAt,
      normalOpensAt: windowOpensAt,
      normalClosesAt: normalClosesAt,
      lateClosesAt: effectiveLateClose,
      scheduledStart: scheduledStart,
      scheduledEnd: scheduledEnd,
    );
  }

  /// Resolves unified start eligibility using authoritative backend fields first
  /// (consistent across My Shifts List, Shift Details, and Start action), falling
  /// back to local ±2h window evaluation only when server flags are absent.
  static StartEligibilityResult resolveStartEligibility({
    required dynamic shiftDate,
    required String? startTime,
    required String? endTime,
    bool isNextShift = true,
    bool isReassigned = false,
    bool isBranchManager = false,
    bool? serverCanStart,
    bool? serverCanStartLate,
    bool? serverIsLateStart,
    bool? requiresManagerAuthorization,
    String? serverWindowPhase,
    String? serverDisabledReason,
    String? serverDisabledCode,
    DateTime? now,
    String languageCode = 'ar',
  }) {
    final isEn = languageCode.toLowerCase().startsWith('en');
    final windowStatus = evaluate(
      shiftDate: shiftDate,
      startTime: startTime,
      endTime: endTime,
      now: now,
      languageCode: languageCode,
    );

    final resolvedIsLateStart = serverIsLateStart ??
        (serverWindowPhase == 'late' || windowStatus.isLateStart);
    final resolvedCanStartLate =
        serverCanStartLate ?? (isBranchManager && resolvedIsLateStart);
    final resolvedRequiresManagerAuth = requiresManagerAuthorization ??
        (!isBranchManager && resolvedIsLateStart);

    if (isReassigned) {
      return (
        canStart: false,
        canStartLate: false,
        isLateStart: resolvedIsLateStart,
        requiresManagerAuthorization: resolvedRequiresManagerAuth,
        reason: isEn
            ? 'Shift reassignment must be accepted first'
            : 'يجب قبول تكليف الوردية أولاً',
        windowStatus: windowStatus,
      );
    }

    // Backend-authoritative eligibility decision when provided
    if (serverCanStart != null) {
      if (serverCanStart) {
        return (
          canStart: true,
          canStartLate: resolvedCanStartLate,
          isLateStart: resolvedIsLateStart,
          requiresManagerAuthorization: resolvedRequiresManagerAuth,
          reason: null,
          windowStatus: windowStatus,
        );
      }

      return (
        canStart: false,
        canStartLate: resolvedCanStartLate,
        isLateStart: resolvedIsLateStart,
        requiresManagerAuthorization: resolvedRequiresManagerAuth,
        reason: _localizeDisabledReason(
          isEn: isEn,
          code: serverDisabledCode,
          serverReason: serverDisabledReason,
          isNextShift: isNextShift,
          windowStatus: windowStatus,
        ),
        windowStatus: windowStatus,
      );
    }

    // Offline / fallback client evaluation (legacy callers without serverCanStart)
    if (resolvedIsLateStart && isBranchManager && windowStatus.canLateStart) {
      return (
        canStart: true,
        canStartLate: true,
        isLateStart: true,
        requiresManagerAuthorization: false,
        reason: null,
        windowStatus: windowStatus,
      );
    }

    if (!windowStatus.canStart) {
      return (
        canStart: false,
        canStartLate: false,
        isLateStart: resolvedIsLateStart,
        requiresManagerAuthorization: resolvedRequiresManagerAuth,
        reason: windowStatus.disabledReason,
        windowStatus: windowStatus,
      );
    }

    if (!isNextShift) {
      return (
        canStart: false,
        canStartLate: false,
        isLateStart: resolvedIsLateStart,
        requiresManagerAuthorization: resolvedRequiresManagerAuth,
        reason: isEn
            ? 'An earlier active shift must be started first.'
            : 'يجب بدء الوردية السابقة المتاحة أولاً',
        windowStatus: windowStatus,
      );
    }

    return (
      canStart: true,
      canStartLate: resolvedCanStartLate,
      isLateStart: resolvedIsLateStart,
      requiresManagerAuthorization: resolvedRequiresManagerAuth,
      reason: null,
      windowStatus: windowStatus,
    );
  }

  /// Backward-compatible wrapper preserved for existing call sites.
  static ({bool canStart, String? reason, ShiftStartWindowStatus windowStatus})
      resolvePendingStartEligibility({
    required dynamic shiftDate,
    required String? startTime,
    required String? endTime,
    required bool isNextShift,
    bool isReassigned = false,
    bool? serverCanStart,
    String? serverDisabledReason,
    String? serverDisabledCode,
    bool? serverIsLateStart,
    String? serverWindowPhase,
    bool isBranchManager = false,
    DateTime? now,
    String languageCode = 'ar',
  }) {
    final resolved = resolveStartEligibility(
      shiftDate: shiftDate,
      startTime: startTime,
      endTime: endTime,
      isNextShift: isNextShift,
      isReassigned: isReassigned,
      isBranchManager: isBranchManager,
      serverCanStart: serverCanStart,
      serverIsLateStart: serverIsLateStart,
      serverWindowPhase: serverWindowPhase,
      serverDisabledReason: serverDisabledReason,
      serverDisabledCode: serverDisabledCode,
      now: now,
      languageCode: languageCode,
    );
    return (
      canStart: resolved.canStart,
      reason: resolved.reason,
      windowStatus: resolved.windowStatus,
    );
  }

  static String _localizeDisabledReason({
    required bool isEn,
    required String? code,
    required String? serverReason,
    required bool isNextShift,
    required ShiftStartWindowStatus windowStatus,
  }) {
    switch (code) {
      case 'BEFORE_WINDOW':
        return isEn
            ? 'Start window opens at ${_formatTime(windowStatus.normalOpensAt)}'
            : (serverReason ?? 'تفتح نافذة البدء الساعة ${_formatTime(windowStatus.normalOpensAt)}');
      case 'LATE_START_REQUIRES_MANAGER':
        return isEn
            ? 'Starting after the scheduled window. Manager authorization may be required.'
            : (serverReason ??
                'تجاوزت الوردية نافذة البدء الطبيعية؛ يتطلب البدء المتأخر موافقة مدير الفرع');
      case 'PREVIOUS_ACTIVE_SHIFT_PENDING':
        return isEn
            ? 'An earlier active shift must be started first.'
            : (serverReason ?? 'يجب بدء الوردية السابقة المتاحة أولاً');
      case 'WORKDAY_FINALIZED':
        return isEn
            ? 'Cannot start because this workday is finalized.'
            : (serverReason ?? 'لا يمكن بدء الوردية لأن يوم العمل مقفل ومُعتمد');
      case 'SCHEDULE_INACTIVE':
        return isEn
            ? 'This shift belongs to an updated or inactive schedule.'
            : (serverReason ?? 'تنتمي هذه الوردية إلى جدول ورديات محدث أو غير نشط');
      case 'OPERATIONAL_OWNER_ALREADY_ACTIVE':
        return isEn
            ? 'Cannot start because another shift is active.'
            : (serverReason ?? 'لا يمكن بدء الوردية لأن هناك وردية أخرى نشطة حالياً');
      case 'SHIFT_START_WINDOW_EXPIRED':
        return isEn
            ? 'Shift start window has ended (closed at ${_formatTime(windowStatus.lateClosesAt)})'
            : (serverReason ?? 'انتهت نافذة بدء الوردية');
      case 'ASSIGNMENT_ACCEPTANCE_REQUIRED':
        return isEn
            ? 'Shift reassignment must be accepted first'
            : (serverReason ?? 'يجب قبول تكليف الوردية أولاً');
      default:
        if (!isEn && serverReason != null && serverReason.trim().isNotEmpty) {
          return serverReason.trim();
        }
        if (windowStatus.windowPhase == ShiftWindowPhase.beforeOpen ||
            windowStatus.windowPhase == ShiftWindowPhase.late ||
            windowStatus.windowPhase == ShiftWindowPhase.expired) {
          return windowStatus.disabledReason ??
              (isEn ? 'This shift cannot be started yet' : 'تعذّر بدء هذه الوردية حاليًا');
        }
        if (!isNextShift) {
          return isEn
              ? 'An earlier active shift must be started first.'
              : 'يجب بدء الوردية السابقة المتاحة أولاً';
        }
        return isEn
            ? 'This shift cannot be started yet'
            : 'تعذّر بدء هذه الوردية حاليًا';
    }
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
