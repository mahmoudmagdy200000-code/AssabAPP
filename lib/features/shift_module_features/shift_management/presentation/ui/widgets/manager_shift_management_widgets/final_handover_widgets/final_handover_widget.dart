import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/final_handover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../../core/di/dependency_injection.dart';
import '../../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../../core/widgets/app_button.dart';
import '../../../../../../../../core/widgets/custom_divider.dart';
import '../../../../../domain/entity/manager_shift/current_shift/current_shift_entity.dart';
import '../../../../logic/manager_shift/final_daily_close/final_daily_close_cubit.dart';
import '../../../../logic/manager_shift/manager_shift_cubit.dart';
import '../../../../mappers/manager_shift_mapper/final_handover_status_ui_mapper.dart';
import '../../cashier_shifts_management_widgets/cashier_info_container_widget.dart';
import '../../cashier_shifts_management_widgets/shift_card_widgets/shift_card.dart';
import 'final_handover_summary_widget.dart';

class FinalHandoverWidget extends StatelessWidget {
  const FinalHandoverWidget({super.key, required this.currentManagerShift});

  final CurrentShiftEntity currentManagerShift;

  @override
  Widget build(BuildContext context) {
    final shift = currentManagerShift.shift;
    final handover = shift.finalHandover;
    final needsCorrection = handover.status == FinalHandOverStatus.rejected;
    final canSubmitDailyReport = shift.canSubmitDailyReport;

    return CashierInfoContainerWidget(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.tr.finalHandOver, style: AppStyles.s13W600),

            Container(
              color: Colors.white,
              alignment: Alignment.center,
              padding: EdgeInsets.all(3.w),
              child: Text(
                handover.status.label,
                style: AppStyles.s12W500.copyWith(
                  color: handover.status.textColor,
                ),
              ),
            ),
          ],
        ),

        buildShiftCardRowWidget(
          context: context,
          title: context.tr.handOverAmount,
          firstTitleSvgAsset: AppAssets.cash,
          firstValueSvgAsset: AppAssets.saudiRiyal,
          hasSpaceBetweenTitleAndValue: true,
          value: handover.handoverAmount.toStringAsFixed(2),
        ),

        1.verticalSpace,
        buildShiftCardRowWidget(
          context: context,
          title: context.tr.handoverFrom,
          firstTitleSvgAsset: AppAssets.personSvg,
          hasSpaceBetweenTitleAndValue: true,
          value: handover.handoverFrom,
        ),

        1.verticalSpace,
        buildShiftCardRowWidget(
          context: context,
          title: context.tr.handoverTo,
          firstTitleSvgAsset: AppAssets.personSvg,
          hasSpaceBetweenTitleAndValue: true,
          value: context.tr.Accountant,
        ),

        1.verticalSpace,
        buildShiftCardRowWidget(
          context: context,
          title: context.tr.accountantName,
          firstTitleSvgAsset: AppAssets.personSvg,
          hasSpaceBetweenTitleAndValue: true,
          value: handover.handoverTo,
        ),

        1.verticalSpace,
        buildShiftCardRowWidget(
          context: context,
          title: context.tr.handoverDate,
          firstTitleSvgAsset: AppAssets.calendar,
          hasSpaceBetweenTitleAndValue: true,
          value: handover.formattedHandoverDate,
        ),

        1.verticalSpace,
        buildShiftCardRowWidget(
          context: context,
          title: context.tr.handoverTime,
          firstTitleSvgAsset: AppAssets.clockSvg,
          hasSpaceBetweenTitleAndValue: true,
          value: handover.formattedHandoverTime,
        ),

        1.verticalSpace,
        if (!canSubmitDailyReport || needsCorrection)
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
            decoration: BoxDecoration(color: handover.status.cardColor),
            child: Text(
              handover.status.text(
                handover.handoverTo,
                handover.formattedHandoverDate,
              ),
              textAlign: TextAlign.center,
              style: AppStyles.s13W500.copyWith(
                color: handover.status.textColor,
              ),
            ),
          ),

        const CustomDivider(),

        if (needsCorrection || canSubmitDailyReport) ...[
          AppButton(
            onClick: () async {
              final managerCubit = context.read<ManagerShiftCubit>();
              await NavigationService.I.pushNamed(
                AppRouteName.updateManagerFinalDailyCloseScreen,
                arguments: {
                  'manager_workday_id': shift.id,
                  'branchName': shift.shiftDetails.storeBranch,
                  'managerCubit': managerCubit,
                },
              );
              if (context.mounted) await managerCubit.getCurrentShift();
            },
            enabled: true,
            borderRadius: BorderRadius.circular(10.r),
            padding: EdgeInsets.symmetric(vertical: 15.h),
            text: needsCorrection
                ? context.tr.makeCorrections
                : context.tr.submitDailyCloseFinal,
          ),
          10.verticalSpace,
        ],
        AppButton(
          onClick: () {
            AppBottomSheet.showModal(
              context,
              (context) => BlocProvider(
                create: (context) =>
                    getIt<FinalDailyCloseCubit>()
                      ..getDailyClose(managerWorkdayId: shift.id),
                child: FinalHandoverSummaryWidget(
                  currentTimeSetting: handover.currentTimeSetting,
                  handoverDate: handover.handoverDate,
                ),
              ),
              isScrollControlled: true,
            );
          },
          enabled: true,
          isTransparent: true,
          borderRadius: BorderRadius.circular(10.r),
          padding: EdgeInsets.symmetric(vertical: 15.h),
          text: context.tr.seeDetails,
        ),
      ],
    );
  }
}
