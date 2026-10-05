import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/choose_employee/choose_employee_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/end_shift_widgets/end_shift_with_hand_over_summary_strategy/variance_summary_strategy_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../../core/widgets/app_padding_widget.dart';
import '../../../../../../../../core/widgets/app_svg.dart';
import '../../../../../../../../core/widgets/custom_divider.dart';
import '../../../../logic/shifts/end_shift/end_shift_cubit.dart';
import '../../add_cashier/details_summarize_widget.dart';
import '../../cashier_shifts_management_widgets/shift_card_widgets/shift_card.dart';
import '../../shift_row_title_and_amount.dart';
import '../../variance/selected_responsible_employee_widget.dart';
import '../../variance/variance_list_files.dart';
import '../../variance/variance_type_widget.dart';
import '../end_shift_with_handover_summary_widget.dart';

class IWasResponsibleVarianceStrategyUi extends VarianceUiStrategy {
  @override
  Widget buildUI(BuildContext context) {
    final aggregators = context.read<EndShiftCubit>().aggregators;

    return SingleChildScrollView(
      child: AppPaddingWidget(
        right: 5.w,
        left: 5.w,
        child: Column(
          children: [
            SalesBreakDownAndHandOverAmountWidgetForEndShiftWithHandoverSummary(
              aggregators: aggregators,
              widget: SummarizeCardWidget(
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
                    value: (context.read<EndShiftCubit>().cashGiven)
                        .toStringAsFixed(2),
                    title: context.tr.cash_given,
                    firstValueSvgAsset: AppAssets.saudiRiyal,
                    hasSpaceBetweenTitleAndValue: true,
                  ),
                ],
              ),
            ),

            SummarizeCardWidget(
              height: 160.h,
              children: [
                Text(
                  context.tr.varianceBreakdown,
                  style: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),

                buildShiftCardRowWidget(
                  context: context,
                  firstTitleSvgAsset: AppAssets.cash,
                  value: (context.read<EndShiftCubit>().handOverAmount ?? 0)
                      .toStringAsFixed(2),
                  title: context.tr.handOverAmount,
                  firstValueSvgAsset: AppAssets.saudiRiyal,
                  hasSpaceBetweenTitleAndValue: true,
                ),

                buildShiftCardRowWidget(
                  context: context,
                  firstTitleSvgAsset: AppAssets.cash,
                  value: (context.read<EndShiftCubit>().varianceAmount ?? 0)
                      .toStringAsFixed(2),
                  title: context.tr.variance,
                  firstValueSvgAsset: AppAssets.saudiRiyal,
                  hasSpaceBetweenTitleAndValue: true,
                ),

                buildShiftCardRowWidget(
                  context: context,
                  firstTitleSvgAsset: AppAssets.personSvg,
                  value:
                      context.read<EndShiftCubit>().cashier?.name ??
                      context.tr.no_name,
                  title: context.tr.handoverTo,
                  hasSpaceBetweenTitleAndValue: true,
                ),

                ShiftRowTitleAndAmount(
                  title: context.tr.varianceType,
                  titleStyle: AppStyles.s12W400.copyWith(
                    color: context.customColor.text4,
                  ),
                  showCurrencySymbol: false,
                  widget: VarianceTypeWidget(
                    label:
                        (context.read<EndShiftCubit>().totalSales -
                                (context
                                    .read<EndShiftCubit>()
                                    .paymentMethodsTotal)) <
                            0
                        ? context.tr.over
                        : context.tr.short,
                    assetName:
                        (context.read<EndShiftCubit>().totalSales -
                                (context
                                    .read<EndShiftCubit>()
                                    .paymentMethodsTotal)) <
                            0
                        ? AppAssets.over
                        : AppAssets.short,
                  ),
                ),
              ],
            ),

            10.verticalSpace,
            SummarizeCardWidget(
              height: 160.h,
              children: [
                Row(
                  children: [
                    AppSvg(
                      assetName: AppAssets.personSvg,
                      width: 15.h,
                      height: 15.h,
                    ),
                    5.horizontalSpace,
                    Text(
                      context.tr.varianceBreakdown,
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ],
                ),

                const CustomDivider(),

                Text(context.tr.iWasResponsible, style: AppStyles.s13W500),

                Text(
                  context.tr.iWasResponsibleDesc,
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MeAndOrVarianceStrategyUi extends VarianceUiStrategy {
  @override
  Widget buildUI(BuildContext context) {
    final aggregators = context.read<EndShiftCubit>().aggregators;
    return SingleChildScrollView(
      child: AppPaddingWidget(
        right: 5.w,
        left: 5.w,
        child: Column(
          children: [
            SalesBreakDownAndHandOverAmountWidgetForEndShiftWithHandoverSummary(
              aggregators: aggregators,
              widget: SummarizeCardWidget(
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
                    value: (context.read<EndShiftCubit>().cashGiven)
                        .toStringAsFixed(2),
                    title: context.tr.cash_given,
                    firstValueSvgAsset: AppAssets.saudiRiyal,
                    hasSpaceBetweenTitleAndValue: true,
                  ),
                ],
              ),
            ),

            SummarizeCardWidget(
              height: 160.h,
              children: [
                Text(
                  context.tr.varianceBreakdown,
                  style: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),

                buildShiftCardRowWidget(
                  context: context,
                  firstTitleSvgAsset: AppAssets.cash,
                  value: (context.read<EndShiftCubit>().handOverAmount ?? 0)
                      .toStringAsFixed(2),
                  title: context.tr.handOverAmount,
                  firstValueSvgAsset: AppAssets.saudiRiyal,
                  hasSpaceBetweenTitleAndValue: true,
                ),

                buildShiftCardRowWidget(
                  context: context,
                  firstTitleSvgAsset: AppAssets.cash,
                  value: (context.read<EndShiftCubit>().varianceAmount ?? 0)
                      .toStringAsFixed(2),
                  title: context.tr.variance,
                  firstValueSvgAsset: AppAssets.saudiRiyal,
                  hasSpaceBetweenTitleAndValue: true,
                ),

                buildShiftCardRowWidget(
                  context: context,
                  firstTitleSvgAsset: AppAssets.personSvg,
                  value:
                      context.read<EndShiftCubit>().cashier?.name ??
                      context.tr.no_name,
                  title: context.tr.handoverTo,
                  hasSpaceBetweenTitleAndValue: true,
                ),

                ShiftRowTitleAndAmount(
                  title: context.tr.varianceType,
                  titleStyle: AppStyles.s12W400.copyWith(
                    color: context.customColor.text4,
                  ),
                  showCurrencySymbol: false,
                  widget: VarianceTypeWidget(
                    label:
                        (context.read<EndShiftCubit>().totalSales -
                                (context
                                    .read<EndShiftCubit>()
                                    .paymentMethodsTotal)) <
                            0
                        ? context.tr.over
                        : context.tr.short,
                    assetName:
                        (context.read<EndShiftCubit>().totalSales -
                                (context
                                    .read<EndShiftCubit>()
                                    .paymentMethodsTotal)) <
                            0
                        ? AppAssets.over
                        : AppAssets.short,
                  ),
                ),
              ],
            ),

            10.verticalSpace,
            SummarizeCardWidget(
              height: 160.h,
              children: [
                Row(
                  children: [
                    AppSvg(
                      assetName: AppAssets.personSvg,
                      width: 15.h,
                      height: 15.h,
                    ),
                    5.horizontalSpace,
                    Text(
                      context.tr.varianceBreakdown,
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ],
                ),

                const CustomDivider(),

                Text(
                  context.tr.meAndOrOtherEmployees,
                  style: AppStyles.s13W500,
                ),

                Text(
                  context.tr.meAndOrOtherEmployeesDesc,
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ],
            ),

            10.verticalSpace,
            if (context
                .read<ChooseEmployeeCubit>()
                .state
                .selectedEmployees
                .isNotEmpty) ...[
              SizedBox(
                width: double.maxFinite,
                child: Text(
                  context.tr.countEmployeesSelected(
                    context
                        .read<ChooseEmployeeCubit>()
                        .state
                        .selectedEmployees
                        .length,
                  ),
                  style: AppStyles.s14W500,
                ),
              ),

              10.verticalSpace,

              SummarizeCardWidget(
                children: [
                  Column(
                    children: List.generate(
                      context
                          .read<ChooseEmployeeCubit>()
                          .state
                          .selectedEmployees
                          .length,
                      (index) {
                        context.read<ValidationCubit>().validateField(
                          'responsibleEmployees',
                          context
                                  .read<ChooseEmployeeCubit>()
                                  .state
                                  .selectedEmployees
                                  .length >=
                              2,
                        );

                        final cashier = context
                            .read<ChooseEmployeeCubit>()
                            .state
                            .selectedEmployees
                            .keys
                            .elementAt(index);

                        return SelectedResponsibleEmployeeWidget(
                          index: index,
                          cashier: cashier,
                          removeIcon: false,
                          length: context
                              .read<ChooseEmployeeCubit>()
                              .state
                              .selectedEmployees
                              .length,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class OtherFactorVarianceStrategyUi extends VarianceUiStrategy {
  @override
  Widget buildUI(BuildContext context) {
    final aggregators = context.read<EndShiftCubit>().aggregators;
    return SingleChildScrollView(
      child: AppPaddingWidget(
        right: 5.w,
        left: 5.w,
        child: Column(
          children: [
            SalesBreakDownAndHandOverAmountWidgetForEndShiftWithHandoverSummary(
              aggregators: aggregators,
              widget: SummarizeCardWidget(
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
                    value: (context.read<EndShiftCubit>().cashGiven)
                        .toStringAsFixed(2),
                    title: context.tr.cash_given,
                    firstValueSvgAsset: AppAssets.saudiRiyal,
                    hasSpaceBetweenTitleAndValue: true,
                  ),
                ],
              ),
            ),

            SummarizeCardWidget(
              height: 160.h,
              children: [
                Text(
                  context.tr.varianceBreakdown,
                  style: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),

                buildShiftCardRowWidget(
                  context: context,
                  firstTitleSvgAsset: AppAssets.cash,
                  value: (context.read<EndShiftCubit>().handOverAmount ?? 0)
                      .toStringAsFixed(2),
                  title: context.tr.handOverAmount,
                  firstValueSvgAsset: AppAssets.saudiRiyal,
                  hasSpaceBetweenTitleAndValue: true,
                ),

                buildShiftCardRowWidget(
                  context: context,
                  firstTitleSvgAsset: AppAssets.cash,
                  value: (context.read<EndShiftCubit>().varianceAmount ?? 0)
                      .toStringAsFixed(2),
                  title: context.tr.variance,
                  firstValueSvgAsset: AppAssets.saudiRiyal,
                  hasSpaceBetweenTitleAndValue: true,
                ),

                buildShiftCardRowWidget(
                  context: context,
                  firstTitleSvgAsset: AppAssets.personSvg,
                  value:
                      context.read<EndShiftCubit>().cashier?.name ??
                      context.tr.no_name,
                  title: context.tr.handoverTo,
                  hasSpaceBetweenTitleAndValue: true,
                ),

                ShiftRowTitleAndAmount(
                  title: context.tr.varianceType,
                  titleStyle: AppStyles.s12W400.copyWith(
                    color: context.customColor.text4,
                  ),
                  showCurrencySymbol: false,
                  widget: VarianceTypeWidget(
                    label:
                        (context.read<EndShiftCubit>().totalSales -
                                (context
                                    .read<EndShiftCubit>()
                                    .paymentMethodsTotal)) <
                            0
                        ? context.tr.over
                        : context.tr.short,
                    assetName:
                        (context.read<EndShiftCubit>().totalSales -
                                (context
                                    .read<EndShiftCubit>()
                                    .paymentMethodsTotal)) <
                            0
                        ? AppAssets.over
                        : AppAssets.short,
                  ),
                ),
              ],
            ),

            10.verticalSpace,
            SummarizeCardWidget(
              height: 160.h,
              children: [
                Row(
                  children: [
                    AppSvg(
                      assetName: AppAssets.personSvg,
                      width: 15.h,
                      height: 15.h,
                    ),
                    5.horizontalSpace,
                    Text(
                      context.tr.varianceBreakdown,
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ],
                ),

                const CustomDivider(),

                Text(context.tr.otherFactor, style: AppStyles.s13W500),

                Text(
                  context.tr.otherFactorDesc,
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ],
            ),

            if (context
                    .read<ValidationCubit>()
                    .state
                    .fieldsValue['reason']
                    ?.isNotEmpty ??
                false) ...[
              10.verticalSpace,
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),

                decoration: BoxDecoration(
                  color: context.customColor.reversedTextColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: context.customColor.border,
                    width: 1.w,
                  ),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.tr.additionalNote, style: AppStyles.s14W500),

                    15.verticalSpace,
                    Text(
                      context
                          .read<ValidationCubit>()
                          .state
                          .fieldsValue['reason']!,
                      style: AppStyles.s13W400,
                    ),
                  ],
                ),
              ),
            ],

            if (context
                    .read<ValidationCubit>()
                    .state
                    .fieldsValidity['attachments'] ??
                false) ...[
              10.verticalSpace,
              SizedBox(
                width: double.maxFinite,
                child: Text(context.tr.attachments, style: AppStyles.s14W500),
              ),
              5.verticalSpace,
              const VarianceListFiles(
                padding: EdgeInsets.zero,
                showRemoveIcon: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class MixedFactorVarianceStrategyUi extends VarianceUiStrategy {
  @override
  Widget buildUI(BuildContext context) {
    final aggregators = context.read<EndShiftCubit>().aggregators;
    return SingleChildScrollView(
      child: AppPaddingWidget(
        right: 5.w,
        left: 5.w,
        child: Column(
          children: [
            SalesBreakDownAndHandOverAmountWidgetForEndShiftWithHandoverSummary(
              aggregators: aggregators,
              widget: SummarizeCardWidget(
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
                    value: (context.read<EndShiftCubit>().cashGiven)
                        .toStringAsFixed(2),
                    title: context.tr.cash_given,
                    firstValueSvgAsset: AppAssets.saudiRiyal,
                    hasSpaceBetweenTitleAndValue: true,
                  ),
                ],
              ),
            ),

            SummarizeCardWidget(
              height: 160.h,
              children: [
                Text(
                  context.tr.varianceBreakdown,
                  style: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),

                buildShiftCardRowWidget(
                  context: context,
                  firstTitleSvgAsset: AppAssets.cash,
                  value: (context.read<EndShiftCubit>().handOverAmount ?? 0)
                      .toStringAsFixed(2),
                  title: context.tr.handOverAmount,
                  firstValueSvgAsset: AppAssets.saudiRiyal,
                  hasSpaceBetweenTitleAndValue: true,
                ),

                buildShiftCardRowWidget(
                  context: context,
                  firstTitleSvgAsset: AppAssets.cash,
                  value: (context.read<EndShiftCubit>().varianceAmount ?? 0)
                      .toStringAsFixed(2),
                  title: context.tr.variance,
                  firstValueSvgAsset: AppAssets.saudiRiyal,
                  hasSpaceBetweenTitleAndValue: true,
                ),

                buildShiftCardRowWidget(
                  context: context,
                  firstTitleSvgAsset: AppAssets.personSvg,
                  value:
                      context.read<EndShiftCubit>().cashier?.name ??
                      context.tr.no_name,
                  title: context.tr.handoverTo,
                  hasSpaceBetweenTitleAndValue: true,
                ),

                ShiftRowTitleAndAmount(
                  title: context.tr.varianceType,
                  titleStyle: AppStyles.s12W400.copyWith(
                    color: context.customColor.text4,
                  ),
                  showCurrencySymbol: false,
                  widget: VarianceTypeWidget(
                    label:
                        (context.read<EndShiftCubit>().totalSales -
                                (context
                                    .read<EndShiftCubit>()
                                    .paymentMethodsTotal)) <
                            0
                        ? context.tr.over
                        : context.tr.short,
                    assetName:
                        (context.read<EndShiftCubit>().totalSales -
                                (context
                                    .read<EndShiftCubit>()
                                    .paymentMethodsTotal)) <
                            0
                        ? AppAssets.over
                        : AppAssets.short,
                  ),
                ),
              ],
            ),

            10.verticalSpace,
            SummarizeCardWidget(
              height: 160.h,
              children: [
                Row(
                  children: [
                    AppSvg(
                      assetName: AppAssets.personSvg,
                      width: 15.h,
                      height: 15.h,
                    ),
                    5.horizontalSpace,
                    Text(
                      context.tr.varianceBreakdown,
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ],
                ),

                const CustomDivider(),

                Text(context.tr.mixeFactors, style: AppStyles.s13W500),

                Text(
                  context.tr.mixedFactorsDesc,
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ],
            ),

            10.verticalSpace,
            if (context
                .read<ChooseEmployeeCubit>()
                .state
                .selectedEmployees
                .isNotEmpty) ...[
              SizedBox(
                width: double.maxFinite,
                child: Text(
                  context.tr.countEmployeesSelected(
                    context
                        .read<ChooseEmployeeCubit>()
                        .state
                        .selectedEmployees
                        .length,
                  ),
                  style: AppStyles.s14W500,
                ),
              ),

              10.verticalSpace,

              SummarizeCardWidget(
                children: [
                  Column(
                    children: List.generate(
                      context
                          .read<ChooseEmployeeCubit>()
                          .state
                          .selectedEmployees
                          .length,
                      (index) {
                        context.read<ValidationCubit>().validateField(
                          'responsibleEmployees',
                          context
                                  .read<ChooseEmployeeCubit>()
                                  .state
                                  .selectedEmployees
                                  .length >=
                              2,
                        );

                        final cashier = context
                            .read<ChooseEmployeeCubit>()
                            .state
                            .selectedEmployees
                            .keys
                            .elementAt(index);

                        return SelectedResponsibleEmployeeWidget(
                          index: index,
                          cashier: cashier,
                          removeIcon: false,
                          length: context
                              .read<ChooseEmployeeCubit>()
                              .state
                              .selectedEmployees
                              .length,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],

            if (context
                    .read<ValidationCubit>()
                    .state
                    .fieldsValue['reason']
                    ?.isNotEmpty ??
                false) ...[
              10.verticalSpace,
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),

                decoration: BoxDecoration(
                  color: context.customColor.reversedTextColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: context.customColor.border,
                    width: 1.w,
                  ),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.tr.additionalNote, style: AppStyles.s14W500),

                    15.verticalSpace,
                    Text(
                      context
                          .read<ValidationCubit>()
                          .state
                          .fieldsValue['reason']!,
                      style: AppStyles.s13W400,
                    ),
                  ],
                ),
              ),
            ],

            if (context
                    .read<ValidationCubit>()
                    .state
                    .fieldsValidity['attachments'] ??
                false) ...[
              10.verticalSpace,
              SizedBox(
                width: double.maxFinite,
                child: Text(context.tr.attachments, style: AppStyles.s14W500),
              ),
              5.verticalSpace,
              const VarianceListFiles(
                padding: EdgeInsets.zero,
                showRemoveIcon: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
