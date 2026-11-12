import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/di/dependency_injection.dart';
import '../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../core/network/api_endpoints.dart';
import '../../../../../../core/styles/app_colors.dart';
import '../../../../../../core/styles/app_styles.dart';
import '../../../../../../core/widgets/app_back_button.dart';
import '../../../../../../core/widgets/app_scaffold.dart';

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
  });

  bool get isProtected => status != 'not_started' || hasFinancialEvidence;
  bool get isAssigned => cashierId != null && cashierId!.isNotEmpty;

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
    );
  }
}

/// Screen providing branch manager dated cashier assignment (P4a)
class DatedShiftAssignmentScreen extends StatefulWidget {
  final Dio? dio;
  final List<DatedTemplateSlot>? initialTemplates;
  final String? initialDateRange;
  final Future<List<DatedTemplateSlot>> Function(String startDate, String endDate)?
      onFetchRoster;
  final Future<void> Function(
    String cashierAId,
    String shiftAId,
    String cashierBId,
    String shiftBId,
    String shiftDate,
    bool forFullWeek,
  )? onExecuteSwap;
  final Future<void> Function(
    String cashierId,
    String shiftId,
    String shiftDate,
  )? onExecuteAssign;
  final Future<List<Map<String, dynamic>>> Function()? onFetchAvailableCashiers;
  final void Function(String templateA, String templateB)? onSwapCompleted;

  const DatedShiftAssignmentScreen({
    super.key,
    this.dio,
    this.initialTemplates,
    this.initialDateRange,
    this.onFetchRoster,
    this.onExecuteSwap,
    this.onExecuteAssign,
    this.onFetchAvailableCashiers,
    this.onSwapCompleted,
  });

  @override
  State<DatedShiftAssignmentScreen> createState() =>
      _DatedShiftAssignmentScreenState();
}

