import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_time_details_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/reassign_shift/reassign_shift_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/widgets/app_padding_widget.dart';
import '../../../../../../../core/widgets/custom_divider.dart';
import '../../../../../../../core/widgets/custom_text_field.dart';
import '../add_cashier/details_summarize_widget.dart';
import '../shift_details_widgets/shift_details_container_widget.dart';
import '../shift_details_widgets/shift_details_row_widget.dart';
import '../shift_details_widgets/shift_progress_indicator_widget.dart';

class ReassignShiftSummaryWidget extends StatelessWidget {
  final bool isInProgress;
  const ReassignShiftSummaryWidget({super.key, this.isInProgress = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReassignShiftCubit, ReassignShiftState>(
      builder: (context, state) {
        final previousCashier = context
            .read<ReassignShiftCubit>()
            .previousCashier;
        final nextCashier = context.read<ReassignShiftCubit>().nextCashier;
        final selectedCashier = context
            .read<ReassignShiftCubit>()
            .selectedCashier;
        final shift = context.read<ReassignShiftCubit>().shift;

        return SingleChildScrollView(
          child: AppPaddingWidget(
            right: 5.w,
            left: 5.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.tr.reviewBeforeProceed, style: AppStyles.s20W500),
                2.verticalSpace,
                Text(
                  context.tr.reviewBeforeProceedReassignDesc,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
                7.verticalSpace,
                const CustomDivider(),

                if (isInProgress) ...[
                  ShiftDetailsContainerWidget(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.tr.pendingTime, style: AppStyles.s16W600),

                        15.verticalSpace,

                        const CustomDivider(),

                        10.verticalSpace,

                        ShiftProgressIndicator(
                          startTime: shift.shiftTimeDetails.startTime,
                          endTime: shift.shiftTimeDetails.endTime,
                          actualStart: shift.actualStartTime,
                          actualEnd: shift.actualEndTime,
                        ),
                      ],
                    ),
                  ),
                  10.verticalSpace,
                ],

                15.verticalSpace,
                SummarizeCardWidget(
                  height: 310.h,
                  columnSpacing: 15.h,
                  children: [
                    2.verticalSpace,
                    Text(
                      context.tr.newShiftDetails,
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),

                    SizedBox(width: 250.w, child: const CustomDivider()),

                    ShiftDetailsRowWidget(
                      iconSVGAsset: AppAssets.personSvg,
                      title: context.tr.previousCasherTitle,
                      value: previousCashier?.name ?? context.tr.no_name,
                    ),

                    ShiftDetailsRowWidget(
                      iconSVGAsset: AppAssets.personSvg,
                      title: context.tr.newCasherTitle,
                      value: selectedCashier?.name ?? context.tr.no_name,
                    ),
                    ShiftDetailsRowWidget(
                      iconSVGAsset: AppAssets.calendar,
                      title: context.tr.shiftDateTitle,
                      value: shift.shiftDateFormatted,
                    ),

                    ShiftDetailsRowWidget(
                      iconSVGAsset: AppAssets.clockSvg,
                      title: context.tr.start_time,
                      value: shift.shiftTimeDetails.formattedStartTime,
                    ),

                    ShiftDetailsRowWidget(
                      iconSVGAsset: AppAssets.clockSvg,
                      title: context.tr.end_time,
                      value: shift.shiftTimeDetails.formattedEndTime,
                    ),

                    SizedBox(width: 250.w, child: const CustomDivider()),

                    ShiftDetailsRowWidget(
                      iconSVGAsset: AppAssets.personSvg,
                      title: context.tr.next_cashier,
                      value:
                          context
                              .read<ReassignShiftCubit>()
                              .selectedCashier
                              ?.name ??
                          context.tr.no_name,
                    ),
                  ],
                ),

                10.verticalSpace,

                Text(context.tr.reasonForReassign, style: AppStyles.s14W500),

                10.verticalSpace,

                Container(
                  height: 130.h,
                  decoration: BoxDecoration(
                    color: context.customColor.text2,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 18.r,
                    horizontal: 16.r,
                  ),
                  child: CustomTextField(
                    hintText: context.tr.optionalNote,
                    maxLines: 7,
                    onChanged: (value) {
                      context
                          .read<ValidationCubit>()
                          .validateFieldAndStoreValue(
                            fieldName: 'reason',
                            value: value,
                            isValid: value.isNotEmpty,
                          );
                    },
                  ),
                ),

                10.verticalSpace,
              ],
            ),
          ),
        );
      },
    );
  }
}
