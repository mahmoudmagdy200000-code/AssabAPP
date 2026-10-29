import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/enums/shift_status/shift_handover_status.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/helpers/shared_preferences_helper.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/features/shift_module_features/shift_management/data/mapper/shift/shift_details/handover_status_ui_mapper.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/approve_and_reject_handover/approve_and_reject_handover_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/cashier_info_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../../core/enums/shift_status/shift_status_type.dart';
import '../../../../../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../../domain/entity/shift/shift_entity.dart';
import '../../../../logic/shifts/shift_details/shift_details_cubit.dart';
import '../../../../logic/shifts/variance/variance_cubit.dart';
import '../../../arguments/shift_arguments.dart';
import '../../cashier_shifts_management_widgets/shift_card_widgets/shift_card.dart';
import '../../manager_shift_management_widgets/manager_approve_button_widget.dart';
import '../../manager_shift_management_widgets/manager_reject_handover_button.dart';
import '../../variance/variance_details_bottom_sheet_widget.dart';
import '../handover_rejection_reason_widgets/handover_rejection_reason_bottom_sheet_widget.dart';
import '../shift_details_row_widget.dart';
import 'shift_tab_widget_strategy.dart';

class SalesAndHandoverTabWidget implements ShiftTabStrategy {
  bool allowScroll;

  SalesAndHandoverTabWidget({required this.allowScroll});

