import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/enums/shift_status/shift_status.dart';
import '../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/widgets/app_button.dart';
import '../../../logic/cashier/start_cashier_shift_cubit.dart';

class CashierStartShiftButton extends StatelessWidget {
  const CashierStartShiftButton({
    super.key,
    required this.selectedShiftsStatus,
    required this.shiftId,
    this.actorRole,
    this.canStart = true,
    this.disabledReason,
  });
  final String shiftId;
  final ShiftStatus selectedShiftsStatus;
  final UserType? actorRole;
  final bool canStart;
  final String? disabledReason;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartCashierShiftCubit, StartCashierShiftState>(
      buildWhen: (prev, curr) {
        final prevId = prev is StartCashierShiftLoading
            ? prev.loadingShiftId
            : null;
        final currId = curr is StartCashierShiftLoading
            ? curr.loadingShiftId
            : null;
        return prevId != currId;
      },
      builder: (context, state) {
        final isLoading =
            state is StartCashierShiftLoading &&
            state.loadingShiftId == shiftId;

        if (isLoading) {
          return const Expanded(child: AppButtonLoading());
        }
        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppButton(
                padding: EdgeInsets.all(12.w),
                borderRadius: BorderRadius.circular(12.r),
                onClick: () {
                  if (canStart) {
                    context.read<StartCashierShiftCubit>().startShift(
                      shiftId: shiftId,
                      actorRole: actorRole,
                    );
                  }
                },
                text: context.tr.start_shift,
                enabled: canStart,
                isTransparent: !canStart,
                borderColor: context.customColor.border,
              ),
              if (!canStart && disabledReason != null && disabledReason!.isNotEmpty) ...[
                4.verticalSpace,
                Text(
                  disabledReason!,
                  style: AppStyles.s10W400.copyWith(color: context.customColor.error),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
