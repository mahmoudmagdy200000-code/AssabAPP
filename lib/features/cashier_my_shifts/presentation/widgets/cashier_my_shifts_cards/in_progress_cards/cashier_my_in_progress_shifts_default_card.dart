import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../core/styles/app_colors.dart';
import '../../../../../../core/styles/app_styles.dart';
import '../../../../../../core/utils/app_bottom_sheet.dart';
import '../../../../../../core/widgets/app_button.dart';
import '../../../../../../core/widgets/custom_divider.dart';
import '../../../../../shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/end_shift_options_bottom_sheet.dart';
import '../../../../../shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/shift_card_widgets/shift_card.dart';
import '../../../../../shift_module_features/shift_management/presentation/ui/widgets/shift_details_widgets/see_details_button_widget.dart';
import '../../../../domain/entities/cashier_my_shift_entity.dart';
import '../../../cubits/cashier_my_shifts_cubit.dart';
import '../../../formatter/cashier_shift_date_formatter.dart';
import '../../../formatter/cashier_shift_time_formatter.dart';
import '../card_label_widget.dart';

class CashierMyInProgressShiftsDefaultCard extends StatefulWidget {
  const CashierMyInProgressShiftsDefaultCard({super.key, required this.shift});

  final CashierShiftEntity shift;

  @override
  State<CashierMyInProgressShiftsDefaultCard> createState() =>
      _CashierMyInProgressShiftsDefaultCardState();
}

class _CashierMyInProgressShiftsDefaultCardState
    extends State<CashierMyInProgressShiftsDefaultCard> {
  late Duration remaining;
  late ValueNotifier<Duration> remainingNotifier;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _calculateRemaining();

    remainingNotifier = ValueNotifier<Duration>(remaining);

    _startTimer();
  }

  void _calculateRemaining() {
    final now = DateTime.now();

    final timeParts = widget.shift.endTime.split(':');

    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    final shiftStart = DateTime(
      widget.shift.date.year,
      widget.shift.date.month,
      widget.shift.date.day,
      hour,
      minute,
    );

    remaining = shiftStart.difference(now);
    if (remaining.isNegative) {
      remaining = Duration.zero;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remaining.inSeconds <= 0) {
        _timer?.cancel();
        return;
      }
      remaining -= const Duration(seconds: 1);
      remainingNotifier.value = remaining;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    remainingNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 10.h),
      child: Container(
        padding: EdgeInsetsGeometry.all(15.w),
        width: 340.w,
        decoration: BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  CashierShiftDateFormatter.format(widget.shift.date),
                  style: AppStyles.s15W600,
                ),
                CardLabelWidget(
                  title: context.tr.inProgress,
                  textColor: AppColors.lightGreen,
                ),
              ],
            ),

            12.verticalSpace,
            CustomDivider(color: context.customColor.border),
            12.verticalSpace,

            buildShiftCardRowWidget(
              context: context,
              firstTitleSvgAsset: AppAssets.clockSvg,
              title: context.tr.end_time,
              value: CashierShiftTimeFormatter.format(widget.shift.endTime),
            ),

            12.verticalSpace,

            buildShiftCardRowWidget(
              context: context,
              title: context.tr.closing_balance,
              firstTitleSvgAsset: AppAssets.cash,
              value: (widget.shift.closingBalance ?? 0).toString(),
              firstValueSvgAsset: AppAssets.saudiRiyal,
            ),

            12.verticalSpace,

            buildShiftCardRowWidget(
              context: context,
              firstTitleSvgAsset: AppAssets.personSvg,
              title: context.tr.next_cashier,
              value: widget.shift.nextCashier ?? context.tr.no_name,
            ),

            15.verticalSpace,
            CustomDivider(color: context.customColor.border),

            12.verticalSpace,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ValueListenableBuilder<Duration>(
                  valueListenable: remainingNotifier,
                  builder: (_, value, __) {
                    return Expanded(
                      child: AppButton(
                        padding: EdgeInsets.all(15.w),
                        borderRadius: BorderRadius.circular(12.r),
                        onClick: () {
                          AppBottomSheet.showModal(
                            context,
                            isScrollControlled: true,
                            (sheetContext) => EndShiftOptionsBottomSheet(
                              shiftId: widget.shift.id,
                              hasEnded: true,
                              isCashierUserType: true,
                              onSuccessEndedOrReassigned: () {
                                context
                                    .read<CashierMyShiftsCubit>()
                                    .getInProgressShifts();
                                context
                                    .read<CashierMyShiftsCubit>()
                                    .getCompletedShifts();
                              },
                            ),
                          );
                        },
                        text: context.tr.end_shift,
                        enabled: value.inSeconds <= 0,
                      ),
                    );
                  },
                ),
                12.horizontalSpace,
                Expanded(
                  child: SeeDetailsButtonWidget(
                    shiftId: widget.shift.id,
                    isCashier: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
