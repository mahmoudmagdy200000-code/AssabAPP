import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/historical_final_handover_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/cashier_info_container_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/shift_card_widgets/shift_card.dart';
import 'package:flutter/material.dart';

typedef HistoricalFinalHandoverLoader =
    FutureApiResult<HistoricalFinalHandoverEntity?> Function(String date);

/// Read-only sheet allowing a Branch Manager to pick a prior date and inspect
/// their branch's historical final handover details without any mutation actions.
class HistoricalFinalHandoverSheetWidget extends StatefulWidget {
  const HistoricalFinalHandoverSheetWidget({
    super.key,
    this.initialDate,
    this.loader,
  });

  final DateTime? initialDate;
  final HistoricalFinalHandoverLoader? loader;

  @override
  State<HistoricalFinalHandoverSheetWidget> createState() =>
      _HistoricalFinalHandoverSheetWidgetState();
}

class _HistoricalFinalHandoverSheetWidgetState
    extends State<HistoricalFinalHandoverSheetWidget> {
  late DateTime _selectedDate;
  bool _isLoading = true;
  HistoricalFinalHandoverEntity? _record;
  ApiFailure? _failure;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate =
        widget.initialDate ?? DateTime(now.year, now.month, now.day).subtract(const Duration(days: 1));
    _loadForSelectedDate();
  }

  String _isoDate(DateTime dt) =>
      '${dt.year.toString().padLeft(4, '0')}-'
      '${dt.month.toString().padLeft(2, '0')}-'
      '${dt.day.toString().padLeft(2, '0')}';

  Future<void> _loadForSelectedDate() async {
    setState(() {
      _isLoading = true;
      _failure = null;
      _record = null;
    });

    final dateStr = _isoDate(_selectedDate);
    final loader =
        widget.loader ??
        ((String d) => getIt<ShiftManagementRepositoryImp>()
            .getHistoricalFinalHandoverByDate(d));

    final result = await loader(dateStr);
    if (!mounted) return;

    result.when(
      failure: (failure) => setState(() {
        _isLoading = false;
        _failure = failure;
      }),
      success: (entity) => setState(() {
        _isLoading = false;
        _record = entity;
      }),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime(now.year, now.month, now.day),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      await _loadForSelectedDate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEn = Localizations.localeOf(context).languageCode.startsWith('en');
    final dateStr = _isoDate(_selectedDate);

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      isEn
                          ? 'Previous Final Handovers'
                          : 'التسليمات النهائية السابقة',
                      style: AppStyles.s17W500,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: context.customColor.text2,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Text(
                      isEn ? 'Read Only' : 'للقراءة فقط',
                      style: AppStyles.s12W500.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                  ),
                ],
              ),
              12.verticalSpace,
              AppButton(
                onClick: _pickDate,
                enabled: true,
                isTransparent: true,
                borderColor: context.customColor.border,
                textColor: context.customColor.text1,
                borderRadius: BorderRadius.circular(10.r),
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
                text: isEn
                    ? 'Selected Date: $dateStr (Change)'
                    : 'التاريخ المختار: $dateStr (تغيير)',
              ),
              16.verticalSpace,
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: AppLoadingWidget(),
                )
              else if (_failure != null)
                AppFailureWidget(
                  failure: _failure!,
                  onRetry: _loadForSelectedDate,
                  withBorder: false,
                )
              else if (_record == null)
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: context.customColor.text2,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    isEn
                        ? 'No final handover recorded for this date'
                        : 'لا يوجد تسليم نهائي مسجّل لهذا التاريخ',
                    textAlign: TextAlign.center,
                    style: AppStyles.s14W500.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                )
              else
                _buildReadOnlyDetails(context, _record!, isEn),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyDetails(
    BuildContext context,
    HistoricalFinalHandoverEntity record,
    bool isEn,
  ) {
    return CashierInfoContainerWidget(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '${record.branchName} • ${record.shiftDate}',
                style: AppStyles.s14W500,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                record.handoverStatus.isNotEmpty
                    ? record.handoverStatus
                    : record.shiftStatus,
                style: AppStyles.s12W500,
              ),
            ),
          ],
        ),
        const CustomDivider(),
        buildShiftCardRowWidget(
          context: context,
          title: context.tr.handOverAmount,
          firstTitleSvgAsset: AppAssets.cash,
          firstValueSvgAsset: AppAssets.saudiRiyal,
          hasSpaceBetweenTitleAndValue: true,
          value: record.handoverAmount.toStringAsFixed(2),
        ),
        buildShiftCardRowWidget(
          context: context,
          title: context.tr.variance,
          firstTitleSvgAsset: AppAssets.cash,
          firstValueSvgAsset: AppAssets.saudiRiyal,
          hasSpaceBetweenTitleAndValue: true,
          value: record.variance.toStringAsFixed(2),
        ),
        buildShiftCardRowWidget(
          context: context,
          title: context.tr.handoverFrom,
          firstTitleSvgAsset: AppAssets.personSvg,
          hasSpaceBetweenTitleAndValue: true,
          value: record.handoverFrom,
        ),
        buildShiftCardRowWidget(
          context: context,
          title: context.tr.handoverTo,
          firstTitleSvgAsset: AppAssets.personSvg,
          hasSpaceBetweenTitleAndValue: true,
          value: record.handoverTo,
        ),
        buildShiftCardRowWidget(
          context: context,
          title: context.tr.handoverDate,
          firstTitleSvgAsset: AppAssets.calendar,
          hasSpaceBetweenTitleAndValue: true,
          value: record.handoverDate,
        ),
        buildShiftCardRowWidget(
          context: context,
          title: context.tr.handoverTime,
          firstTitleSvgAsset: AppAssets.clockSvg,
          hasSpaceBetweenTitleAndValue: true,
          value: record.handoverTime,
        ),
        const CustomDivider(),
        buildShiftCardRowWidget(
          context: context,
          title: isEn ? 'Total Sales' : 'إجمالي المبيعات',
          firstTitleSvgAsset: AppAssets.cash,
          firstValueSvgAsset: AppAssets.saudiRiyal,
          hasSpaceBetweenTitleAndValue: true,
          value: record.totalSales.toStringAsFixed(2),
        ),
        buildShiftCardRowWidget(
          context: context,
          title: isEn ? 'Cash Collected' : 'الكاش المحصّل',
          firstTitleSvgAsset: AppAssets.cash,
          firstValueSvgAsset: AppAssets.saudiRiyal,
          hasSpaceBetweenTitleAndValue: true,
          value: record.cashCollected.toStringAsFixed(2),
        ),
        buildShiftCardRowWidget(
          context: context,
          title: isEn ? 'Card Payments' : 'مدفوعات الشبكة',
          firstTitleSvgAsset: AppAssets.cash,
          firstValueSvgAsset: AppAssets.saudiRiyal,
          hasSpaceBetweenTitleAndValue: true,
          value: record.cardPayments.toStringAsFixed(2),
        ),
        buildShiftCardRowWidget(
          context: context,
          title: isEn ? 'Daily Close' : 'الإغلاق اليومي',
          firstTitleSvgAsset: AppAssets.clockSvg,
          hasSpaceBetweenTitleAndValue: true,
          value: record.dailyCloseSubmitted
              ? (isEn ? 'Submitted' : 'مُرسل')
              : (isEn ? 'Not Submitted' : 'غير مُرسل'),
        ),
        if (record.handoverNotes != null &&
            record.handoverNotes!.trim().isNotEmpty) ...[
          const CustomDivider(),
          Text(
            '${isEn ? 'Notes' : 'ملاحظات'}: ${record.handoverNotes!}',
            style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
          ),
        ],
        if (record.cashierBreakdown.isNotEmpty) ...[
          const CustomDivider(),
          Text(
            isEn ? 'Cashiers Handover Breakdown' : 'تفصيل تسليمات الكاشير',
            style: AppStyles.s13W600,
          ),
          ...record.cashierBreakdown.map(
            (item) => Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.cashierName,
                      style: AppStyles.s12W500,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${item.handoverAmount.toStringAsFixed(2)} SAR',
                    style: AppStyles.s12W500,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
