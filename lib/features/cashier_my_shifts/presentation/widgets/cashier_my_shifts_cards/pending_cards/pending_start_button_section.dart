import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/helpers/shift_start_window_helper.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/features/cashier_my_shifts/domain/entities/cashier_my_shift_entity.dart';
import 'package:assab/features/cashier_my_shifts/domain/enums/my_shifts_status.dart';
import 'package:flutter/material.dart';

/// Renders the Start Shift action button together with the localized backend/window/turn-order reason when disabled.
class PendingStartButtonSection extends StatelessWidget {
  const PendingStartButtonSection({
    super.key,
    required this.shift,
    this.onStartPressed,
    this.now,
    this.isFlexible = false,
  });

  final CashierShiftEntity shift;
  final VoidCallback? onStartPressed;
  final DateTime? now;
  final bool isFlexible;

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final eligibility = ShiftStartWindowHelper.resolvePendingStartEligibility(
      shiftDate: shift.date,
      startTime: shift.startTime,
      endTime: shift.endTime,
      isNextShift: shift.isNextShift ?? false,
      isReassigned: shift.status == MyShiftStatusType.reassigned,
      serverCanStart: shift.canStart,
      serverDisabledReason: shift.startDisabledReason,
      now: now,
      languageCode: lang,
    );

    final enabled = eligibility.canStart && onStartPressed != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton(
          padding: EdgeInsets.all(15.w),
          borderRadius: BorderRadius.circular(12.r),
          onClick: enabled ? onStartPressed! : () {},
          text: context.tr.start_shift,
          isFlexible: isFlexible,
          isTransparent: !enabled,
          borderColor: context.customColor.border,
          enabled: enabled,
        ),
        if (!eligibility.canStart && eligibility.reason != null) ...[
          6.verticalSpace,
          Text(
            eligibility.reason!,
            style: AppStyles.s10W400.copyWith(color: context.customColor.error),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
