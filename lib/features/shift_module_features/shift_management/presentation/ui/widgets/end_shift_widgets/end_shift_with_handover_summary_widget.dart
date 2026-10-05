import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/end_shift_aggregator_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/styles/app_colors.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/widgets/app_padding_widget.dart';
import '../../../../../../../core/widgets/app_svg.dart';
import '../../../../../../../core/widgets/custom_divider.dart';
import '../../../logic/shifts/end_shift/end_shift_cubit.dart';
import '../add_cashier/details_summarize_widget.dart';
import '../cashier_shifts_management_widgets/shift_card_widgets/shift_card.dart';

class EndShiftWithHandoverSummaryWidget extends StatelessWidget {
  const EndShiftWithHandoverSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AppPaddingWidget(
        right: 5.w,
        left: 5.w,
        child:
            SalesBreakDownAndHandOverAmountWidgetForEndShiftWithHandoverSummary(
              aggregators: context.watch<EndShiftCubit>().aggregators,
            ),
      ),
    );
  }
}

class SalesBreakDownAndHandOverAmountWidgetForEndShiftWithHandoverSummary
    extends StatelessWidget {
  final Widget? widget;
  const SalesBreakDownAndHandOverAmountWidgetForEndShiftWithHandoverSummary({
    super.key,
    required this.aggregators,
    this.widget,
  });

  final List<TotalSalesAggregatorEntity> aggregators;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EndShiftCubit, EndShiftState>(
      builder: (context, state) {
        return Column(
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
                            context
                                .watch<EndShiftCubit>()
                                .totalSales
                                .toStringAsFixed(2),
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
                  value: context
                      .watch<EndShiftCubit>()
                      .cashCollected
                      .toStringAsFixed(2),
                  firstValueSvgAsset: AppAssets.saudiRiyal,
                  hasSpaceBetweenTitleAndValue: true,
                ),

                buildShiftCardRowWidget(
                  context: context,
                  firstTitleSvgAsset: AppAssets.cash,
                  title: context.tr.cardPayment,
                  value: context
                      .watch<EndShiftCubit>()
                      .cardPayments
                      .toStringAsFixed(2),
                  firstValueSvgAsset: AppAssets.saudiRiyal,
                  hasSpaceBetweenTitleAndValue: true,
                ),

                buildShiftCardRowWidget(
                  context: context,
                  firstTitleSvgAsset: AppAssets.cash,
                  title: context.tr.deliveryApps,
                  value: aggregators
                      .fold<double>(0, (sum, e) => sum + (e.amount ?? 0))
                      .toStringAsFixed(2),

                  firstValueSvgAsset: AppAssets.saudiRiyal,
                  hasSpaceBetweenTitleAndValue: true,
                ),
              ],
            ),

            10.verticalSpace,

            SummarizeCardWidget(
              height: 140.h,
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
                  value: (context.watch<EndShiftCubit>().handOverAmount ?? 0)
                      .toStringAsFixed(2),
                  title: context.tr.handOverAmount,
                  firstValueSvgAsset: AppAssets.saudiRiyal,
                  hasSpaceBetweenTitleAndValue: true,
                ),

                buildShiftCardRowWidget(
                  context: context,
                  firstTitleSvgAsset: AppAssets.cash,
                  value: (context.watch<EndShiftCubit>().varianceAmount ?? 0)
                      .toStringAsFixed(2),
                  title: context.tr.variance,
                  firstValueSvgAsset: AppAssets.saudiRiyal,
                  hasSpaceBetweenTitleAndValue: true,
                ),

                buildShiftCardRowWidget(
                  context: context,
                  firstTitleSvgAsset: AppAssets.personSvg,
                  value:
                      context.watch<EndShiftCubit>().cashier?.name ??
                      context.tr.no_name,
                  title: context.tr.handoverTo,
                  hasSpaceBetweenTitleAndValue: true,
                ),
              ],
            ),

            10.verticalSpace,
          ],
        );
      },
    );
  }
}
