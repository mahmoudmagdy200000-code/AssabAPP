import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/di/dependency_injection.dart';
import '../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../core/helpers/shared_preferences_helper.dart';
import '../../../../../../core/network/api_endpoints.dart';
import '../../../../../../core/styles/app_colors.dart';
import '../../../../../../core/styles/app_styles.dart';
import '../../../../../../core/widgets/app_back_button.dart';
import '../../../../../../core/widgets/app_scaffold.dart';

/// Resolve the effective recurring owner for the card's business date.
Map<String, dynamic>? recurringAssignmentForDate(
  List<Map<String, dynamic>> assignments,
  String date,
) {
  String? day(dynamic value) {
    final text = value?.toString();
    return text != null && text.length >= 10 ? text.substring(0, 10) : null;
  }

  Map<String, dynamic>? selected;
  for (final item in assignments) {
    final from = day(item['effective_from']);
    final to = day(item['effective_to']);
    if (from == null ||
        from.compareTo(date) > 0 ||
        (to != null && to.compareTo(date) < 0)) {
      continue;
    }
    if (selected == null ||
        from.compareTo(day(selected['effective_from'])!) > 0) {
      selected = item;
    }
  }
  return selected;
}

/// Data class representing a template slot for dated assignment
class DatedTemplateSlot {
  final String templateId;
  final String templateName;
  final String startTime;
  final String endTime;
  final String shiftDate;
  final String? cashierShiftId;
  final String? cashierId;
  final String? cashierName;
  final String status; // 'not_started', 'in_progress', 'completed'
  final bool hasFinancialEvidence;
  final String? primaryCashierId;
  final String? primaryCashierName;
  final String? primaryEffectiveFrom;
  final String? primaryEffectiveTo;
  final bool isRecurringPrimary;

  const DatedTemplateSlot({
    required this.templateId,
    required this.templateName,
    required this.startTime,
    required this.endTime,
    this.shiftDate = '2026-11-15',
    this.cashierShiftId,
    this.cashierId,
    this.cashierName,
    this.status = 'not_started',
    this.hasFinancialEvidence = false,
    this.primaryCashierId,
    this.primaryCashierName,
    this.primaryEffectiveFrom,
    this.primaryEffectiveTo,
    this.isRecurringPrimary = false,
  });

  bool get isProtected => status != 'not_started' || hasFinancialEvidence;
  bool get hasActualShift => cashierShiftId?.isNotEmpty == true;
  bool get isAssigned => hasActualShift && cashierId?.isNotEmpty == true;
  bool get isPlanned => !hasActualShift && primaryCashierId != null;

  DatedTemplateSlot copyWith({
    String? templateId,
    String? templateName,
    String? startTime,
    String? endTime,
    String? shiftDate,
    String? cashierShiftId,
    String? cashierId,
    String? cashierName,
    String? status,
    bool? hasFinancialEvidence,
    String? primaryCashierId,
    String? primaryCashierName,
    String? primaryEffectiveFrom,
    String? primaryEffectiveTo,
    bool? isRecurringPrimary,
  }) {
    return DatedTemplateSlot(
      templateId: templateId ?? this.templateId,
      templateName: templateName ?? this.templateName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      shiftDate: shiftDate ?? this.shiftDate,
      cashierShiftId: cashierShiftId ?? this.cashierShiftId,
      cashierId: cashierId ?? this.cashierId,
      cashierName: cashierName ?? this.cashierName,
      status: status ?? this.status,
      hasFinancialEvidence: hasFinancialEvidence ?? this.hasFinancialEvidence,
      primaryCashierId: primaryCashierId ?? this.primaryCashierId,
      primaryCashierName: primaryCashierName ?? this.primaryCashierName,
      primaryEffectiveFrom: primaryEffectiveFrom ?? this.primaryEffectiveFrom,
      primaryEffectiveTo: primaryEffectiveTo ?? this.primaryEffectiveTo,
      isRecurringPrimary: isRecurringPrimary ?? this.isRecurringPrimary,
    );
  }
}

/// Screen providing branch manager dated cashier assignment (P4a / P4b)
class DatedShiftAssignmentScreen extends StatefulWidget {
  final Dio? dio;
  final List<DatedTemplateSlot>? initialTemplates;
  final String? initialDateRange;
  final String? branchBusinessDate;
  final Future<List<DatedTemplateSlot>> Function(
    String startDate,
    String endDate,
  )?
  onFetchRoster;
  final Future<void> Function(
    String cashierAId,
    String shiftAId,
    String cashierBId,
    String shiftBId,
    String shiftDate,
    bool forFullWeek,
  )?
  onExecuteSwap;
  final Future<void> Function(
    String cashierId,
    String shiftId,
    String shiftDate,
  )?
  onExecuteAssign;
  final Future<void> Function(
    String cashierId,
    String shiftId,
    String effectiveFrom,
  )?
  onSaveRosterAssignment;
  final Future<List<Map<String, dynamic>>> Function()? onFetchRosterAssignments;
  final Future<List<Map<String, dynamic>>> Function()? onFetchAvailableCashiers;
  final Future<Map<String, String>> Function()? onFetchSchedulingRange;
  final void Function(String templateA, String templateB)? onSwapCompleted;
  final String? initialScheduleSourceLabel;

  const DatedShiftAssignmentScreen({
    super.key,
    this.dio,
    this.initialTemplates,
    this.initialDateRange,
    this.branchBusinessDate,
    this.onFetchRoster,
    this.onExecuteSwap,
    this.onExecuteAssign,
    this.onSaveRosterAssignment,
    this.onFetchRosterAssignments,
    this.onFetchAvailableCashiers,
    this.onFetchSchedulingRange,
    this.onSwapCompleted,
    this.initialScheduleSourceLabel,
  });

  @override
  State<DatedShiftAssignmentScreen> createState() =>
      _DatedShiftAssignmentScreenState();
}

