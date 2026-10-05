import 'package:assab/core/widgets/app_scaffold.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/end_shift_response_entites/manager_shift_end_data_entity.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../../core/styles/app_colors.dart';
import '../../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../../core/widgets/app_svg.dart';
import '../../../../../../../../core/widgets/custom_divider.dart';
import '../../add_cashier/details_summarize_widget.dart';
import '../../cashier_shifts_management_widgets/shift_card_widgets/shift_card.dart';

class EndManagerShiftBottomModalSheetWidget extends StatelessWidget {
  final Widget? widget;
  const EndManagerShiftBottomModalSheetWidget({
    super.key,
    this.widget,
    required this.managerShift,
  });

  final ManagerShiftEndDataEntity managerShift;
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 20.h, horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                context.tr.managersHandover(
                  managerShift.finalHandover.handoverFrom,
                ),
                style: AppStyles.s20W500,
              ),
              2.verticalSpace,
              Text(
                context.tr.seeDetailsOfManagerHandover(
                  managerShift.finalHandover.handoverFrom,
                ),
                textAlign: TextAlign.center,
                style: AppStyles.s14W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),

              7.verticalSpace,
              const CustomDivider(),
              10.verticalSpace,

              AppSvg(
                assetName: AppAssets.noProfile,
                height: 100.h,
                width: 100.w,
              ),

              if (widget != null) widget!,

              15.verticalSpace,
              SummarizeCardWidget(
                height: 290.h,
                columnSpacing: 15.h,
                children: [
                  Container(
                    padding: EdgeInsets.all(12.r),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.lightGray,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(context.tr.totalSales, style: AppStyles.s16W600),
                        10.verticalSpace,

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AppSvg(
                              assetName: AppAssets.saudiRiyal,
                              width: 30.w,
                              height: 25.h,
                            ),
                            4.horizontalSpace,
                            Text(
                              managerShift.dailyTotals.totalSales.toString(),
                              style: AppStyles.s16W600,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  2.verticalSpace,

                  Text(
                    context.tr.salesBreakDown,
                    style: AppStyles.s14W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),

                  SizedBox(width: 250.w, child: const CustomDivider()),

                  buildShiftCardRowWidget(
                    context: context,
                    firstTitleSvgAsset: AppAssets.cash,
                    title: context.tr.cashCollected,
                    value: managerShift.dailyTotals.totalCashCollected
                        .toString(),
                    firstValueSvgAsset: AppAssets.saudiRiyal,
                    hasSpaceBetweenTitleAndValue: true,
                  ),

                  buildShiftCardRowWidget(
                    context: context,
                    firstTitleSvgAsset: AppAssets.cash,
                    title: context.tr.cardPayment,
                    value: managerShift.dailyTotals.totalCardPayments
                        .toString(),
                    firstValueSvgAsset: AppAssets.saudiRiyal,
                    hasSpaceBetweenTitleAndValue: true,
                  ),

                  buildShiftCardRowWidget(
                    context: context,
                    firstTitleSvgAsset: AppAssets.cash,
                    title: context.tr.deliveryApps,
                    value: managerShift.dailyTotals.totalDeliveryApps
                        .toString(),
                    firstValueSvgAsset: AppAssets.saudiRiyal,
                    hasSpaceBetweenTitleAndValue: true,
                  ),
                ],
              ),

              10.verticalSpace,

              SummarizeCardWidget(
                height: 220.h,
                children: [
                  Text(
                    context.tr.handoverDetails,
                    style: AppStyles.s14W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),

                  buildShiftCardRowWidget(
                    context: context,
                    firstTitleSvgAsset: AppAssets.cash,
                    title: context.tr.handOverAmount,
                    value: managerShift.finalHandover.handoverAmount.toString(),
                    firstValueSvgAsset: AppAssets.saudiRiyal,
                    hasSpaceBetweenTitleAndValue: true,
                  ),

                  buildShiftCardRowWidget(
                    context: context,
                    firstTitleSvgAsset: AppAssets.cash,
                    value: managerShift.dailyTotals.totalVariance
                        .abs()
                        .toString(),
                    title: context.tr.variance,
                    firstValueSvgAsset: AppAssets.saudiRiyal,
                    hasSpaceBetweenTitleAndValue: true,
                  ),

                  buildShiftCardRowWidget(
                    context: context,
                    firstTitleSvgAsset: AppAssets.personSvg,
                    value: managerShift.finalHandover.handoverFrom,
                    title: context.tr.handoverFrom,
                    hasSpaceBetweenTitleAndValue: true,
                  ),

                  buildShiftCardRowWidget(
                    context: context,
                    firstTitleSvgAsset: AppAssets.personSvg,
                    value: managerShift.finalHandover.handoverTo,
                    title: context.tr.handoverTo,
                    hasSpaceBetweenTitleAndValue: true,
                  ),

                  buildShiftCardRowWidget(
                    context: context,
                    firstTitleSvgAsset: AppAssets.calendar,
                    value: managerShift.finalHandover.formattedHandoverDate,
                    title: context.tr.handoverDate,
                    hasSpaceBetweenTitleAndValue: true,
                  ),

                  buildShiftCardRowWidget(
                    context: context,
                    firstTitleSvgAsset: AppAssets.clockSvg,
                    value: managerShift.finalHandover.formattedHandoverTime,
                    title: context.tr.handoverTime,
                    hasSpaceBetweenTitleAndValue: true,
                  ),
                ],
              ),

              10.verticalSpace,

              SummarizeCardWidget(
                height: 140.h,
                children: [
                  Text(
                    context.tr.openingBalance,
                    style: AppStyles.s14W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),

                  buildShiftCardRowWidget(
                    context: context,
                    firstTitleSvgAsset: AppAssets.cash,
                    value: '0',
                    title: context.tr.cash_given,
                    firstValueSvgAsset: AppAssets.saudiRiyal,
                    hasSpaceBetweenTitleAndValue: true,
                  ),

                  buildShiftCardRowWidget(
                    context: context,
                    firstTitleSvgAsset: AppAssets.cash,
                    value: managerShift.dailyTotals.totalVariance
                        .abs()
                        .toString(),
                    title: context.tr.variance,
                    firstValueSvgAsset: AppAssets.saudiRiyal,
                    hasSpaceBetweenTitleAndValue: true,
                  ),

                  buildShiftCardRowWidget(
                    context: context,
                    firstTitleSvgAsset: AppAssets.cash,
                    value: managerShift.finalHandover.handoverFrom,
                    title: context.tr.cashFrom,
                    hasSpaceBetweenTitleAndValue: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
