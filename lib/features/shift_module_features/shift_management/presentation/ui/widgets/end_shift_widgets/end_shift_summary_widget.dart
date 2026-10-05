import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/end_shift/end_shift_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/widgets/app_padding_widget.dart';
import '../../../../../../../core/widgets/custom_divider.dart';
import '../add_cashier/details_summarize_widget.dart';
import '../cashier_shifts_management_widgets/shift_card_widgets/shift_card.dart';

class EndShiftSummaryWidget extends StatelessWidget {
  final bool isInProgress;
  const EndShiftSummaryWidget({super.key, this.isInProgress = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EndShiftCubit, EndShiftState>(
      builder: (context, state) {
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
                                    .read<EndShiftCubit>()
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
                          .read<EndShiftCubit>()
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
                          .read<EndShiftCubit>()
                          .cardPayments
                          .toStringAsFixed(2),
                      firstValueSvgAsset: AppAssets.saudiRiyal,
                      hasSpaceBetweenTitleAndValue: true,
                    ),

                    buildShiftCardRowWidget(
                      context: context,
                      firstTitleSvgAsset: AppAssets.cash,
                      title: context.tr.deliveryApps,
                      value: context
                          .read<EndShiftCubit>()
                          .aggregators
                          .fold<double>(0, (sum, e) => sum + (e.amount ?? 0))
                          .toStringAsFixed(2),

                      firstValueSvgAsset: AppAssets.saudiRiyal,
                      hasSpaceBetweenTitleAndValue: true,
                    ),
                  ],
                ),

                10.verticalSpace,

                SummarizeCardWidget(
                  height: 90.h,

                  children: [
                    Text(
                      context.tr.openingBalanceTitle,
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),

                    buildShiftCardRowWidget(
                      context: context,
                      firstTitleSvgAsset: AppAssets.cash,
                      value: context
                          .read<EndShiftCubit>()
                          .cashGiven
                          .toStringAsFixed(2),
                      title: context.tr.cash_given,
                      firstValueSvgAsset: AppAssets.saudiRiyal,
                      hasSpaceBetweenTitleAndValue: true,
                    ),
                  ],
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