class _DatedShiftAssignmentScreenState
    extends State<DatedShiftAssignmentScreen> {
  late List<DatedTemplateSlot> _templates;
  String _startDate = '2026-11-15';
  String _endDate = '2026-11-21';
  String _selectedDate = '2026-11-15';
  String? _serverToday;
  bool _hasUserSelectedDay = false;
  DatedTemplateSlot? _selectedSlotForSwap;
  String? _statusMessage;
  bool _isLoading = false;
  bool _isManuallySelected = false;
  bool _hasLoadError = false;
  String? _scheduleSourceLabel;

  @visibleForTesting
  String? get scheduleSourceLabel => _scheduleSourceLabel;

  Dio? get _effectiveDio =>
      widget.dio ?? (getIt.isRegistered<Dio>() ? getIt<Dio>() : null);

  Map<String, List<Map<String, dynamic>>> _recurringRosterByShift = {};
  @visibleForTesting
  Map<String, List<Map<String, dynamic>>> get recurringRosterByShift =>
      _recurringRosterByShift;

  static String _formatYmd(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  static DateTime? _parseYmdUtc(String ymd) {
    final normalized = ymd.trim();
    if (normalized.length < 10) return null;
    final parts = normalized.substring(0, 10).split('-');
    if (parts.length != 3) return null;
    final y = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final d = int.tryParse(parts[2]);
    if (y == null || m == null || d == null) return null;
    return DateTime.utc(y, m, d);
  }

  static String _addDaysYmd(String ymd, int days) {
    final parsed =
        _parseYmdUtc(ymd) ??
        () {
          final r = DateTime.now().toUtc().add(const Duration(hours: 3));
          return DateTime.utc(r.year, r.month, r.day);
        }();
    return _formatYmd(parsed.add(Duration(days: days)));
  }

  static String _arabicWeekdayName(String ymd) {
    final dt = _parseYmdUtc(ymd);
    if (dt == null) return '';
    switch (dt.weekday) {
      case DateTime.monday:
        return 'الإثنين';
      case DateTime.tuesday:
        return 'الثلاثاء';
      case DateTime.wednesday:
        return 'الأربعاء';
      case DateTime.thursday:
        return 'الخميس';
      case DateTime.friday:
        return 'الجمعة';
      case DateTime.saturday:
        return 'السبت';
      case DateTime.sunday:
        return 'الأحد';
      default:
        return '';
    }
  }

  static String _formatArabicDayHeader(String ymd) {
    final dayName = _arabicWeekdayName(ymd);
    return dayName.isNotEmpty ? '$dayName، $ymd' : ymd;
  }

  static String _formatShiftCountAr(int count) {
    if (count <= 0) return 'لا توجد ورديات';
    if (count == 1) return 'وردية واحدة';
    if (count == 2) return 'ورديتان';
    if (count <= 10) return '$count ورديات';
    return '$count وردية';
  }

  static DateTime _computeCurrentWeekSunday([DateTime? ref]) {
    final now = ref ?? DateTime.now();
    final daysToSubtract = now.weekday % 7; // Sunday is 7, 7 % 7 = 0
    return DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: daysToSubtract));
  }

  String get _todayYmd {
    final server = _serverToday;
    if (server != null && server.length >= 10) {
      return server.substring(0, 10);
    }
    final branch = widget.branchBusinessDate?.trim();
    if (branch != null && branch.length >= 10) {
      return branch.substring(0, 10);
    }
    return _formatYmd(DateTime.now().toUtc().add(const Duration(hours: 3)));
  }

  String _resolveSelectedDate(
    List<DatedTemplateSlot> slots, {
    String? preferredDate,
  }) {
    final days = slots.map((s) => s.shiftDate).toSet().toList()..sort();
    if (days.isEmpty) {
      if (preferredDate != null) return preferredDate;
      if (!_hasUserSelectedDay &&
          !_isManuallySelected &&
          widget.initialDateRange == null) {
        final today = _todayYmd;
        if (today.compareTo(_startDate) >= 0 &&
            today.compareTo(_endDate) <= 0) {
          return today;
        }
      }
      return _selectedDate.isNotEmpty ? _selectedDate : _startDate;
    }
    if (preferredDate != null && days.contains(preferredDate)) {
      return preferredDate;
    }
    if (!_hasUserSelectedDay &&
        !_isManuallySelected &&
        widget.initialDateRange == null) {
      final today = _todayYmd;
      if (days.contains(today)) return today;
      if (days.contains(_selectedDate)) return _selectedDate;
      return days.first;
    }
    if (days.contains(_selectedDate)) return _selectedDate;
    if (days.contains(_startDate)) return _startDate;
    return days.first;
  }

  @override
  void initState() {
    super.initState();
    _scheduleSourceLabel = widget.initialScheduleSourceLabel;
    final rangeStr = widget.initialDateRange;
    if (rangeStr != null) {
      _isManuallySelected = true;
      final match = RegExp(
        r'(\d{4}-\d{2}-\d{2})\s*[\u2014\u2013\u002d-]\s*(\d{4}-\d{2}-\d{2})',
      ).firstMatch(rangeStr);
      if (match != null) {
        _startDate = match.group(1)!;
        _endDate = match.group(2)!;
      }
      _selectedDate = _startDate;
    } else {
      _isManuallySelected = false;
      final ref = widget.branchBusinessDate != null
          ? DateTime.tryParse(widget.branchBusinessDate!)
          : DateTime.now().toUtc().add(const Duration(hours: 3));
      final sun = _computeCurrentWeekSunday(ref);
      final sat = sun.add(const Duration(days: 6));
      _startDate = _formatYmd(sun);
      _endDate = _formatYmd(sat);
      _selectedDate = _todayYmd;
    }

    if (widget.initialTemplates != null) {
      _templates = List.from(widget.initialTemplates!);
      _selectedDate = _resolveSelectedDate(_templates);
    } else {
      _templates = [];
      if (widget.onFetchRoster == null && _effectiveDio == null) {
        _statusMessage = 'تعذر الاتصال: لم يتم العثور على مزود خدمة API.';
      }
    }

    if (widget.onFetchRoster != null || _effectiveDio != null) {
      _loadRoster();
    }
  }

  Future<void> _loadRoster({String? preferredDate}) async {
    setState(() {
      _isLoading = true;
      _selectedSlotForSwap = null;
      _hasLoadError = false;
    });

    if (widget.onFetchRoster != null) {
      try {
        if (!_isManuallySelected &&
            widget.initialDateRange == null &&
            widget.onFetchSchedulingRange != null) {
          final range = await widget.onFetchSchedulingRange!();
          if (range['today'] != null && range['today']!.length >= 10) {
            _serverToday = range['today']!.substring(0, 10);
          }
          if (range['start_date'] != null && range['end_date'] != null) {
            _startDate = range['start_date']!;
            _endDate = range['end_date']!;
          }
        }
        final slots = await widget.onFetchRoster!(_startDate, _endDate);
        if (mounted) {
          setState(() {
            _templates = slots;
            _selectedDate = _resolveSelectedDate(
              slots,
              preferredDate: preferredDate,
            );
            _isLoading = false;
            _statusMessage = null;
            _hasLoadError = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _statusMessage = e is StateError
                ? e.message.toString()
                : 'تعذر تحميل التعيينات من الخادم. أعد المحاولة.';
            _isLoading = false;
            _hasLoadError = true;
          });
        }
      }
      return;
    }

    if (_effectiveDio != null) {
      try {
        final queryParams = <String, dynamic>{};
        if (_isManuallySelected || widget.initialDateRange != null) {
          queryParams['start_date'] = _startDate;
          queryParams['end_date'] = _endDate;
        }

        Response response;
        try {
          response = await _effectiveDio!.get(
            '${ApiEndpoint.branchManagerCashiers}/dated-roster',
            queryParameters: queryParams.isNotEmpty ? queryParams : null,
          );
        } on DioException catch (dioErr) {
          // Backward compatibility fallback: if older server requires start_date & end_date (422 Unprocessable)
          if (queryParams.isEmpty && dioErr.response?.statusCode == 422) {
            final errBody = dioErr.response?.data?.toString() ?? '';
            if (errBody.contains('start_date') ||
                errBody.contains('end_date')) {
              response = await _effectiveDio!.get(
                '${ApiEndpoint.branchManagerCashiers}/dated-roster',
                queryParameters: {
                  'start_date': _startDate,
                  'end_date': _endDate,
                },
              );
            } else {
              rethrow;
            }
          } else {
            rethrow;
          }
        }

        final data = response.data['data'] as Map<String, dynamic>? ?? {};

        // Extract schedule source metadata (branch override vs brand inheritance)
        if (data['schedule_source'] is Map) {
          final src = data['schedule_source'] as Map;
          final labelAr = src['label_ar']?.toString();
          final ownerName = src['owner_name']?.toString();
          if (labelAr != null && ownerName != null && ownerName.isNotEmpty) {
            _scheduleSourceLabel = '$labelAr ($ownerName)';
          } else if (labelAr != null) {
            _scheduleSourceLabel = labelAr;
          }
        }

        if (data['scheduling_calendar'] is Map) {
          final serverTodayRaw =
              data['scheduling_calendar']['today']?.toString().trim();
          if (serverTodayRaw != null && serverTodayRaw.length >= 10) {
            _serverToday = serverTodayRaw.substring(0, 10);
          }
        }

        // If the manager has not manually navigated, adopt the server-driven scheduling calendar
        if (!_isManuallySelected && widget.initialDateRange == null) {
          final serverStart =
              data['start_date']?.toString() ??
              (data['scheduling_calendar'] is Map
                  ? data['scheduling_calendar']['default_start_date']
                        ?.toString()
                  : null);
          final serverEnd =
              data['end_date']?.toString() ??
              (data['scheduling_calendar'] is Map
                  ? data['scheduling_calendar']['default_end_date']?.toString()
                  : null);
          if (serverStart != null && serverEnd != null) {
            _startDate = serverStart;
            _endDate = serverEnd;
          }
        }

        final templatesList = data['templates'] as List<dynamic>? ?? [];
        final rawRoster = data['roster'];
        final Map<String, dynamic> rosterMap = rawRoster is Map<String, dynamic>
            ? rawRoster
            : (rawRoster is Map ? rawRoster.cast<String, dynamic>() : {});

        // A failed recurring-roster read must not look like an empty roster.
        // Publish both responses together so previous data stays intact on failure.
        final List<dynamic> recurringRows;
        try {
          if (widget.onFetchRosterAssignments != null) {
            recurringRows = await widget.onFetchRosterAssignments!();
          } else {
            final result = await _effectiveDio!.get(
              '${ApiEndpoint.branchManagerCashiers}/roster-assignments',
            );
            recurringRows = result.data['data'] as List<dynamic>;
          }
        } catch (_) {
          throw StateError(
            'تعذر تحميل التعيين الأساسي المتكرر. أعد المحاولة قبل التعديل.',
          );
        }
        final recurring = <String, List<Map<String, dynamic>>>{};
        for (final row in recurringRows) {
          final item = Map<String, dynamic>.from(row as Map);
          final shiftId =
              item['shift_id']?.toString() ??
              (item['shift'] as Map?)?['id']?.toString();
          if (shiftId == null) continue;
          final cashier = item['cashier'] as Map?;
          recurring.putIfAbsent(shiftId, () => []).add({
            ...item,
            'cashier_id':
                item['cashier_id']?.toString() ?? cashier?['id']?.toString(),
            'cashier_name':
                cashier?['name']?.toString() ??
                item['cashier_name']?.toString(),
          });
        }

        // Generate all dates in the requested range [_startDate, _endDate]
        final List<String> allDates = [];
        try {
          final start = DateTime.parse(_startDate);
          final end = DateTime.parse(_endDate);
          var curr = start;
          while (!curr.isAfter(end)) {
            final dStr =
                "${curr.year}-${curr.month.toString().padLeft(2, '0')}-${curr.day.toString().padLeft(2, '0')}";
            allDates.add(dStr);
            curr = curr.add(const Duration(days: 1));
          }
        } catch (_) {
          allDates.add(_startDate);
        }

        for (final key in rosterMap.keys) {
          final parts = key.toString().split('_');
          if (parts.isNotEmpty && !allDates.contains(parts[0])) {
            allDates.add(parts[0]);
          }
        }
        allDates.sort();

        final List<DatedTemplateSlot> parsedSlots = [];

        // If templatesList is empty for this branch, parsedSlots remains empty leading to empty_roster_state
        if (templatesList.isNotEmpty) {
          for (final dateStr in allDates) {
            for (final t in templatesList) {
              final tId = t['id'].toString();
              final tName = t['name']?.toString() ?? 'قالب وردية';
              final sTime = (t['start_time']?.toString() ?? '08:00:00')
                  .substring(0, 5);
              final eTime = (t['end_time']?.toString() ?? '16:00:00').substring(
                0,
                5,
              );

              final key = '${dateStr}_$tId';
              final rEntry = rosterMap[key] as Map<String, dynamic>?;
              final isAssigned = rEntry?['cashier_id'] != null;
              final primary = recurringAssignmentForDate(
                recurring[tId] ?? [],
                dateStr,
              );
              final primaryCashierId = primary?['cashier_id']?.toString();
              final primaryCashierName = primary?['cashier_name']?.toString();
              final rawEffFrom = primary?['effective_from']?.toString().trim();
              final primaryEffectiveFrom =
                  rawEffFrom != null && rawEffFrom.length >= 10
                      ? rawEffFrom.substring(0, 10)
                      : rawEffFrom;
              final rawEffTo = primary?['effective_to']?.toString().trim();
              final primaryEffectiveTo =
                  rawEffTo != null && rawEffTo.length >= 10
                      ? rawEffTo.substring(0, 10)
                      : (rawEffTo?.isEmpty == true ? null : rawEffTo);
              final effectiveCashierId = rEntry?['cashier_id']?.toString();
              final effectiveCashierName = rEntry?['cashier_name']?.toString();
              final isRecurringPrimary =
                  primaryCashierId != null &&
                  primaryCashierId == effectiveCashierId;

              parsedSlots.add(
                DatedTemplateSlot(
                  templateId: tId,
                  templateName: tName,
                  startTime: sTime,
                  endTime: eTime,
                  shiftDate: dateStr,
                  cashierShiftId:
                      rEntry?['cashier_shift_id']?.toString() ??
                      rEntry?['id']?.toString(),
                  cashierId: effectiveCashierId,
                  cashierName: effectiveCashierName,
                  status: rEntry?['status']?.toString() ?? 'not_started',
                  hasFinancialEvidence:
                      rEntry?['has_financial_evidence'] as bool? ??
                      (!(rEntry?['can_swap'] as bool? ?? true) &&
                          isAssigned &&
                          rEntry?['status'] == 'not_started'),
                  primaryCashierId: primaryCashierId,
                  primaryCashierName: primaryCashierName,
                  primaryEffectiveFrom: primaryEffectiveFrom,
                  primaryEffectiveTo: primaryEffectiveTo,
                  isRecurringPrimary: isRecurringPrimary,
                ),
              );
            }
          }
        }

        if (mounted) {
          setState(() {
            _templates = parsedSlots;
            _recurringRosterByShift = recurring;
            _selectedDate = _resolveSelectedDate(
              parsedSlots,
              preferredDate: preferredDate,
            );
            _isLoading = false;
            _statusMessage = null;
            _hasLoadError = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _statusMessage = e is StateError
                ? e.message.toString()
                : 'تعذر تحميل التعيينات من الخادم. أعد المحاولة.';
            _isLoading = false;
            _hasLoadError = true;
          });
        }
      }
    }
  }

  Future<void> _pickRosterStartDate() async {
    if (_isLoading) return;
    final parsed = _parseYmdUtc(_selectedDate) ?? _parseYmdUtc(_startDate);
    if (parsed == null) return;
    final current = DateTime(parsed.year, parsed.month, parsed.day);
    final selected = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(current.year - 10),
      lastDate: DateTime(current.year + 10, 12, 31),
      helpText: 'اختر تاريخ الورديات',
    );
    if (!mounted || selected == null || _isLoading) return;
    final pickedStr = _formatYmd(selected);
    if (pickedStr.compareTo(_startDate) >= 0 &&
        pickedStr.compareTo(_endDate) <= 0 &&
        _distinctDays.contains(pickedStr)) {
      setState(() {
        _hasUserSelectedDay = true;
        _selectedDate = pickedStr;
        _selectedSlotForSwap = null;
        _statusMessage = null;
        _hasLoadError = false;
      });
      return;
    }
    final rangeStart = _parseYmdUtc(_startDate) ?? parsed;
    // Calendar arithmetic must not depend on DST-length local days.
    final days = DateTime.utc(selected.year, selected.month, selected.day)
        .difference(rangeStart)
        .inDays;
    _shiftDateRange(days, targetDate: pickedStr);
  }

  void _shiftDateRange(int days, {String? targetDate}) {
    try {
      final sStr = _addDaysYmd(_startDate, days);
      final eStr = _addDaysYmd(_endDate, days);
      final nextSelected = targetDate ?? sStr;

      setState(() {
        _isManuallySelected = true;
        _hasUserSelectedDay = true;
        _startDate = sStr;
        _endDate = eStr;
        _selectedDate = nextSelected;
        _selectedSlotForSwap = null;
        _statusMessage = null;
        _hasLoadError = false;
      });

      _loadRoster(preferredDate: nextSelected);
    } catch (_) {}
  }

  void _stepDay(int deltaDays) {
    if (_isLoading) return;
    final target = _addDaysYmd(_selectedDate, deltaDays);
    if (!_hasLoadError &&
        target.compareTo(_startDate) >= 0 &&
        target.compareTo(_endDate) <= 0 &&
        (_distinctDays.contains(target) || _templates.isEmpty)) {
      setState(() {
        _hasUserSelectedDay = true;
        _selectedDate = target;
        _selectedSlotForSwap = null;
        _statusMessage = null;
      });
      return;
    }
    _shiftDateRange(deltaDays > 0 ? 7 : -7, targetDate: target);
  }

  void _jumpToToday() {
    if (_isLoading) return;
    final today = _todayYmd;
    if (!_hasLoadError &&
        today.compareTo(_startDate) >= 0 &&
        today.compareTo(_endDate) <= 0 &&
        (_distinctDays.contains(today) || _templates.isEmpty)) {
      setState(() {
        _hasUserSelectedDay = false;
        _selectedDate = today;
        _selectedSlotForSwap = null;
        _statusMessage = null;
      });
      return;
    }
    final parsed = _parseYmdUtc(today);
    if (parsed == null) return;
    final sun = _computeCurrentWeekSunday(
      DateTime(parsed.year, parsed.month, parsed.day),
    );
    final sat = sun.add(const Duration(days: 6));
    setState(() {
      _hasUserSelectedDay = false;
      _isManuallySelected =
          widget.initialDateRange != null || widget.onFetchRoster != null;
      _startDate = _formatYmd(sun);
      _endDate = _formatYmd(sat);
      _selectedDate = today;
      _selectedSlotForSwap = null;
      _statusMessage = null;
      _hasLoadError = false;
    });
    _loadRoster(preferredDate: today);
  }

  List<String> get _distinctDays {
    final Set<String> days = {};
    for (final slot in _templates) {
      days.add(slot.shiftDate);
    }
    final sorted = days.toList()..sort();
    return sorted;
  }

  List<DatedTemplateSlot> get _filteredTemplates {
    return _templates
        .where((slot) => slot.shiftDate == _selectedDate)
        .toList();
  }

  String _extractDioErrorMessage(
    DioException e, {
    required String defaultAction,
  }) {
    final response = e.response;
    if (response != null) {
      final statusCode = response.statusCode;
      final data = response.data;
      if (data is Map) {
        final err = data['error'];
        if (err is Map) {
          final msgAr = err['messageAr']?.toString();
          if (msgAr != null && msgAr.trim().isNotEmpty) {
            return '$defaultAction: $msgAr';
          }
          final msgEn = err['message']?.toString();
          if (msgEn != null && msgEn.trim().isNotEmpty) {
            return '$defaultAction: $msgEn';
          }
        }
        final directMsg = data['message']?.toString();
        if (directMsg != null && directMsg.trim().isNotEmpty) {
          return '$defaultAction: $directMsg';
        }
        final errors = data['errors'];
        if (errors is Map && errors.isNotEmpty) {
          final firstVal = errors.values.first;
          if (firstVal is List && firstVal.isNotEmpty) {
            return '$defaultAction: ${firstVal.first}';
          }
          return '$defaultAction: ${firstVal.toString()}';
        }
      }
      if (statusCode == 500) {
        return '$defaultAction: خطأ غير متوقع في خادم النظام (500). يرجى مراجعة إعدادات قاعدة البيانات.';
      } else if (statusCode == 403 || statusCode == 401) {
        return '$defaultAction: لا تملك الصلاحية الكافية لتنفيذ هذا الإجراء ($statusCode).';
      } else if (statusCode == 422) {
        return '$defaultAction: البيانات المدخلة غير صحيحة أو غير مقبولة (422).';
      } else if (statusCode != null) {
        return '$defaultAction: استجاب الخادم برمز خطأ ($statusCode).';
      }
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return '$defaultAction: انتهت مهلة الاتصال بالخادم. يرجى التحقق من الشبكة.';
    }
    if (e.type == DioExceptionType.connectionError) {
      return '$defaultAction: تعذر الاتصال بالخادم. يرجى التحقق من الشبكة.';
    }

    return '$defaultAction: ${e.message ?? 'خطأ في الاتصال بالخادم.'}';
  }

  Future<void> _executeAtomicSwap(
    DatedTemplateSlot itemA,
    DatedTemplateSlot itemB,
  ) async {
    final idxA = _templates.indexWhere(
      (t) => t.templateId == itemA.templateId && t.shiftDate == itemA.shiftDate,
    );
    final idxB = _templates.indexWhere(
      (t) => t.templateId == itemB.templateId && t.shiftDate == itemB.shiftDate,
    );

    if (idxA == -1 || idxB == -1) return;

    if (!itemA.isAssigned ||
        !itemB.isAssigned ||
        itemA.isProtected ||
        itemB.isProtected ||
        _hasLoadError) {
      setState(() {
        _selectedSlotForSwap = null;
        _statusMessage =
            'تعذر التبديل: إحدى الورديات نشطة أو تحتوي على قيود مالية محمية.';
      });
      return;
    }

    if (widget.onExecuteSwap != null) {
      setState(() => _isLoading = true);
      try {
        await widget.onExecuteSwap!(
          itemA.cashierId ?? '',
          itemA.templateId,
          itemB.cashierId ?? '',
          itemB.templateId,
          itemA.shiftDate,
          false,
        );

        if (mounted) {
          setState(() {
            _templates[idxA] = itemA.copyWith(
              cashierId: itemB.cashierId,
              cashierName: itemB.cashierName,
            );
            _templates[idxB] = itemB.copyWith(
              cashierId: itemA.cashierId,
              cashierName: itemA.cashierName,
            );
            _selectedSlotForSwap = null;
            _statusMessage =
                'تم تبديل الكاشيرين بنجاح وحفظ السجل المؤرّخ ذرياً.';
            _isLoading = false;
          });
          widget.onSwapCompleted?.call(itemA.templateId, itemB.templateId);
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _selectedSlotForSwap = null;
            _statusMessage =
                'تعذر التبديل: ${e.toString().replaceAll("Exception: ", "")}';
            _isLoading = false;
          });
        }
      }
      return;
    }

    if (_effectiveDio != null) {
      setState(() => _isLoading = true);
      try {
        final response = await _effectiveDio!.post(
          '${ApiEndpoint.branchManagerCashiers}/swap-shifts',
          data: {
            'cashier_a_id': itemA.cashierId,
            'shift_a_id': itemA.templateId,
            'cashier_b_id': itemB.cashierId,
            'shift_b_id': itemB.templateId,
            'shift_date': itemA.shiftDate,
            'for_full_week': false,
          },
        );

        if (response.statusCode == 200) {
          if (mounted) {
            _selectedSlotForSwap = null;
            await _loadRoster();
            if (mounted && !_hasLoadError) {
              setState(() => _statusMessage = 'تم تبديل الكاشيرين بنجاح.');
              widget.onSwapCompleted?.call(itemA.templateId, itemB.templateId);
            }
          }
        } else {
          if (mounted) {
            setState(() {
              _selectedSlotForSwap = null;
              _statusMessage =
                  'تعذر التبديل: ${response.data?['message'] ?? 'خطأ في الخادم'}';
              _isLoading = false;
            });
          }
        }
      } on DioException catch (e) {
        final serverMsg = _extractDioErrorMessage(
          e,
          defaultAction: 'تعذر التبديل',
        );
        if (mounted) {
          setState(() {
            _selectedSlotForSwap = null;
            _statusMessage = serverMsg;
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _selectedSlotForSwap = null;
            _statusMessage = 'تعذر التبديل: $e';
            _isLoading = false;
          });
        }
      }
      return;
    }

    if (mounted) {
      setState(() {
        _selectedSlotForSwap = null;
        _statusMessage = 'تعذر التبديل: لم يتم العثور على مزود خدمة API.';
        _isLoading = false;
      });
    }
  }

  Future<void> _executeRecurringAssign(
    DatedTemplateSlot slot,
    String cashierId,
    String cashierName,
    String effectiveFrom, [
    String? effectiveTo,
  ]) async {
    setState(() => _isLoading = true);
    final rangeLabel = (effectiveTo != null && effectiveTo.isNotEmpty)
        ? 'من $effectiveFrom إلى $effectiveTo'
        : 'من $effectiveFrom';
    if (widget.onSaveRosterAssignment != null) {
      try {
        await widget.onSaveRosterAssignment!(
          cashierId,
          slot.templateId,
          effectiveFrom,
        );
        if (mounted) {
          setState(() {
            _statusMessage =
                'تم حفظ الأساسي $rangeLabel. التعيينات الفعلية الموجودة لم تتغير؛ أنشئ تعيين اليوم للأيام الشاغرة.';
            _isLoading = false;
          });
          await _loadRoster();
          if (mounted && !_hasLoadError) {
            setState(
              () => _statusMessage =
                  'تم حفظ الأساسي. التعيينات الموجودة لم تتغير، والأيام المخططة تحتاج إنشاء تعيين اليوم.',
            );
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _statusMessage =
                'تعذر حفظ التعيين المتكرر: ${e.toString().replaceAll("Exception: ", "")}';
            _isLoading = false;
          });
        }
      }
      return;
    }

    if (_effectiveDio != null) {
      try {
        final res = await _effectiveDio!.post(
          '${ApiEndpoint.branchManagerCashiers}/roster-assignments',
          data: {
            'assignments': [
              {
                'shift_id': slot.templateId,
                'cashier_id': cashierId,
                'effective_from': effectiveFrom,
                if (effectiveTo != null && effectiveTo.isNotEmpty)
                  'effective_to': effectiveTo,
              },
            ],
          },
        );
        if (res.statusCode == 200 || res.statusCode == 201) {
          if (mounted) {
            setState(() {
              _statusMessage =
                  'تم حفظ الأساسي $rangeLabel. التعيينات الفعلية الموجودة لم تتغير؛ أنشئ تعيين اليوم للأيام الشاغرة.';
              _isLoading = false;
            });
            await _loadRoster();
            if (mounted && !_hasLoadError) {
              setState(
                () => _statusMessage =
                    'تم حفظ الأساسي. التعيينات الموجودة لم تتغير، والأيام المخططة تحتاج إنشاء تعيين اليوم.',
              );
            }
          }
        } else {
          if (mounted) {
            setState(() {
              _statusMessage =
                  'تعذر حفظ التعيين المتكرر: ${res.data?['message'] ?? 'خطأ في الخادم'}';
              _isLoading = false;
            });
          }
        }
      } on DioException catch (e) {
        final serverMsg = _extractDioErrorMessage(
          e,
          defaultAction: 'تعذر حفظ التعيين المتكرر',
        );
        if (mounted) {
          setState(() {
            _statusMessage = serverMsg;
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _statusMessage = 'تعذر حفظ التعيين المتكرر: $e';
            _isLoading = false;
          });
        }
      }
      return;
    }

    if (mounted) {
      setState(() {
        _statusMessage = 'تعذر التنفيذ: لم يتم العثور على مزود خدمة API.';
        _isLoading = false;
      });
    }
  }

  Future<void> _executeAssign(
    DatedTemplateSlot slot,
    String cashierId,
    String cashierName,
  ) async {
    if (_isLoading || _hasLoadError || slot.isProtected) return;
    if (slot.isAssigned && slot.cashierId == cashierId) return;
    setState(() => _isLoading = true);
    try {
      if (widget.onExecuteAssign != null && !slot.hasActualShift) {
        await widget.onExecuteAssign!(
          cashierId,
          slot.templateId,
          slot.shiftDate,
        );
      } else {
        final dio = _effectiveDio;
        if (dio == null) throw StateError('لم يتم العثور على مزود خدمة API.');
        final response = await dio.post(
          slot.hasActualShift
              ? '${ApiEndpoint.branchManagerShifts}/${slot.cashierShiftId}/reassign'
              : '${ApiEndpoint.branchManagerCashiers}/assign-shifts',
          data: slot.hasActualShift
              ? {
                  'new_cashier_id': cashierId,
                  'reason': 'تعديل تعيين يوم ${slot.shiftDate}',
                }
              : {
                  'cashier_id': cashierId,
                  'shift_ids': [slot.templateId],
                  'shift_date': slot.shiftDate,
                },
        );
        if (response.data is Map && response.data['success'] == false) {
          throw StateError(
            response.data['message']?.toString() ?? 'تعذر التعيين',
          );
        }
      }
      if (!mounted) return;
      await _loadRoster();
      if (mounted && !_hasLoadError) {
        setState(
          () => _statusMessage = slot.hasActualShift
              ? 'تم إعادة الإسناد. راجع حالة قبول الكاشير في تفاصيل الوردية.'
              : 'تم إنشاء تعيين اليوم وقراءة حالته من الخادم.',
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = e is DioException
              ? _extractDioErrorMessage(e, defaultAction: 'تعذر تعيين الكاشير')
              : 'تعذر التعيين: $e';
          _isLoading = false;
        });
      }
    }
  }

  void _showAssignCashierDialog(DatedTemplateSlot slot) {
    if (_isLoading || _hasLoadError) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (ctx) {
        return _AssignCashierModalContent(
          slot: slot,
          effectiveDio: _effectiveDio,
          onFetchAvailableCashiers: widget.onFetchAvailableCashiers,
          onCashierSelected: (cId, cName, isRecurring, effectiveFrom, effectiveTo) {
            if (isRecurring) {
              _executeRecurringAssign(
                slot,
                cId,
                cName,
                effectiveFrom,
                effectiveTo,
              );
            } else {
              _executeAssign(slot, cId, cName);
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedTemplates = _filteredTemplates;
    final isToday = _selectedDate == _todayYmd;

    return AppScaffold(
      backgroundColor: context.customColor.text2,
      child: SafeArea(
        child: Column(
          children: [
            // Header Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Row(
                children: [
                  AppBackButton(
                    isTransparent: true,
                    iconColor: context.customColor.text1,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'تعيين مؤرّخ',
                      key: const Key('txt_screen_title'),
                      style: AppStyles.s16W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ),
                  InkWell(
                    key: const Key('btn_refresh_roster'),
                    onTap: _isLoading ? null : _loadRoster,
                    child: Padding(
                      padding: EdgeInsets.all(6.r),
                      child: Icon(
                        Icons.refresh,
                        color: context.theme.primaryColor,
                        size: 20.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Accountant Governance Banner
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: Colors.blue.withValues(alpha: 0.25),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.admin_panel_settings_outlined,
                    color: Colors.blue.shade700,
                    size: 18.w,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      _scheduleSourceLabel != null &&
                              _scheduleSourceLabel!.isNotEmpty
                          ? 'إعداد القوالب والمواعيد يظل ضمن صلاحيات المحاسب ($_scheduleSourceLabel)'
                          : 'إعداد القوالب والمواعيد يظل ضمن صلاحيات المحاسب',
                      key: const Key('txt_accountant_governance_notice'),
                      style: AppStyles.s12W400.copyWith(
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Single-Day Date & Calendar Navigator Card
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  IconButton(
                    key: const Key('btn_prev_day'),
                    tooltip: 'اليوم السابق',
                    onPressed: _isLoading ? null : () => _stepDay(-1),
                    icon: const Icon(Icons.chevron_right),
                    color: context.theme.primaryColor,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          key: const Key('btn_pick_date_range'),
                          borderRadius: BorderRadius.circular(8.r),
                          onTap: _isLoading ? null : _pickRosterStartDate,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 4.h,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_month_outlined,
                                  color: context.theme.primaryColor,
                                  size: 16.w,
                                ),
                                SizedBox(width: 6.w),
                                Flexible(
                                  child: Text(
                                    _formatArabicDayHeader(_selectedDate),
                                    key: const Key('txt_selected_date'),
                                    style: AppStyles.s14W600.copyWith(
                                      color: context.customColor.text1,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isToday) ...[
                                  SizedBox(width: 6.w),
                                  Container(
                                    key: const Key('badge_today'),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6.w,
                                      vertical: 2.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: context.theme.primaryColor
                                          .withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Text(
                                      'اليوم',
                                      style: TextStyle(
                                        color: context.theme.primaryColor,
                                        fontSize: 10.w,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                                SizedBox(width: 2.w),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: context.theme.primaryColor,
                                  size: 18.w,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8.w,
                          runSpacing: 4.h,
                          children: [
                            Text(
                              _formatShiftCountAr(displayedTemplates.length),
                              key: const Key('txt_day_shift_count'),
                              style: AppStyles.s12W500.copyWith(
                                color: context.customColor.text3,
                              ),
                            ),
                            if (!isToday)
                              InkWell(
                                key: const Key('btn_jump_today'),
                                borderRadius: BorderRadius.circular(6.r),
                                onTap: _isLoading ? null : _jumpToToday,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: context.theme.primaryColor
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Text(
                                    'العودة لليوم',
                                    style: TextStyle(
                                      color: context.theme.primaryColor,
                                      fontSize: 11.w,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    key: const Key('btn_next_day'),
                    tooltip: 'اليوم التالي',
                    onPressed: _isLoading ? null : () => _stepDay(1),
                    icon: const Icon(Icons.chevron_left),
                    color: context.theme.primaryColor,
                  ),
                ],
              ),
            ),

            if (_isLoading)
              LinearProgressIndicator(
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  context.theme.primaryColor,
                ),
              )
            else
              SizedBox(height: 4.h),

            // Status message (if any operational message, suppressed when central error card is active)
            if (_statusMessage != null && !_hasLoadError)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: _statusMessage!.contains('تعذر')
                      ? Colors.red.shade50
                      : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      _statusMessage!.contains('تعذر')
                          ? Icons.error_outline
                          : Icons.check_circle_outline,
                      color: _statusMessage!.contains('تعذر')
                          ? Colors.red
                          : Colors.green,
                      size: 16.w,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        _statusMessage!,
                        key: const Key('txt_status_message'),
                        style: AppStyles.s12W400.copyWith(
                          color: _statusMessage!.contains('تعذر')
                              ? Colors.red.shade900
                              : Colors.green.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Content Area (Error state, Empty state, or Templates list)
            Expanded(
              child: _hasLoadError
                  ? Center(
                      key: const Key('error_roster_state'),
                      child: Padding(
                        padding: EdgeInsets.all(32.r),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_off_outlined,
                              size: 48.w,
                              color: Colors.red.shade400,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              _statusMessage ??
                                  'تعذر تحميل التعيينات من الخادم.',
                              textAlign: TextAlign.center,
                              style: AppStyles.s14W500.copyWith(
                                color: Colors.red.shade700,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton.icon(
                              key: const Key('btn_retry_roster'),
                              onPressed: _isLoading
                                  ? null
                                  : () => _loadRoster(),
                              icon: Icon(Icons.refresh, size: 18.w),
                              label: Text(
                                'إعادة المحاولة',
                                style: AppStyles.s14W500,
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24.w,
                                  vertical: 10.h,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : displayedTemplates.isEmpty && !_isLoading
                  ? Center(
                      key: const Key('empty_roster_state'),
                      child: Padding(
                        padding: EdgeInsets.all(32.r),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_busy,
                              size: 48.w,
                              color: context.customColor.text3,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              'لا توجد قوالب أو ورديات في هذه الفترة',
                              style: AppStyles.s14W500.copyWith(
                                color: context.customColor.text3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      itemCount: displayedTemplates.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        final slot = displayedTemplates[index];
                        final isSelectedForSwap =
                            _selectedSlotForSwap != null &&
                            _selectedSlotForSwap!.templateId ==
                                slot.templateId &&
                            _selectedSlotForSwap!.shiftDate == slot.shiftDate;

                        return Container(
                          key: Key('card_template_${slot.templateId}'),
                          padding: EdgeInsets.all(14.r),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: isSelectedForSwap
                                  ? context.theme.primaryColor
                                  : Colors.transparent,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Row 1: Date & Template name & hours
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6.w,
                                      vertical: 2.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: context.theme.primaryColor
                                          .withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: Text(
                                      slot.shiftDate,
                                      key: Key(
                                        'txt_slot_date_${slot.templateId}',
                                      ),
                                      style: AppStyles.s11W600.copyWith(
                                        color: context.theme.primaryColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      slot.templateName,
                                      key: Key(
                                        'txt_tpl_name_${slot.templateId}',
                                      ),
                                      style: AppStyles.s14W600.copyWith(
                                        color: context.customColor.text1,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 2.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: Text(
                                      '${slot.startTime} - ${slot.endTime}',
                                      key: Key(
                                        'txt_tpl_hours_${slot.templateId}',
                                      ),
                                      style: AppStyles.s12W400.copyWith(
                                        color: context.customColor.text3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),

                              // Primary Cashier for template (Recurring Roster MTG-OPS-02/03)
                              Row(
                                children: [
                                  Icon(
                                    Icons.repeat,
                                    size: 15.w,
                                    color: context.theme.primaryColor,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    'الأساسي المتكرر: ',
                                    style: AppStyles.s12W500.copyWith(
                                      color: context.theme.primaryColor,
                                    ),
                                  ),
                                    Expanded(
                                      child: Text(
                                        slot.primaryCashierName != null
                                            ? (slot.primaryEffectiveTo != null &&
                                                      slot
                                                          .primaryEffectiveTo!
                                                          .isNotEmpty
                                                  ? '${slot.primaryCashierName!} (من ${slot.primaryEffectiveFrom ?? "—"} إلى ${slot.primaryEffectiveTo!})'
                                                  : '${slot.primaryCashierName!} (سارٍ من ${slot.primaryEffectiveFrom ?? "—"})')
                                            : 'غير محدد (لم يُعيّن كاشير أساسي)',
                                        key: Key(
                                          'txt_primary_cashier_${slot.templateId}',
                                        ),
                                      style: AppStyles.s12W600.copyWith(
                                        color: slot.primaryCashierName != null
                                            ? context.customColor.text1
                                            : context.customColor.text3,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6.h),

                              // Assigned Cashier
                              Row(
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    size: 16.w,
                                    color: context.customColor.text3,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    'الكاشير المعيّن: ',
                                    style: AppStyles.s13W400.copyWith(
                                      color: context.customColor.text3,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            slot.cashierName ??
                                                (slot.isPlanned
                                                    ? 'مخطط فقط — لم تُنشأ وردية'
                                                    : 'غير معيّن'),
                                            key: Key(
                                              'txt_cashier_name_${slot.templateId}',
                                            ),
                                            style: AppStyles.s13W600.copyWith(
                                              color: slot.cashierName != null
                                                  ? context.customColor.text1
                                                  : Colors.orange.shade700,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (slot.isAssigned &&
                                            slot.primaryCashierId != null) ...[
                                          SizedBox(height: 4.h),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 6.w,
                                              vertical: 2.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: slot.isRecurringPrimary
                                                  ? Colors.blue.withValues(
                                                      alpha: 0.1,
                                                    )
                                                  : Colors.amber.withValues(
                                                      alpha: 0.15,
                                                    ),
                                              borderRadius:
                                                  BorderRadius.circular(4.r),
                                            ),
                                            child: Text(
                                              slot.isRecurringPrimary
                                                  ? 'أساسي'
                                                  : 'تعيين فعلي مختلف',
                                              key: Key(
                                                'badge_assignment_type_${slot.templateId}',
                                              ),
                                              style: TextStyle(
                                                color: slot.isRecurringPrimary
                                                    ? Colors.blue.shade800
                                                    : Colors.amber.shade900,
                                                fontSize: 10.w,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),

                              // Status & Action buttons
                              Wrap(
                                spacing: 8.w,
                                runSpacing: 8.h,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                alignment: WrapAlignment.spaceBetween,
                                children: [
                                  // Status Chip
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: slot.isProtected
                                          ? Colors.amber.shade50
                                          : Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: Text(
                                      slot.isProtected
                                          ? (slot.hasFinancialEvidence
                                                ? 'محمي بدليل مالي'
                                                : (slot.status == 'reassigned'
                                                      ? 'أعيد الإسناد — بانتظار قبول الكاشير'
                                                      : 'وردية بدأت أو انتهت'))
                                          : (slot.isAssigned
                                                ? 'جاهز للتعيين / التبديل'
                                                : (slot.isPlanned
                                                      ? 'بانتظار إنشاء وردية اليوم'
                                                      : 'بانتظار التعيين')),
                                      style: AppStyles.s11W400.copyWith(
                                        color: slot.isProtected
                                            ? Colors.amber.shade900
                                            : Colors.green.shade900,
                                      ),
                                    ),
                                  ),

                                  // Action: Assign Cashier if unassigned
                                  if (!slot.isAssigned && !slot.isProtected)
                                    ElevatedButton.icon(
                                      key: Key('btn_assign_${slot.templateId}'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            context.theme.primaryColor,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                          vertical: 6.h,
                                        ),
                                      ),
                                      onPressed: _isLoading
                                          ? null
                                          : () =>
                                                _showAssignCashierDialog(slot),
                                      icon: Icon(
                                        Icons.person_add_alt_1,
                                        size: 16.w,
                                      ),
                                      label: Text(
                                        'تعيين كاشير',
                                        style: AppStyles.s12W500,
                                      ),
                                    ),

                                  // Action: Edit / Reassign if assigned and not protected
                                  if (slot.isAssigned && !slot.isProtected)
                                    OutlinedButton.icon(
                                      key: Key(
                                        'btn_assign_edit_${slot.templateId}',
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor:
                                            context.theme.primaryColor,
                                        side: BorderSide(
                                          color: context.theme.primaryColor,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                          vertical: 6.h,
                                        ),
                                      ),
                                      onPressed: _isLoading
                                          ? null
                                          : () =>
                                                _showAssignCashierDialog(slot),
                                      icon: Icon(Icons.edit, size: 14.w),
                                      label: Text(
                                        'تعديل التعيين',
                                        style: AppStyles.s12W500,
                                      ),
                                    ),

                                  // Action: Swap if assigned and not protected
                                  if (slot.isAssigned && !slot.isProtected)
                                    OutlinedButton(
                                      key: Key('btn_swap_${slot.templateId}'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: isSelectedForSwap
                                            ? Colors.red
                                            : context.theme.primaryColor,
                                        side: BorderSide(
                                          color: isSelectedForSwap
                                              ? Colors.red
                                              : context.theme.primaryColor,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                          vertical: 6.h,
                                        ),
                                      ),
                                      onPressed: _isLoading
                                          ? null
                                          : () {
                                              if (_selectedSlotForSwap ==
                                                  null) {
                                                setState(() {
                                                  _selectedSlotForSwap = slot;
                                                  _statusMessage =
                                                      'اختر القالب الآخر لإتمام التبديل الذري.';
                                                });
                                              } else if (_selectedSlotForSwap!
                                                          .templateId ==
                                                      slot.templateId &&
                                                  _selectedSlotForSwap!
                                                          .shiftDate ==
                                                      slot.shiftDate) {
                                                setState(() {
                                                  _selectedSlotForSwap = null;
                                                  _statusMessage = null;
                                                });
                                              } else {
                                                _executeAtomicSwap(
                                                  _selectedSlotForSwap!,
                                                  slot,
                                                );
                                              }
                                            },
                                      child: Text(
                                        isSelectedForSwap
                                            ? 'إلغاء'
                                            : (_selectedSlotForSwap == null
                                                  ? 'تبديل الكاشير'
                                                  : 'إتمام التبديل'),
                                        style: AppStyles.s12W500,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet modal content for selecting an available cashier
class _AssignCashierModalContent extends StatefulWidget {
  final DatedTemplateSlot slot;
  final Dio? effectiveDio;
  final Future<List<Map<String, dynamic>>> Function()? onFetchAvailableCashiers;
  final void Function(
    String cashierId,
    String cashierName,
    bool isRecurring,
    String effectiveFrom,
    String? effectiveTo,
  )
  onCashierSelected;

  const _AssignCashierModalContent({
    required this.slot,
    required this.effectiveDio,
    required this.onFetchAvailableCashiers,
    required this.onCashierSelected,
  });

  @override
  State<_AssignCashierModalContent> createState() =>
      _AssignCashierModalContentState();
}

class _AssignCashierModalContentState
    extends State<_AssignCashierModalContent> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _cashiers = [];
  String? _selectedCashierId;
  String? _selectedCashierName;
  bool _isRecurring = false;
  late DateTime _effectiveFromDate;
  DateTime? _effectiveToDate;

  @override
  void initState() {
    super.initState();
    // A dated action creates/reassigns the selected day. Recurrence is explicit.
    _isRecurring = false;
    final parsedSlot = _DatedShiftAssignmentScreenState._parseYmdUtc(
      widget.slot.shiftDate,
    );
    _effectiveFromDate = parsedSlot != null
        ? DateTime(parsedSlot.year, parsedSlot.month, parsedSlot.day)
        : DateTime.now();
    _effectiveToDate = null;
    _fetchCashiers();
  }

  String _ymd(DateTime d) =>
      _DatedShiftAssignmentScreenState._formatYmd(d);

  int? get _durationDays {
    if (_effectiveToDate == null) return null;
    final fromUtc = DateTime.utc(
      _effectiveFromDate.year,
      _effectiveFromDate.month,
      _effectiveFromDate.day,
    );
    final toUtc = DateTime.utc(
      _effectiveToDate!.year,
      _effectiveToDate!.month,
      _effectiveToDate!.day,
    );
    final diff = toUtc.difference(fromUtc).inDays;
    return diff < 0 ? 1 : diff + 1;
  }

  String _formatDaysAr(int days) {
    if (days <= 1) return 'يوم واحد';
    if (days == 2) return 'يومان';
    if (days <= 10) return '$days أيام';
    return '$days يوماً';
  }

  DateTime get _pickerFirstDate {
    final nowY = DateTime.now().year;
    final minY = _effectiveFromDate.year < nowY
        ? _effectiveFromDate.year
        : nowY;
    return DateTime(minY - 2);
  }

  DateTime get _pickerLastDate {
    final nowY = DateTime.now().year;
    final maxY = _effectiveFromDate.year > nowY
        ? _effectiveFromDate.year
        : nowY;
    return DateTime(maxY + 5, 12, 31);
  }

  DateTime _addLocalDays(DateTime base, int days) {
    final u = DateTime.utc(base.year, base.month, base.day).add(
      Duration(days: days),
    );
    return DateTime(u.year, u.month, u.day);
  }

  Future<void> _pickEffectiveFrom() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _effectiveFromDate,
      firstDate: _pickerFirstDate,
      lastDate: _pickerLastDate,
      helpText: 'اختر تاريخ بداية التعيين المتكرر',
    );
    if (!mounted || picked == null) return;
    setState(() {
      _effectiveFromDate = DateTime(picked.year, picked.month, picked.day);
      if (_effectiveToDate != null &&
          _effectiveToDate!.isBefore(_effectiveFromDate)) {
        _effectiveToDate = _effectiveFromDate;
      }
    });
  }

  Future<void> _pickEffectiveTo() async {
    final fallbackEnd = _addLocalDays(_effectiveFromDate, 6);
    final rawInitial = (_effectiveToDate != null &&
            !_effectiveToDate!.isBefore(_effectiveFromDate))
        ? _effectiveToDate!
        : fallbackEnd;
    final initialTo = rawInitial.isAfter(_pickerLastDate)
        ? _pickerLastDate
        : rawInitial;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialTo,
      firstDate: _effectiveFromDate,
      lastDate: _pickerLastDate,
      helpText: 'اختر تاريخ نهاية التعيين المتكرر',
    );
    if (!mounted || picked == null) return;
    setState(() {
      _effectiveToDate = DateTime(picked.year, picked.month, picked.day);
    });
  }

  Future<void> _pickRecurringRange() async {
    final rawEnd = (_effectiveToDate != null &&
            !_effectiveToDate!.isBefore(_effectiveFromDate))
        ? _effectiveToDate!
        : _addLocalDays(_effectiveFromDate, 6);
    final safeEnd = rawEnd.isAfter(_pickerLastDate) ? _pickerLastDate : rawEnd;
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: _effectiveFromDate,
        end: safeEnd,
      ),
      firstDate: _pickerFirstDate,
      lastDate: _pickerLastDate,
      helpText: 'اختر فترة التعيين المتكرر',
    );
    if (!mounted || picked == null) return;
    setState(() {
      _effectiveFromDate = DateTime(
        picked.start.year,
        picked.start.month,
        picked.start.day,
      );
      _effectiveToDate = DateTime(
        picked.end.year,
        picked.end.month,
        picked.end.day,
      );
    });
  }

  void _applyDurationPreset(int days) {
    setState(() {
      _effectiveToDate = _addLocalDays(_effectiveFromDate, days - 1);
    });
  }

  String _formatManagerDisplayName(String rawName) {
    final trimmed = rawName.trim();
    if (trimmed.isEmpty) return 'مدير الفرع';
    if (trimmed.contains('مدير الفرع')) return trimmed;
    return '$trimmed (مدير الفرع)';
  }

  bool _isBranchManagerMap(Map<String, dynamic> c) {
    final role = c['role']?.toString().toLowerCase();
    final type = c['type']?.toString().toLowerCase();
    return c['is_branch_manager'] == true ||
        c['is_manager'] == true ||
        role == 'branch_manager' ||
        type == 'branch_manager';
  }

  Map<String, dynamic>? _asStringDynamicMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  Future<List<Map<String, dynamic>>> _withBranchManagerOption(
    List<Map<String, dynamic>> cashiers, {
    Map<String, dynamic>? responseBody,
  }) async {
    String? managerId;
    String? managerName;
    String? managerPhone;
    bool managerAvailable = true;
    String? managerUnavailableReason;

    final metaMap = _asStringDynamicMap(responseBody?['meta']);
    final metaManager =
        _asStringDynamicMap(metaMap?['branch_manager']) ??
        _asStringDynamicMap(responseBody?['branch_manager']);

    if (metaManager != null) {
      final candidateId = metaManager['id']?.toString().trim();
      if (candidateId != null && candidateId.isNotEmpty) {
        managerId = candidateId;
        managerName = metaManager['name']?.toString();
        managerPhone = metaManager['phone']?.toString();
        final disabled = metaManager['disabled'] as bool? ?? false;
        managerAvailable =
            (metaManager['is_available'] as bool? ?? !disabled) && !disabled;
        managerUnavailableReason = metaManager['reason_disabled']?.toString();
      }
    }

    if ((managerId == null || managerId.isEmpty) &&
        widget.effectiveDio != null) {
      try {
        final allRes = await widget.effectiveDio!.get(
          '${ApiEndpoint.branchManagerCashiers}/all',
        );
        if (allRes.statusCode == 200) {
          final bodyMap = _asStringDynamicMap(allRes.data);
          final dataMap = _asStringDynamicMap(bodyMap?['data']);
          final managersList = dataMap?['branch_managers'];
          if (managersList is List && managersList.isNotEmpty) {
            final firstManager = _asStringDynamicMap(managersList.first);
            final candidateId = firstManager?['id']?.toString().trim();
            if (candidateId != null && candidateId.isNotEmpty) {
              managerId = candidateId;
              managerName = firstManager?['name']?.toString();
              managerPhone = firstManager?['phone']?.toString();
            }
          }
        }
      } catch (_) {}
    }

    if (managerId == null ||
        managerId.isEmpty ||
        managerName == null ||
        managerName.trim().isEmpty) {
      try {
        if (getIt.isRegistered<SharedPreferencesHelper>()) {
          final prefs = getIt<SharedPreferencesHelper>();
          final localId = prefs.getString('u_id')?.trim();
          final localName = prefs.getString('u_name')?.trim();
          final localPhone = prefs.getString('u_phone')?.trim();
          if (managerId == null || managerId.isEmpty) {
            if (localId != null && localId.isNotEmpty) {
              managerId = localId;
            }
          }
          if ((managerName == null || managerName.trim().isEmpty) &&
              localName != null &&
              localName.isNotEmpty) {
            managerName = localName;
          }
          if ((managerPhone == null || managerPhone.isEmpty) &&
              localPhone != null &&
              localPhone.isNotEmpty) {
            managerPhone = localPhone;
          }
        }
      } catch (_) {}
    }

    final result = cashiers.map((item) => Map<String, dynamic>.from(item)).toList();

    if (managerId != null && managerId.isNotEmpty) {
      final existingIdx = result.indexWhere(
        (c) => c['id']?.toString() == managerId,
      );
      if (existingIdx >= 0) {
        final existing = result.removeAt(existingIdx);
        final rawName = (managerName != null && managerName.trim().isNotEmpty)
            ? managerName
            : (existing['name']?.toString() ?? '');
        existing['name'] = _formatManagerDisplayName(rawName);
        if ((existing['phone'] == null ||
                existing['phone'].toString().trim().isEmpty) &&
            managerPhone != null &&
            managerPhone.isNotEmpty) {
          existing['phone'] = managerPhone;
        }
        existing['is_branch_manager'] = true;
        result.insert(0, existing);
      } else {
        result.insert(0, {
          'id': managerId,
          'name': _formatManagerDisplayName(managerName ?? ''),
          if (managerPhone != null && managerPhone.isNotEmpty)
            'phone': managerPhone,
          'is_available': managerAvailable,
          'disabled': !managerAvailable,
          'reason_disabled': managerUnavailableReason,
          'is_branch_manager': true,
        });
      }
    } else {
      final flaggedIdx = result.indexWhere(_isBranchManagerMap);
      if (flaggedIdx >= 0) {
        final flagged = result.removeAt(flaggedIdx);
        flagged['name'] = _formatManagerDisplayName(
          flagged['name']?.toString() ?? '',
        );
        flagged['is_branch_manager'] = true;
        result.insert(0, flagged);
      }
    }

    return result;
  }

  Future<void> _fetchCashiers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _selectedCashierId = null;
      _selectedCashierName = null;
    });

    if (widget.onFetchAvailableCashiers != null) {
      try {
        final rawList = await widget.onFetchAvailableCashiers!();
        final normalized = rawList.map((c) {
          final m = Map<String, dynamic>.from(c);
          m['is_branch_manager'] = _isBranchManagerMap(m);
          return m;
        }).toList();
        final enriched = await _withBranchManagerOption(normalized);
        if (mounted) {
          setState(() {
            _cashiers = enriched;
            _isLoading = false;
          });
        }
        return;
      } catch (e) {
        if (mounted) {
          setState(() {
            _errorMessage =
                'تعذر تحميل الكاشيرات المتاحين: ${e.toString().replaceAll("Exception: ", "")}';
            _isLoading = false;
          });
        }
        return;
      }
    }

    if (widget.effectiveDio != null) {
      try {
        final queryParams = <String, dynamic>{
          'shift_date': widget.slot.shiftDate,
        };
        if (widget.slot.cashierShiftId != null &&
            widget.slot.cashierShiftId!.isNotEmpty) {
          queryParams['shift_id'] = widget.slot.cashierShiftId;
        } else {
          queryParams['template_id'] = widget.slot.templateId;
          queryParams['shift_template_id'] = widget.slot.templateId;
        }

        final res = await widget.effectiveDio!.get(
          '${ApiEndpoint.branchManagerCashiers}/available-cashiers',
          queryParameters: queryParams,
        );

        final responseMap = _asStringDynamicMap(res.data);
        final list = responseMap?['data'] as List<dynamic>? ?? [];
        final parsed = list.map((raw) {
          final c = _asStringDynamicMap(raw) ?? <String, dynamic>{};
          return <String, dynamic>{
            'id': c['id']?.toString() ?? '',
            'name': c['name']?.toString() ?? 'كاشير مصرح',
            if (c['phone'] != null) 'phone': c['phone']?.toString(),
            'is_available':
                c['is_available'] as bool? ??
                !(c['disabled'] as bool? ?? false),
            'disabled': c['disabled'] as bool? ?? false,
            'reason_disabled': c['reason_disabled']?.toString(),
            'is_branch_manager': _isBranchManagerMap(c),
          };
        }).toList();

        final enriched = await _withBranchManagerOption(
          parsed,
          responseBody: responseMap,
        );

        if (mounted) {
          setState(() {
            _cashiers = enriched;
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _errorMessage = 'تعذر تحميل الكاشيرات المتاحين من الخادم.';
            _isLoading = false;
          });
        }
      }
      return;
    }

    if (mounted) {
      setState(() {
        _cashiers = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final fromStr = _ymd(_effectiveFromDate);
    final toStr = _effectiveToDate != null ? _ymd(_effectiveToDate!) : null;
    final fromWeekday = _DatedShiftAssignmentScreenState._arabicWeekdayName(
      fromStr,
    );
    final toWeekday = toStr != null
        ? _DatedShiftAssignmentScreenState._arabicWeekdayName(toStr)
        : '';
    final durationDays = _durationDays;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'اختر كاشيراً لتعيينه',
                      key: const Key('txt_dialog_assign_title'),
                      style: AppStyles.s16W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Text(
                '${widget.slot.templateName} (${widget.slot.shiftDate})',
                style: AppStyles.s12W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
              SizedBox(height: 8.h),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // High-contrast mode selection: Single-Day Exception vs Recurring Calendar
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 4.h),
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'نوع التعيين:',
                              style: AppStyles.s12W600.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            RadioGroup<bool>(
                              groupValue: _isRecurring,
                              onChanged: (v) {
                                if (v != null) {
                                  setState(() => _isRecurring = v);
                                }
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      key: const Key('radio_single_day_exception'),
                                      borderRadius: BorderRadius.circular(10.r),
                                      onTap: () =>
                                          setState(() => _isRecurring = false),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 8.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: !_isRecurring
                                              ? context.theme.primaryColor
                                                    .withValues(alpha: 0.08)
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                          border: Border.all(
                                            color: !_isRecurring
                                                ? context.theme.primaryColor
                                                : Colors.grey.shade300,
                                            width: !_isRecurring ? 1.5 : 1,
                                          ),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Radio<bool>(
                                              value: false,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              visualDensity: VisualDensity(
                                                horizontal: -4,
                                                vertical: -4,
                                              ),
                                            ),
                                            SizedBox(width: 4.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'استثناء يوم واحد',
                                                    style: AppStyles.s12W600
                                                        .copyWith(
                                                          color: !_isRecurring
                                                              ? context
                                                                    .theme
                                                                    .primaryColor
                                                              : context
                                                                    .customColor
                                                                    .text1,
                                                        ),
                                                  ),
                                                  SizedBox(height: 2.h),
                                                  Text(
                                                    'ليوم ${widget.slot.shiftDate}',
                                                    style: AppStyles.s11W400
                                                        .copyWith(
                                                          color: context
                                                              .customColor
                                                              .text3,
                                                        ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: InkWell(
                                      key: const Key(
                                        'radio_recurring_assignment',
                                      ),
                                      borderRadius: BorderRadius.circular(10.r),
                                      onTap: () =>
                                          setState(() => _isRecurring = true),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 8.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _isRecurring
                                              ? context.theme.primaryColor
                                                    .withValues(alpha: 0.08)
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                          border: Border.all(
                                            color: _isRecurring
                                                ? context.theme.primaryColor
                                                : Colors.grey.shade300,
                                            width: _isRecurring ? 1.5 : 1,
                                          ),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Radio<bool>(
                                              value: true,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              visualDensity: VisualDensity(
                                                horizontal: -4,
                                                vertical: -4,
                                              ),
                                            ),
                                            SizedBox(width: 4.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'تعيين متكرر',
                                                    style: AppStyles.s12W600
                                                        .copyWith(
                                                          color: _isRecurring
                                                              ? context
                                                                    .theme
                                                                    .primaryColor
                                                              : context
                                                                    .customColor
                                                                    .text1,
                                                        ),
                                                  ),
                                                  SizedBox(height: 2.h),
                                                  Text(
                                                    'يتكرر حسب التقويم',
                                                    style: AppStyles.s11W400
                                                        .copyWith(
                                                          color: context
                                                              .customColor
                                                              .text3,
                                                        ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_isRecurring) ...[
                              SizedBox(height: 8.h),
                              Container(
                                padding: EdgeInsets.all(10.r),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                    color: context.theme.primaryColor
                                        .withValues(alpha: 0.25),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'فترة التعيين المتكرر (التقويم)',
                                      style: AppStyles.s12W600.copyWith(
                                        color: context.customColor.text1,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            key: const Key(
                                              'btn_pick_effective_from',
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            onTap: _pickEffectiveFrom,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8.w,
                                                vertical: 8.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade50,
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                border: Border.all(
                                                  color: Colors.grey.shade300,
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.calendar_today,
                                                        size: 13.w,
                                                        color: context
                                                            .theme
                                                            .primaryColor,
                                                      ),
                                                      SizedBox(width: 4.w),
                                                      Expanded(
                                                        child: Text(
                                                          'من تاريخ',
                                                          style: AppStyles
                                                              .s11W400
                                                              .copyWith(
                                                                color: context
                                                                    .customColor
                                                                    .text3,
                                                              ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 4.h),
                                                  Text(
                                                    fromStr,
                                                    key: const Key(
                                                      'txt_effective_from_value',
                                                    ),
                                                    style: AppStyles.s12W600
                                                        .copyWith(
                                                          color: context
                                                              .customColor
                                                              .text1,
                                                        ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  if (fromWeekday.isNotEmpty)
                                                    Text(
                                                      fromWeekday,
                                                      style: AppStyles.s11W400
                                                          .copyWith(
                                                            color: context
                                                                .customColor
                                                                .text3,
                                                          ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Expanded(
                                          child: InkWell(
                                            key: const Key(
                                              'btn_pick_effective_to',
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            onTap: _pickEffectiveTo,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8.w,
                                                vertical: 8.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade50,
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                border: Border.all(
                                                  color: Colors.grey.shade300,
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.event_available,
                                                        size: 13.w,
                                                        color: context
                                                            .theme
                                                            .primaryColor,
                                                      ),
                                                      SizedBox(width: 4.w),
                                                      Expanded(
                                                        child: Text(
                                                          'إلى تاريخ (اختياري)',
                                                          style: AppStyles
                                                              .s11W400
                                                              .copyWith(
                                                                color: context
                                                                    .customColor
                                                                    .text3,
                                                              ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 4.h),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          toStr ??
                                                              'مفتوح (مستمر)',
                                                          key: const Key(
                                                            'txt_effective_to_value',
                                                          ),
                                                          style: AppStyles
                                                              .s12W600
                                                              .copyWith(
                                                                color: toStr != null
                                                                    ? context
                                                                          .customColor
                                                                          .text1
                                                                    : context
                                                                          .customColor
                                                                          .text3,
                                                              ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      if (_effectiveToDate !=
                                                          null)
                                                        InkWell(
                                                          key: const Key(
                                                            'btn_clear_effective_to',
                                                          ),
                                                          onTap: () => setState(
                                                            () =>
                                                                _effectiveToDate =
                                                                    null,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10.r,
                                                              ),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                  2.r,
                                                                ),
                                                            child: Icon(
                                                              Icons.close,
                                                              size: 14.w,
                                                              color: context
                                                                  .customColor
                                                                  .text3,
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                  Text(
                                                    toStr != null
                                                        ? toWeekday
                                                        : 'بدون تاريخ نهاية',
                                                    style: AppStyles.s11W400
                                                        .copyWith(
                                                          color: context
                                                              .customColor
                                                              .text3,
                                                        ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.h),
                                    Wrap(
                                      spacing: 6.w,
                                      runSpacing: 6.h,
                                      children: [
                                        ChoiceChip(
                                          key: const Key('chip_recurring_open'),
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          visualDensity: VisualDensity.compact,
                                          label: const Text('مفتوح'),
                                          selected: _effectiveToDate == null,
                                          onSelected: (_) => setState(
                                            () => _effectiveToDate = null,
                                          ),
                                        ),
                                        ChoiceChip(
                                          key: const Key('chip_recurring_week'),
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          visualDensity: VisualDensity.compact,
                                          label: const Text('أسبوع'),
                                          selected: durationDays == 7,
                                          onSelected: (_) =>
                                              _applyDurationPreset(7),
                                        ),
                                        ChoiceChip(
                                          key: const Key(
                                            'chip_recurring_two_weeks',
                                          ),
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          visualDensity: VisualDensity.compact,
                                          label: const Text('أسبوعان'),
                                          selected: durationDays == 14,
                                          onSelected: (_) =>
                                              _applyDurationPreset(14),
                                        ),
                                        ChoiceChip(
                                          key: const Key(
                                            'chip_recurring_month',
                                          ),
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          visualDensity: VisualDensity.compact,
                                          label: const Text('شهر'),
                                          selected: durationDays == 30,
                                          onSelected: (_) =>
                                              _applyDurationPreset(30),
                                        ),
                                        ActionChip(
                                          key: const Key(
                                            'btn_pick_recurring_range',
                                          ),
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          visualDensity: VisualDensity.compact,
                                          avatar: Icon(
                                            Icons.date_range,
                                            size: 14.w,
                                            color: context.theme.primaryColor,
                                          ),
                                          label: const Text(
                                            'اختيار من التقويم',
                                          ),
                                          onPressed: _pickRecurringRange,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.h),
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 6.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: context.theme.primaryColor
                                            .withValues(alpha: 0.08),
                                        borderRadius: BorderRadius.circular(
                                          6.r,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            size: 14.w,
                                            color: context.theme.primaryColor,
                                          ),
                                          SizedBox(width: 6.w),
                                          Expanded(
                                            child: Text(
                                              toStr != null &&
                                                      durationDays != null
                                                  ? 'سارٍ تلقائياً من $fromStr حتى $toStr (${_formatDaysAr(durationDays)})'
                                                  : 'سارٍ تلقائياً من $fromStr (مستمر بدون تاريخ نهاية)',
                                              key: const Key(
                                                'txt_recurring_summary',
                                              ),
                                              style: AppStyles.s11W500.copyWith(
                                                color:
                                                    context.customColor.text1,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      if (_isLoading)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.h),
                          child: Center(
                            child: CircularProgressIndicator(
                              key: const Key('progress_available_cashiers'),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                context.theme.primaryColor,
                              ),
                            ),
                          ),
                        )
                      else if (_errorMessage != null)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.h),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red.shade700,
                                  size: 36.w,
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  _errorMessage!,
                                  key: const Key('txt_error_available_cashiers'),
                                  textAlign: TextAlign.center,
                                  style: AppStyles.s13W400.copyWith(
                                    color: Colors.red.shade900,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                ElevatedButton.icon(
                                  key: const Key(
                                    'btn_retry_available_cashiers',
                                  ),
                                  onPressed: _fetchCashiers,
                                  icon: const Icon(Icons.refresh, size: 16),
                                  label: const Text('إعادة المحاولة'),
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (_cashiers.isEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.h),
                          child: Center(
                            child: Text(
                              'لا يوجد كاشيرات متاحين حالياً',
                              key: const Key('txt_empty_available_cashiers'),
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text3,
                              ),
                            ),
                          ),
                        )
                      else
                        ListView.separated(
                          key: const Key('list_available_cashiers'),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _cashiers.length,
                          separatorBuilder: (_, _) => Divider(height: 1.h),
                          itemBuilder: (ctx, index) {
                            final c = _cashiers[index];
                            final cId = c['id'].toString();
                            final cName = c['name'].toString();
                            final isBranchManager = _isBranchManagerMap(c);
                            final isAvailable =
                                (c['is_available'] as bool? ?? true) &&
                                !(c['disabled'] as bool? ?? false);
                            final isSelected = _selectedCashierId == cId;

                            return ListTile(
                              key: Key('tile_cashier_$cId'),
                              enabled: isAvailable,
                              selected: isSelected,
                              selectedTileColor: context.theme.primaryColor
                                  .withValues(alpha: 0.08),
                              leading: CircleAvatar(
                                backgroundColor: isAvailable
                                    ? (isSelected
                                          ? context.theme.primaryColor
                                          : context.theme.primaryColor
                                                .withValues(alpha: 0.1))
                                    : Colors.grey.shade200,
                                child: Icon(
                                  isSelected
                                      ? Icons.check
                                      : (isBranchManager
                                            ? Icons.manage_accounts_rounded
                                            : Icons.person),
                                  color: isAvailable
                                      ? (isSelected
                                            ? Colors.white
                                            : context.theme.primaryColor)
                                      : Colors.grey,
                                  size: 20.w,
                                ),
                              ),
                              title: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 6.w,
                                runSpacing: 4.h,
                                children: [
                                  Text(
                                    cName,
                                    style: AppStyles.s14W500.copyWith(
                                      color: isAvailable
                                          ? context.customColor.text1
                                          : context.customColor.text3,
                                    ),
                                  ),
                                  if (isBranchManager)
                                    Container(
                                      key: Key('tag_branch_manager_$cId'),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6.w,
                                        vertical: 2.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: context.theme.primaryColor
                                            .withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(
                                          4.r,
                                        ),
                                      ),
                                      child: Text(
                                        'مدير الفرع — حسابي',
                                        style: TextStyle(
                                          color: context.theme.primaryColor,
                                          fontSize: 10.w,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              subtitle: isAvailable
                                  ? null
                                  : Text(
                                      c['reason_disabled']?.toString() ??
                                          'غير متاح',
                                      key: Key('tag_unavailable_$cId'),
                                      style: TextStyle(
                                        color: Colors.red.shade700,
                                        fontSize: 12.w,
                                      ),
                                    ),
                              trailing: isAvailable
                                  ? (isSelected
                                        ? Icon(
                                            Icons.check_circle,
                                            color: context.theme.primaryColor,
                                          )
                                        : null)
                                  : Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 2.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          4.r,
                                        ),
                                      ),
                                      child: Text(
                                        'غير متاح',
                                        style: TextStyle(
                                          color: Colors.red.shade700,
                                          fontSize: 11.w,
                                        ),
                                      ),
                                    ),
                              onTap: isAvailable
                                  ? () {
                                      setState(() {
                                        _selectedCashierId = cId;
                                        _selectedCashierName = cName;
                                      });
                                    }
                                  : null,
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
              if (!_isLoading &&
                  _errorMessage == null &&
                  _cashiers.isNotEmpty) ...[
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    key: const Key('btn_confirm_cashier_assignment'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.theme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    onPressed: _selectedCashierId != null
                        ? () {
                            Navigator.pop(context);
                            widget.onCashierSelected(
                              _selectedCashierId!,
                              _selectedCashierName!,
                              _isRecurring,
                              fromStr,
                              toStr,
                            );
                          }
                        : null,
                    child: Text('تأكيد التعيين', style: AppStyles.s14W600),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
