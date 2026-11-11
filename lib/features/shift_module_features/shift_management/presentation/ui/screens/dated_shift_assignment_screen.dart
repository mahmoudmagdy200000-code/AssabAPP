import 'package:flutter/material.dart';
import '../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../core/extensions/number_extensions.dart';
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
  final String? cashierId;
  final String? cashierName;
  final String status; // 'not_started', 'in_progress', 'completed'
  final bool hasFinancialEvidence;

  const DatedTemplateSlot({
    required this.templateId,
    required this.templateName,
    required this.startTime,
    required this.endTime,
    this.cashierId,
    this.cashierName,
    this.status = 'not_started',
    this.hasFinancialEvidence = false,
  });

  bool get isProtected => status != 'not_started' || hasFinancialEvidence;

  DatedTemplateSlot copyWith({
    String? templateId,
    String? templateName,
    String? startTime,
    String? endTime,
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
      cashierId: cashierId ?? this.cashierId,
      cashierName: cashierName ?? this.cashierName,
      status: status ?? this.status,
      hasFinancialEvidence: hasFinancialEvidence ?? this.hasFinancialEvidence,
    );
  }
}

/// Screen providing branch manager dated cashier assignment (P4a)
class DatedShiftAssignmentScreen extends StatefulWidget {
  final List<DatedTemplateSlot>? initialTemplates;
  final String? initialDateRange;
  final void Function(String templateA, String templateB)? onSwapCompleted;

  const DatedShiftAssignmentScreen({
    super.key,
    this.initialTemplates,
    this.initialDateRange,
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
  String? _selectedForSwap;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _dateRange = widget.initialDateRange ?? '2026-11-15 — 2026-11-21';
    _templates = widget.initialTemplates ??
        [
          const DatedTemplateSlot(
            templateId: 'tpl-1',
            templateName: 'وردية الصباح الأولى',
            startTime: '08:00',
            endTime: '16:00',
            cashierId: 'csh-1',
            cashierName: 'محمد أحمد السعيد',
            status: 'not_started',
          ),
          const DatedTemplateSlot(
            templateId: 'tpl-2',
            templateName: 'وردية المساء الثانية',
            startTime: '16:00',
            endTime: '00:00',
            cashierId: 'csh-2',
            cashierName: 'عبدالله إبراهيم محمود',
            status: 'not_started',
          ),
        ];
  }

  void _executeAtomicSwap(String idA, String idB) {
    final idxA = _templates.indexWhere((t) => t.templateId == idA);
    final idxB = _templates.indexWhere((t) => t.templateId == idB);

    if (idxA == -1 || idxB == -1) return;

    final itemA = _templates[idxA];
    final itemB = _templates[idxB];

    if (itemA.isProtected || itemB.isProtected) {
      setState(() {
        _statusMessage =
            'تعذر التبديل: إحدى الورديات نشطة أو تحتوي على قيود مالية محمية.';
      });
      return;
    }

    // Atomically swap cashiers while preserving template configurations
    setState(() {
      _templates[idxA] = itemA.copyWith(
        cashierId: itemB.cashierId,
        cashierName: itemB.cashierName,
      );
      _templates[idxB] = itemB.copyWith(
        cashierId: itemA.cashierId,
        cashierName: itemA.cashierName,
      );
      _selectedForSwap = null;
      _statusMessage = 'تم تبديل الكاشيرين بنجاح وحفظ السجل المؤرّخ ذرياً.';
    });

    widget.onSwapCompleted?.call(idA, idB);
  }

  @override
  Widget build(BuildContext context) {
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
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
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
                  SizedBox(width: 8.w),
                  Text(
                    'نطاق التاريخ المعتمد: ',
                    style: AppStyles.s13W500.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _dateRange,
                      key: const Key('txt_date_range'),
                      style: AppStyles.s13W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ),
                ],
              ),
            ),

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

            // Templates list
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                itemCount: _templates.length,
                separatorBuilder: (context, index) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final slot = _templates[index];
                  final isSelectedForSwap =
                      _selectedForSwap == slot.templateId;

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
                        // Template name and hours
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                slot.templateName,
                                key: Key('txt_tpl_name_${slot.templateId}'),
                                style: AppStyles.s14W600.copyWith(
                                  color: context.customColor.text1,
                                ),
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
                                key: Key('txt_tpl_hours_${slot.templateId}'),
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
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),

                        // Status & Action
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
                                    : 'جاهز للتعيين / التبديل',
                                style: AppStyles.s11W400.copyWith(
                                  color: slot.isProtected
                                      ? Colors.amber.shade900
                                      : Colors.green.shade900,
                                ),
                              ),
                            ),

                            // Swap action button
                            if (!slot.isProtected)
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
                                onPressed: () {
                                  if (_selectedForSwap == null) {
                                    setState(() {
                                      _selectedForSwap = slot.templateId;
                                      _statusMessage =
                                          'اختر القالب الآخر لإتمام التبديل الذري.';
                                    });
                                  } else if (_selectedForSwap ==
                                      slot.templateId) {
                                    setState(() {
                                      _selectedForSwap = null;
                                      _statusMessage = null;
                                    });
                                  } else {
                                    _executeAtomicSwap(
                                      _selectedForSwap!,
                                      slot.templateId,
                                    );
                                  }
                                },
                                child: Text(
                                  isSelectedForSwap
                                      ? 'إلغاء'
                                      : (_selectedForSwap == null
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
