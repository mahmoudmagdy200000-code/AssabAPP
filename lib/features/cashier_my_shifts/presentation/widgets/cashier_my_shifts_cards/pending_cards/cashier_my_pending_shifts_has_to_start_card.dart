import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../core/styles/app_colors.dart';
import '../../../../../../core/styles/app_styles.dart';
import '../../../../../../core/utils/app_dialog.dart';
import '../../../../../../core/widgets/app_button.dart';
import '../../../../../../core/widgets/app_button_loading.dart';
import '../../../../../../core/widgets/custom_divider.dart';
import '../../../../../shift_module_features/shift_management/presentation/logic/cashier/start_cashier_shift_cubit.dart';
import '../../../../../shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/shift_card_widgets/shift_card.dart';
import '../../../../domain/entities/cashier_my_shift_entity.dart';
import '../../../cubits/cashier_my_shifts_cubit.dart';
import '../../../formatter/cashier_shift_date_formatter.dart';
import '../../../formatter/cashier_shift_time_formatter.dart';
import '../card_label_widget.dart';

class CashierMyPendingShiftsHasToStartCard extends StatefulWidget {
  const CashierMyPendingShiftsHasToStartCard({super.key, required this.shift});

  final CashierShiftEntity shift;

  @override
  State<CashierMyPendingShiftsHasToStartCard> createState() =>
      _CashierMyPendingShiftsHasToStartCardState();
}

class _CashierMyPendingShiftsHasToStartCardState
    extends State<CashierMyPendingShiftsHasToStartCard> {
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

    final timeParts = widget.shift.startTime.split(':');

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

  String formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes % 60;
    final seconds = d.inSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
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
                CardLabelWidget(title: context.tr.not_started),
              ],
            ),

            12.verticalSpace,
            CustomDivider(color: context.customColor.border),
            12.verticalSpace,

            ValueListenableBuilder<Duration>(
              valueListenable: remainingNotifier,
              builder: (_, value, __) {
                return buildShiftCardRowWidget(
                  context: context,
                  title: context.tr.start_time,
                  value: CashierShiftTimeFormatter.format(
                    widget.shift.startTime,
                  ),
                  firstTitleSvgAsset: AppAssets.clockSvg,
                  hasTwoRows: true,
                  secondTitle: formatDuration(value),
                  secondTitleStyle: value.inSeconds > (60 * 5)
                      ? null
                      : AppStyles.s12W400.copyWith(
                          color: context.customColor.error,
                        ),
                  secondValue: context.tr.toStart,
                );
              },
            ),

            12.verticalSpace,
            buildShiftCardRowWidget(
              context: context,
              firstTitleSvgAsset: AppAssets.cash,
              title: context.tr.openingBalance,
              value: widget.shift.openingBalance == 0
                  ? context.tr.not_recorded_yet
                  : widget.shift.openingBalance.toString(),
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

            // BlocConsumer<
            //     CashierShiftsManagementCubit,
            //     CashierShiftsManagementState
            // >(
            //   listener: (context, state) {
            //     if (state is FetchShiftsAgain) {
            //       context.read<CashierShiftsManagementCubit>().getPendingShifts(
            //         loadMore: false,
            //       );
            //     }
            //
            //     if (state is ShiftButtonFailure) {
            //       AppDialog.showErrorDialog(
            //         context: context,
            //         failure: state.failure,
            //       );
            //     }
            //   },
            //   builder: (context, state) {
            //     final isLoading = state is ShiftButtonLoading;
            //
            //     if (isLoading) {
            //       const AppButtonLoading();
            //     }
            //
            //     return Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //
            //           Expanded(
            //             child: AppButton(
            //               padding: EdgeInsets.all(12.w),
            //               borderRadius: BorderRadius.circular(12.r),
            //               onClick: () {
            //                 context
            //                     .read<CashierShiftsManagementCubit>()
            //                     .startCashierShift(
            //                   widget.shift.id,
            //                   selectedShiftsStatus,
            //                 );
            //               },
            //               text: context.tr.start_shift,
            //               enabled: true,
            //             ),
            //           ),
            //
            //         12.horizontalSpace,
            //         Expanded(child: SeeDetailsButtonWidget(shiftId: widget.shift.id)),
            //       ],
            //     );
            //   },
            // ),
            ValueListenableBuilder<Duration>(
              valueListenable: remainingNotifier,
              builder: (_, value, __) {
                // StartCashierShiftCubit
                return BlocConsumer<
                  StartCashierShiftCubit,
                  StartCashierShiftState
                >(
                  listener: (context, state) {
                    if (state is StartCashierShiftSuccess) {
                      context.read<CashierMyShiftsCubit>().getPendingShifts();
                      context
                          .read<CashierMyShiftsCubit>()
                          .getInProgressShifts();
                    } else if (state is StartCashierShiftFailure) {
                      AppDialog.showErrorDialog(
                        context: context,
                        failure: state.failure,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is StartCashierShiftLoading) {
                      return const AppButtonLoading();
                    }
                    return AppButton(
                      padding: EdgeInsets.all(15.w),
                      borderRadius: BorderRadius.circular(12.r),
                      onClick: () {
                        context
                            .read<StartCashierShiftCubit>()
                            .startCashierShift(widget.shift.id);
                      },
                      text: context.tr.start_shift,
                      isTransparent: !(value.inSeconds <= 0),
                      borderColor: context.customColor.border,
                      enabled: value.inSeconds <= 0,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