class _DatedShiftAssignmentScreenState
    extends State<DatedShiftAssignmentScreen> {
  late List<DatedTemplateSlot> _templates;
  late String _dateRange;
  String _startDate = '2026-11-15';
  String _endDate = '2026-11-21';
  String? _selectedDayFilter;
  DatedTemplateSlot? _selectedSlotForSwap;
  String? _statusMessage;
  bool _isLoading = false;

  Dio? get _effectiveDio =>
      widget.dio ?? (getIt.isRegistered<Dio>() ? getIt<Dio>() : null);

  @override
  void initState() {
    super.initState();
    _dateRange = widget.initialDateRange ?? '2026-11-15 — 2026-11-21';
    if (widget.initialTemplates != null) {
      _templates = List.from(widget.initialTemplates!);
    } else if (widget.onFetchRoster == null && widget.dio == null) {
      _templates = [
        const DatedTemplateSlot(
          templateId: 'tpl-1',
          templateName: 'وردية الصباح الأولى',
          startTime: '08:00',
          endTime: '16:00',
          shiftDate: '2026-11-15',
          cashierId: 'csh-1',
          cashierName: 'محمد أحمد السعيد',
          status: 'not_started',
        ),
        const DatedTemplateSlot(
          templateId: 'tpl-2',
          templateName: 'وردية المساء الثانية',
          startTime: '16:00',
          endTime: '00:00',
          shiftDate: '2026-11-15',
          cashierId: 'csh-2',
          cashierName: 'عبدالله إبراهيم محمود',
          status: 'not_started',
        ),
      ];
    } else {
      _templates = [];
    }

    if (widget.onFetchRoster != null || widget.dio != null) {
      _loadRoster();
    }
  }

  Future<void> _loadRoster() async {
    setState(() => _isLoading = true);

    if (widget.onFetchRoster != null) {
      try {
        final slots = await widget.onFetchRoster!(_startDate, _endDate);
        if (mounted) {
          setState(() {
            _templates = slots;
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _statusMessage = 'تعذر تحميل التعيينات من الخادم: $e';
            _isLoading = false;
          });
        }
      }
      return;
    }

    if (_effectiveDio != null) {
      try {
        final response = await _effectiveDio!.get(
          '${ApiEndpoint.branchManagerCashiers}/dated-roster',
          queryParameters: {
            'start_date': _startDate,
            'end_date': _endDate,
          },
        );

        final data = response.data['data'] as Map<String, dynamic>? ?? {};
        final templatesList = data['templates'] as List<dynamic>? ?? [];
        final rosterMap = data['roster'] as Map<String, dynamic>? ?? {};

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
              final sTime =
                  (t['start_time']?.toString() ?? '08:00:00').substring(0, 5);
              final eTime =
                  (t['end_time']?.toString() ?? '16:00:00').substring(0, 5);

              final key = '${dateStr}_$tId';
              final rEntry = rosterMap[key] as Map<String, dynamic>?;
              final isAssigned = rEntry?['cashier_id'] != null;

              parsedSlots.add(DatedTemplateSlot(
                templateId: tId,
                templateName: tName,
                startTime: sTime,
                endTime: eTime,
                shiftDate: dateStr,
                cashierShiftId: rEntry?['cashier_shift_id']?.toString() ??
                    rEntry?['id']?.toString(),
                cashierId: rEntry?['cashier_id']?.toString(),
                cashierName: rEntry?['cashier_name']?.toString(),
                status: rEntry?['status']?.toString() ?? 'not_started',
                hasFinancialEvidence: rEntry?['has_financial_evidence'] as bool? ??
                    (!(rEntry?['can_swap'] as bool? ?? true) && isAssigned),
              ));
            }
          }
        }

        if (mounted) {
          setState(() {
            _templates = parsedSlots;
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _statusMessage = 'تعذر تحميل التعيينات من الخادم.';
            _isLoading = false;
          });
        }
      }
    }
  }

  void _shiftDateRange(int days) {
    try {
      final s = DateTime.parse(_startDate).add(Duration(days: days));
      final e = DateTime.parse(_endDate).add(Duration(days: days));
      final sStr =
          "${s.year}-${s.month.toString().padLeft(2, '0')}-${s.day.toString().padLeft(2, '0')}";
      final eStr =
          "${e.year}-${e.month.toString().padLeft(2, '0')}-${e.day.toString().padLeft(2, '0')}";

      setState(() {
        _startDate = sStr;
        _endDate = eStr;
        _dateRange = '$sStr — $eStr';
        _selectedDayFilter = null;
        _selectedSlotForSwap = null;
        _statusMessage = null;
      });

      _loadRoster();
    } catch (_) {}
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
    if (_selectedDayFilter == null) {
      return _templates;
    }
    return _templates
        .where((slot) => slot.shiftDate == _selectedDayFilter)
        .toList();
  }

  Future<void> _executeAtomicSwap(
    DatedTemplateSlot itemA,
    DatedTemplateSlot itemB,
  ) async {
    final idxA = _templates.indexWhere((t) =>
        t.templateId == itemA.templateId && t.shiftDate == itemA.shiftDate);
    final idxB = _templates.indexWhere((t) =>
        t.templateId == itemB.templateId && t.shiftDate == itemB.shiftDate);

    if (idxA == -1 || idxB == -1) return;

    if (itemA.isProtected || itemB.isProtected) {
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
            _statusMessage = 'تم تبديل الكاشيرين بنجاح وحفظ السجل المؤرّخ ذرياً.';
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
        final serverMsg = e.response?.data?['message'] ??
            (e.response?.statusCode == 422
                ? 'تعذر التبديل: إحدى الورديات نشطة أو تحتوي على قيود مالية محمية.'
                : 'تعذر التبديل: خطأ في الاتصال بالخادم.');
        if (mounted) {
          setState(() {
            _selectedSlotForSwap = null;
            _statusMessage = serverMsg.toString();
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

    // Fallback local swap
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
      _statusMessage = 'تم تبديل الكاشيرين بنجاح وحفظ السجل المؤرّخ ذرياً.';
    });

    widget.onSwapCompleted?.call(itemA.templateId, itemB.templateId);
  }

  Future<void> _executeAssign(
    DatedTemplateSlot slot,
    String cashierId,
    String cashierName,
  ) async {
    final idx = _templates.indexWhere((t) =>
        t.templateId == slot.templateId && t.shiftDate == slot.shiftDate);
    if (idx == -1) return;

    if (widget.onExecuteAssign != null) {
      setState(() => _isLoading = true);
      try {
        await widget.onExecuteAssign!(cashierId, slot.templateId, slot.shiftDate);
        if (mounted) {
          setState(() {
            _templates[idx] = slot.copyWith(
              cashierId: cashierId,
              cashierName: cashierName,
              status: 'not_started',
            );
            _statusMessage = 'تم تعيين الكاشير للقالب بنجاح.';
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _statusMessage =
                'تعذر التعيين: ${e.toString().replaceAll("Exception: ", "")}';
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
          '${ApiEndpoint.branchManagerCashiers}/assign-shifts',
          data: {
            'cashier_id': cashierId,
            'shift_ids': [slot.templateId],
            'shift_date': slot.shiftDate,
          },
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          if (mounted) {
            setState(() {
              _templates[idx] = slot.copyWith(
                cashierId: cashierId,
                cashierName: cashierName,
                status: 'not_started',
              );
              _statusMessage = 'تم تعيين الكاشير للقالب بنجاح.';
              _isLoading = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _statusMessage =
                  'تعذر التعيين: ${response.data?['message'] ?? 'خطأ في الخادم'}';
              _isLoading = false;
            });
          }
        }
      } on DioException catch (e) {
        final serverMsg = e.response?.data?['message'] ??
            'تعذر تعيين الكاشير: خطأ في الاتصال بالخادم.';
        if (mounted) {
          setState(() {
            _statusMessage = serverMsg.toString();
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _statusMessage = 'تعذر التعيين: $e';
            _isLoading = false;
          });
        }
      }
      return;
    }

    // Fallback local assign
    setState(() {
      _templates[idx] = slot.copyWith(
        cashierId: cashierId,
        cashierName: cashierName,
        status: 'not_started',
      );
      _statusMessage = 'تم تعيين الكاشير للقالب بنجاح.';
    });
  }

  void _showAssignCashierDialog(DatedTemplateSlot slot) {
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
          onCashierSelected: (cId, cName) {
            _executeAssign(slot, cId, cName);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedTemplates = _filteredTemplates;
    final distinctDays = _distinctDays;

    return AppScaffold(
      backgroundColor: AppColors.lightGray,
      child: SafeArea(
        child: Column(
          children: [
            // Header Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
              padding: EdgeInsets.all(12.r),
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
                    size: 20.w,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'إعداد القوالب والمواعيد يظل ضمن صلاحيات المحاسب',
                      key: const Key('txt_accountant_governance_notice'),
                      style: AppStyles.s13W400.copyWith(
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Date Range Bar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    color: context.theme.primaryColor,
                    size: 18.w,
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      _dateRange,
                      key: const Key('txt_date_range'),
                      style: AppStyles.s13W600.copyWith(
                        color: context.customColor.text1,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  InkWell(
                    key: const Key('btn_prev_week'),
                    onTap: () => _shiftDateRange(-7),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      child: Icon(
                        Icons.chevron_right,
                        color: context.customColor.text2,
                        size: 20.w,
                      ),
                    ),
                  ),
                  InkWell(
                    key: const Key('btn_next_week'),
                    onTap: () => _shiftDateRange(7),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      child: Icon(
                        Icons.chevron_left,
                        color: context.customColor.text2,
                        size: 20.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Multi-Day Filter Chips (if more than 1 day returned)
            if (distinctDays.length > 1)
              Container(
                height: 44.h,
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: ChoiceChip(
                          key: const Key('chip_day_all'),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          label: Text('الكل (${_templates.length})'),
                          selected: _selectedDayFilter == null,
                          onSelected: (selected) {
                            setState(() {
                              _selectedDayFilter = null;
                              _selectedSlotForSwap = null;
                            });
                          },
                        ),
                      ),
                      ...distinctDays.map((d) {
                        final count =
                            _templates.where((t) => t.shiftDate == d).length;
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: ChoiceChip(
                            key: Key('chip_day_$d'),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            label: Text('$d ($count)'),
                            selected: _selectedDayFilter == d,
                            onSelected: (selected) {
                              setState(() {
                                _selectedDayFilter = selected ? d : null;
                                _selectedSlotForSwap = null;
                              });
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

            if (_isLoading)
              LinearProgressIndicator(
                backgroundColor: Colors.transparent,
                valueColor:
                    AlwaysStoppedAnimation<Color>(context.theme.primaryColor),
              )
            else
              SizedBox(height: 4.h),

            // Status message (if any)
            if (_statusMessage != null)
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

            // Content Area (Empty state or Templates list)
            Expanded(
              child: displayedTemplates.isEmpty && !_isLoading
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      itemCount: displayedTemplates.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        final slot = displayedTemplates[index];
                        final isSelectedForSwap =
                            _selectedSlotForSwap != null &&
                                _selectedSlotForSwap!.templateId ==
                                    slot.templateId &&
                                _selectedSlotForSwap!.shiftDate ==
                                    slot.shiftDate;

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
                                          'txt_slot_date_${slot.templateId}'),
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
                                          'txt_tpl_name_${slot.templateId}'),
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
                                          'txt_tpl_hours_${slot.templateId}'),
                                      style: AppStyles.s12W400.copyWith(
                                        color: context.customColor.text3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),

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
                                    child: Text(
                                      slot.cashierName ?? 'غير معيّن',
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
                                              : 'وردية بدأت بالفعل')
                                          : (slot.isAssigned
                                              ? 'جاهز للتعيين / التبديل'
                                              : 'بانتظار التعيين'),
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
                                      key: Key(
                                          'btn_assign_${slot.templateId}'),
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
                                          : () => _showAssignCashierDialog(
                                              slot),
                                      icon: Icon(Icons.person_add_alt_1,
                                          size: 16.w),
                                      label: Text(
                                        'تعيين كاشير',
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
                                              if (_selectedSlotForSwap == null) {
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
  final void Function(String cashierId, String cashierName) onCashierSelected;

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

  @override
  void initState() {
    super.initState();
    _fetchCashiers();
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
        final list = await widget.onFetchAvailableCashiers!();
        if (mounted) {
          setState(() {
            _cashiers = list;
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

        final list = res.data['data'] as List<dynamic>? ?? [];
        final parsed = list.map((c) => {
              'id': c['id']?.toString() ?? '',
              'name': c['name']?.toString() ?? 'كاشير مصرح',
              'is_available': c['is_available'] as bool? ??
                  !(c['disabled'] as bool? ?? false),
              'disabled': c['disabled'] as bool? ?? false,
              'reason_disabled': c['reason_disabled']?.toString(),
            }).toList();

        if (mounted) {
          setState(() {
            _cashiers = parsed;
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
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
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
              SizedBox(height: 12.h),
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
                          key: const Key('btn_retry_available_cashiers'),
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
              else ...[
                Flexible(
                  child: ListView.separated(
                    key: const Key('list_available_cashiers'),
                    shrinkWrap: true,
                    itemCount: _cashiers.length,
                    separatorBuilder: (_, __) => Divider(height: 1.h),
                    itemBuilder: (ctx, index) {
                      final c = _cashiers[index];
                      final cId = c['id'].toString();
                      final cName = c['name'].toString();
                      final isAvailable = (c['is_available'] as bool? ?? true) &&
                          !(c['disabled'] as bool? ?? false);
                      final isSelected = _selectedCashierId == cId;

                      return ListTile(
                        key: Key('tile_cashier_$cId'),
                        enabled: isAvailable,
                        selected: isSelected,
                        selectedTileColor:
                            context.theme.primaryColor.withValues(alpha: 0.08),
                        leading: CircleAvatar(
                          backgroundColor: isAvailable
                              ? (isSelected
                                  ? context.theme.primaryColor
                                  : context.theme.primaryColor
                                      .withValues(alpha: 0.1))
                              : Colors.grey.shade200,
                          child: Icon(
                            isSelected ? Icons.check : Icons.person,
                            color: isAvailable
                                ? (isSelected
                                    ? Colors.white
                                    : context.theme.primaryColor)
                                : Colors.grey,
                            size: 20.w,
                          ),
                        ),
                        title: Text(
                          cName,
                          style: AppStyles.s14W500.copyWith(
                            color: isAvailable
                                ? context.customColor.text1
                                : context.customColor.text3,
                          ),
                        ),
                        subtitle: isAvailable
                            ? null
                            : Text(
                                c['reason_disabled']?.toString() ?? 'غير متاح',
                                key: Key('tag_unavailable_$cId'),
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontSize: 12.w,
                                ),
                              ),
                        trailing: isAvailable
                            ? (isSelected
                                ? Icon(Icons.check_circle,
                                    color: context.theme.primaryColor)
                                : null)
                            : Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4.r),
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
                ),
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
                            );
                          }
                        : null,
                    child: Text(
                      'تأكيد التعيين',
                      style: AppStyles.s14W600,
                    ),
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