  @override
  Widget buildTabContent(
    BuildContext context, {
    required ShiftEntity shift,
    ShiftArguments? shiftArguments,
  }) {
    return Column(
      children: [
        ...(shift.status == ShiftStatusType.completed
            ? [
                allowScroll
                    ? SizedBox(
                        height: shift.handoverStatus == null
                            ? 490.h
                            : 550.h, // need to be fixed
                        child: ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          children: salesAndHandoverCards(context, shift),
                        ),
                      )
                    : Column(children: salesAndHandoverCards(context, shift)),

                if (shift.handoverStatus == null)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      border: BoxBorder.fromSTEB(
                        top: BorderSide(
                          color: context.customColor.border,
                          width: 1.w,
                        ),
                      ),
                    ),
                    child: AppButton(
                      onClick: () async {
                        final result = await NavigationService.I.pushNamed(
                          AppRouteName.handoverScreen,
                          arguments: {
                            'shiftArguments': shiftArguments,
                            'isOpenedFromShiftDetailsScreen': true,
                          },
                        );

                        if (result == true) {
                          context.read<ShiftDetailsCubit>().getShiftDetails();
                        }
                      },
                      text: context.tr.startHandover,
                      enabled: true,
                      background: AppColors.primaryLight,
                    ),
                  ),
              ]
            : [
                CashierInfoContainerWidget(
                  title: context.tr.openingBalanceTitle,
                  children: [
                    ShiftDetailsRowWidget(
                      iconSVGAsset: AppAssets.cash,
                      title: context.tr.cash_given,
                      value: shift.cashCollected == 0
                          ? context.tr.not_recorded_yet
                          : shift.cashCollected.toString(),
                    ),
                  ],
                ),
              ]),
      ],
    );
  }

  List<Widget> salesAndHandoverCards(BuildContext context, ShiftEntity shift) {
    return [
      CashierInfoContainerWidget(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
              color: context.customColor.border,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(context.tr.totalSales, style: AppStyles.s13W500),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppSvg(
                      assetName: AppAssets.saudiRiyal,
                      width: 24.w,
                      height: 24.h,
                    ),

                    Text(shift.totalSales.toString(), style: AppStyles.s16W500),
                  ],
                ),
              ],
            ),
          ),

          Text(context.tr.salesBreakDown, style: AppStyles.s13W600),

          const CustomDivider(),
          buildShiftCardRowWidget(
            context: context,
            title: context.tr.cashCollected,
            firstTitleSvgAsset: AppAssets.cash,
            firstValueSvgAsset: AppAssets.saudiRiyal,
            hasSpaceBetweenTitleAndValue: true,
            value: shift.cashCollected.toString(),
          ),
          const CustomDivider(),

          buildShiftCardRowWidget(
            context: context,
            title: context.tr.cardPayment,
            firstTitleSvgAsset: AppAssets.cash,
            firstValueSvgAsset: AppAssets.saudiRiyal,
            hasSpaceBetweenTitleAndValue: true,
            value: shift.cardPayment.toString(),
          ),
          const CustomDivider(),

          buildShiftCardRowWidget(
            context: context,
            title: context.tr.deliveryApps,
            firstTitleSvgAsset: AppAssets.cash,
            firstValueSvgAsset: AppAssets.saudiRiyal,
            hasSpaceBetweenTitleAndValue: true,
            value: shift.deliveryApps.toString(),
          ),
        ],
      ),

      20.verticalSpace,

      CashierInfoContainerWidget(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.tr.handover, style: AppStyles.s13W600),

              Container(
                color: context.customColor.reversedTextColor,
                alignment: Alignment.center,
                padding: EdgeInsets.all(3.w),
                child: Text(
                  (shift.handoverStatus?.status ?? HandoverStatus.notSubmitted)
                      .label,
                  style: AppStyles.s12W500.copyWith(
                    color:
                        (shift.handoverStatus?.status ??
                                HandoverStatus.notSubmitted)
                            .textColor,
                  ),
                ),
              ),
            ],
          ),

          buildShiftCardRowWidget(
            context: context,
            title: context.tr.cashHandoverAmount,
            firstTitleSvgAsset: AppAssets.cash,
            firstValueSvgAsset: AppAssets.saudiRiyal,
            hasSpaceBetweenTitleAndValue: true,
            value: shift.handoverAmount.toString(),
          ),

          const CustomDivider(),
          buildShiftCardRowWidget(
            context: context,
            title: context.tr.variance,
            firstTitleSvgAsset: AppAssets.cash,
            firstValueSvgAsset: AppAssets.saudiRiyal,
            hasSpaceBetweenTitleAndValue: true,
            value: shift.variance.toString(),
          ),

          if (shift.handoverStatus?.status == HandoverStatus.rejected)
            if (shift.variance != 0 && shift.variance != null) // Variance != 0
            ...[
              1.verticalSpace,
              AppGestureDetectorButton(
                onTap: () {
                  // final strategy= VarianceStrategyFactory.create(handover.);
                  AppBottomSheet.showModal(context, (context) {
                    return BlocProvider(
                      create: (context) => getIt<VarianceCubit>(),
                      child: VarianceDetailsBottomSheetWidget(
                        handoverAmount: shift.handoverAmount ?? 0,
                        varianceAmount: shift.variance ?? 0,
                        shiftId: shift.id,
                      ),
                    );
                  }, isScrollControlled: true);
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.w,
                    vertical: 5.h,
                  ),
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
                        assetName:
                            Directionality.of(context) == TextDirection.ltr
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

          const CustomDivider(),
          buildShiftCardRowWidget(
            context: context,
            title: context.tr.handoverTo,
            firstTitleSvgAsset: AppAssets.cash,
            firstValueSvgAsset: AppAssets.saudiRiyal,
            hasSpaceBetweenTitleAndValue: true,
            value: shift.handoverTo?.name ?? context.tr.no_name,
          ),

          const CustomDivider(),
          buildShiftCardRowWidget(
            context: context,
            title: context.tr.next_cashier,
            firstTitleSvgAsset: AppAssets.cash,
            firstValueSvgAsset: AppAssets.saudiRiyal,
            hasSpaceBetweenTitleAndValue: true,
            value: shift.nextCashier?.name ?? context.tr.no_name,
          ),

          2.verticalSpace,
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color:
                  (shift.handoverStatus?.status ?? HandoverStatus.notSubmitted)
                      .cardColor,
            ),
            child: Text(
              (shift.handoverStatus?.status ?? HandoverStatus.notSubmitted)
                  .text(
                    shift.handoverTo?.name ?? context.tr.no_name,
                    shift.handedOverAt,
                  ),
              textAlign: TextAlign.center,
              style: AppStyles.s13W500.copyWith(
                color:
                    (shift.handoverStatus?.status ??
                            HandoverStatus.notSubmitted)
                        .textColor,
              ),
            ),
          ),

          5.verticalSpace,
          if (shift.handoverStatus?.status == HandoverStatus.rejected)
            AppButton(
              onClick: () {
                final shiftDetailsCubit = context.read<ShiftDetailsCubit>();

                AppBottomSheet.showModal(
                  context,
                  (context) => BlocProvider.value(
                    value: shiftDetailsCubit,
                    child: HandoverRejectionReasonBottomSheetWidget(
                      shiftId: shift.id,
                      cashierName: shift.cashier.name,
                      handoverAt: shift.formattedHandedOverDateTime,
                      branchName: shift.shiftInfoDetails?.branchName ?? 'N/A',
                      cashGiven: shift.cashGiven ?? shift.handoverAmount ?? shift.closingBalance,
                      variance: shift.variance,
                    ),
                  ),
                  isScrollControlled: true,
                );
              },
              text: context.tr.reviewDetails,
              enabled: true,
              background: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(20.r),
            ),

          if (shift.handoverStatus?.status == HandoverStatus.pending &&
              shift.handoverTo?.id ==
                  getIt<SharedPreferencesHelper>().getString('u_id'))
            BlocProvider(
              create: (context) => getIt<ApproveAndRejectHandoverCubit>(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ManagerRejectHandoverButton(
                    shiftId: shift.id,
                    buttonWidth: 150.w,
                    openedFromModalSheet: false,
                    successFunction: () {
                      context.read<ShiftDetailsCubit>().getShiftDetails();
                    },
                    // cashierName: shift.cashier.name,
                    // managerName: context.tr.manager,
                    // isTheCurrentStatusRejected: shift.handoverStatus?.status == HandoverStatus.rejected,
                  ),

                  ManagerApproveButtonWidget(
                    buttonWidth: 150.w,
                    cashierShiftId: shift.id,
                    cashierName: shift.cashier.name,
                    cashFrom: shift.cashier.name,
                    cashGiven: shift.cashGiven ?? shift.handoverAmount ?? shift.closingBalance,
                    variance: shift.variance,
                    managerName: context.tr.manager,
                    successFunction: () {
                      context.read<ShiftDetailsCubit>().getShiftDetails();
                    },
                    isTheCurrentStatusRejected:
                        shift.handoverStatus?.status == HandoverStatus.rejected,
                    openedFromModalSheet: false,
                  ),
                ],
              ),
            ),
        ],
      ),

      20.verticalSpace,
    ];
  }
}
