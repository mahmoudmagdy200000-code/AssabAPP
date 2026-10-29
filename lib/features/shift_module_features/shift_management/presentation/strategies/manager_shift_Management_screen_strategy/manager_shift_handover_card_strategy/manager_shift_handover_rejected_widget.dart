import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/features/shift_module_features/shift_management/data/mapper/shift/shift_details/handover_status_ui_mapper.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/handover_details_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/strategies/manager_shift_Management_screen_strategy/manager_shift_handover_card_strategy/manager_shift_handover_widget_strategy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/di/dependency_injection.dart';
import '../../../../../../../core/enums/shift_status/shift_handover_status.dart';
import '../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../core/styles/app_colors.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../../../../core/widgets/app_svg.dart';
import '../../../../../../../core/widgets/custom_divider.dart';
import '../../../logic/manager_shift/manager_shift_cubit.dart';
import '../../../logic/shifts/variance/variance_cubit.dart';
import '../../../ui/widgets/cashier_shifts_management_widgets/cashier_info_container_widget.dart';
import '../../../ui/widgets/cashier_shifts_management_widgets/shift_card_widgets/shift_card.dart';
import '../../../ui/widgets/manager_shift_management_widgets/manager_approve_button_widget.dart';
import '../../../ui/widgets/manager_shift_management_widgets/manager_see_details_button_widget.dart';
import '../../../ui/widgets/variance/variance_details_bottom_sheet_widget.dart';
class ManagerShiftHandoverRejectedWidget
    extends ManagerShiftHandoverCardStrategy {
  final HandoverDetailsEntity handover;
  final bool showButtons;
  final String managerName;
  ManagerShiftHandoverRejectedWidget({
    required this.handover,
    this.showButtons = true,
    required this.managerName,
  });
  @override
  Widget buildTabContent(BuildContext context) {
    return CashierInfoContainerWidget(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.tr.handover, style: AppStyles.s13W600),
            Container(
              color: Colors.white,
              alignment: Alignment.center,
              padding: EdgeInsets.all(3.w),
              child: Text(
                handover.handoverStatus.label,
                style: AppStyles.s12W500.copyWith(
                  color: handover.handoverStatus.textColor,
                ),
              ),
            ),
          ],
        ),
        1.verticalSpace,
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
          title: context.tr.variance,
          firstTitleSvgAsset: AppAssets.personSvg,
          firstValueSvgAsset: AppAssets.saudiRiyal,
          hasSpaceBetweenTitleAndValue: true,
          value: handover.varianceAmount.toStringAsFixed(2),
        ),
        if (handover.varianceAmount != 0) // Variance != 0
        ...[
          1.verticalSpace,
          AppGestureDetectorButton(
            onTap: () {
              // final strategy= VarianceStrategyFactory.create(handover.);
              AppBottomSheet.showModal(context, (context) {
                return BlocProvider(
                  create: (context) => getIt<VarianceCubit>(),
                  child: VarianceDetailsBottomSheetWidget(
                    handoverAmount: handover.handoverAmount,
                    varianceAmount: handover.varianceAmount,
                    shiftId: handover.cashierShiftId,
                  ),
                );
              }, isScrollControlled: true);
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: AppColors.darkOrange.withAlpha(10),
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline_outlined,
                    color: AppColors.darkOrange,
                    size: 17.w,
                  ),
                  13.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr.attachment,
                          textAlign: TextAlign.start,
                          style: AppStyles.s14W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        Text(
                          context.tr.varianceReasonWasAddedDuringHandover,
                          textAlign: TextAlign.start,
                          softWrap: true,
                          style: AppStyles.s14W400.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSvg(
                    assetName: Directionality.of(context) == TextDirection.ltr
                        ? AppAssets.arrowRight
                        : AppAssets.arrowLeft,
                    colorFilter: const ColorFilter.mode(
                      AppColors.sBlack,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        1.verticalSpace,
        buildShiftCardRowWidget(
          context: context,
          title: context.tr.handoverTo,
          firstTitleSvgAsset: AppAssets.personSvg,
          hasSpaceBetweenTitleAndValue: true,
          value: handover.handoverTo ?? context.tr.no_name,
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
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
          decoration: BoxDecoration(color: handover.handoverStatus.cardColor),
          child: Text(
            context.tr.youRequestedEmployeeToCorrect(handover.handoverFrom),
            textAlign: TextAlign.center,
            style: AppStyles.s13W500.copyWith(
              color: handover.handoverStatus.textColor,
            ),
          ),
        ),
        const CustomDivider(),
        if (showButtons)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ManagerApproveButtonWidget(
                buttonWidth: 150.w,
                cashierShiftId: handover.cashierShiftId,
                cashierName: handover.cashierName,
                cashFrom: handover.cashierName,
                cashGiven: handover.handoverAmount,
                variance: handover.varianceAmount,
                managerName: managerName,
                successFunction: () {
                  context.read<ManagerShiftCubit>().getCurrentShift();
                },
                isTheCurrentStatusRejected:
                    handover.handoverStatus == HandoverStatus.rejected,
                openedFromModalSheet: true,
              ),
              ManagerSeeDetailsButtonWidget(
                buttonWidth: 150.w,
                handover: handover,
              ),
            ],
          ),
      ],
    );
  }
}
