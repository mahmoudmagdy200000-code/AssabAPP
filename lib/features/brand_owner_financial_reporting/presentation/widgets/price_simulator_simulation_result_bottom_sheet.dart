import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/utils/app_snack_bar.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/button_text_icon.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../../../generated/l10n.dart';
import '../../domain/entities/price_simulator_simulation_result_entity.dart';
import '../cubit/price_simulator_save_scenario_cubit.dart';
import '../cubit/price_simulator_save_scenario_state.dart';

class PriceSimulatorSimulationResultBottomSheet extends StatelessWidget {
  final PriceSimulatorSimulationResultEntity result;
  final String branchId;
  final String itemId;
  final double changePrice;
  final double expectedGrowthDecline;

  const PriceSimulatorSimulationResultBottomSheet({
    super.key,
    required this.result,
    required this.branchId,
    required this.itemId,
    required this.changePrice,
    required this.expectedGrowthDecline,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      PriceSimulatorSaveScenarioCubit,
      PriceSimulatorSaveScenarioState
    >(
      listener: (context, state) {
        if (state is PriceSimulatorSaveScenarioSuccess) {
          AppSnackBar.showSuccess(context, S.of(context).saveScenario);
        }
        if (state is PriceSimulatorSaveScenarioFailure) {
          AppDialog.showErrorDialog(context: context, failure: state.failure);
        }
      },
      builder: (context, saveState) {
        final isLoading = saveState is PriceSimulatorSaveScenarioLoading;

        return Scaffold(
          body: AppPaddingWidget(
            top: 30.r,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).simulationComplete,
                          style: AppStyles.s16W500.copyWith(
                            color: context.theme.primaryColor,
                          ),
                        ),
                        10.verticalSpace,
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xff01F6F7)),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          padding: EdgeInsets.all(12.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).simulationResults,
                                style: AppStyles.s14W500.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                              10.verticalSpace,
                              const CustomDivider(),
                              10.verticalSpace,
                              _buildRow(
                                context: context,
                                title: S.of(context).newPrice,
                                assetName: AppAssets.expenseSvg,
                                value: result.newPrice.toStringAsFixed(0),
                                showCurrency: true,
                              ),
                              10.verticalSpace,
                              const CustomDivider(),
                              10.verticalSpace,
                              _buildRow(
                                context: context,
                                title: S.of(context).expectedSales,
                                assetName: AppAssets.custody,
                                customWidget: Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      text: '${result.expectedSales} Pieces ',
                                      style: AppStyles.s13W500.copyWith(
                                        color: context.customColor.text1,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: '(',
                                          style: AppStyles.s13W500.copyWith(
                                            color: context.customColor.text1,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              '${result.expectedSalesChangePercentage.toStringAsFixed(0)}%',
                                          style: AppStyles.s13W500.copyWith(
                                            color: AppColors.red,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ')',
                                          style: AppStyles.s13W500.copyWith(
                                            color: context.customColor.text1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              10.verticalSpace,
                              const CustomDivider(),
                              10.verticalSpace,
                              _buildRow(
                                context: context,
                                title: S.of(context).newUnitProfit,
                                assetName: AppAssets.formula,
                                customWidget: Flexible(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SaudiRiyalSvgWidget(),
                                      5.horizontalSpace,
                                      Flexible(
                                        child: RichText(
                                          text: TextSpan(
                                            text:
                                                '${result.newUnitProfit.toStringAsFixed(1)} ',
                                            style: AppStyles.s13W500.copyWith(
                                              color: context.customColor.text1,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: '(',
                                                style: AppStyles.s13W500
                                                    .copyWith(
                                                      color: context
                                                          .customColor
                                                          .text1,
                                                    ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${result.newUnitProfitChangePercentage >= 0 ? '+' : ''}${result.newUnitProfitChangePercentage.toStringAsFixed(1)}%',
                                                style: AppStyles.s13W500
                                                    .copyWith(
                                                      color:
                                                          AppColors.lightGreen,
                                                    ),
                                              ),
                                              TextSpan(
                                                text: ')',
                                                style: AppStyles.s13W500
                                                    .copyWith(
                                                      color: context
                                                          .customColor
                                                          .text1,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              10.verticalSpace,
                              const CustomDivider(),
                              10.verticalSpace,
                              _buildRow(
                                context: context,
                                title: S.of(context).newMonthlyProfit,
                                assetName: AppAssets.over,
                                value: NumberFormat(
                                  '#,##0',
                                ).format(result.newMonthlyProfit),
                                showCurrency: true,
                              ),
                              10.verticalSpace,
                              const CustomDivider(),
                              10.verticalSpace,
                              _buildRow(
                                context: context,
                                title: S.of(context).profitChange,
                                assetName: AppAssets.over,
                                customWidget: Flexible(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SaudiRiyalSvgWidget(),
                                            3.horizontalSpace,
                                            Text(
                                              '${result.profitChange >= 0 ? '+' : ''}${NumberFormat('#,##0').format(result.profitChange)}',
                                              style: AppStyles.s13W500.copyWith(
                                                color:
                                                    context.customColor.text1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      5.horizontalSpace,
                                      Flexible(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            AppSvg(
                                              assetName: AppAssets.redShort,
                                              width: 14.r,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                    AppColors.lightGreen,
                                                    BlendMode.srcIn,
                                                  ),
                                            ),
                                            3.horizontalSpace,
                                            Flexible(
                                              child: Text(
                                                '${result.profitChangePercentage >= 0 ? '+' : ''}${result.profitChangePercentage.toStringAsFixed(1)}%',
                                                style: AppStyles.s12W400
                                                    .copyWith(
                                                      color:
                                                          AppColors.lightGreen,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        10.verticalSpace,
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: context.customColor.border,
                            ),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          padding: EdgeInsets.all(12.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).simulationData,
                                style: AppStyles.s14W500.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                              10.verticalSpace,
                              const CustomDivider(),
                              10.verticalSpace,
                              _buildRow(
                                context: context,
                                title: S.of(context).date,
                                assetName: AppAssets.calendar,
                                value: result.date,
                              ),
                              10.verticalSpace,
                              const CustomDivider(),
                              10.verticalSpace,
                              _buildRow(
                                context: context,
                                title: S.of(context).branch,
                                assetName: AppAssets.branchStoreSvg,
                                value: result.branchName,
                              ),
                              10.verticalSpace,
                              const CustomDivider(),
                              10.verticalSpace,
                              _buildRow(
                                context: context,
                                title: S.of(context).selectItem,
                                assetName: AppAssets.custody,
                                value: result.itemName,
                              ),
                            ],
                          ),
                        ),
                        10.verticalSpace,
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: context.customColor.border,
                            ),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          padding: EdgeInsets.all(12.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).simulationItemData,
                                style: AppStyles.s14W500.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                              10.verticalSpace,
                              const CustomDivider(),
                              10.verticalSpace,
                              _buildRow(
                                context: context,
                                title: S.of(context).currentSellingPrice,
                                assetName: AppAssets.wallet,
                                value:
                                    '${result.currentSellingPrice.toStringAsFixed(0)}',
                                showCurrency: true,
                              ),
                              10.verticalSpace,
                              const CustomDivider(),
                              10.verticalSpace,
                              _buildRow(
                                context: context,
                                title: S.of(context).productionCost,
                                assetName: AppAssets.expenseSvg,
                                value:
                                    '${result.productionCost.toStringAsFixed(1)}',
                                showCurrency: true,
                              ),
                              10.verticalSpace,
                              const CustomDivider(),
                              10.verticalSpace,
                              _buildRow(
                                context: context,
                                title: S.of(context).currentMonthlySales,
                                assetName: AppAssets.formula,
                                value: '${result.currentMonthlySales} pieces',
                              ),
                              10.verticalSpace,
                              const CustomDivider(),
                              10.verticalSpace,
                              _buildRow(
                                context: context,
                                title: S.of(context).expectedGrowth,
                                assetName: AppAssets.over,
                                value:
                                    '${result.expectedGrowthPercentage.toStringAsFixed(0)}%',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                20.verticalSpace,
                isLoading
                    ? const AppLoadingWidget()
                    : ButtonTextIcon(
                        onTap: () {
                          context
                              .read<PriceSimulatorSaveScenarioCubit>()
                              .saveScenario(
                                branchId: branchId,
                                itemId: itemId,
                                changePrice: changePrice,
                                expectedGrowthDecline: expectedGrowthDecline,
                              );
                        },
                        label: S.of(context).saveScenario,
                        icon: AppSvg(
                          assetName: AppAssets.receipt,
                          width: 16.r,
                          colorFilter: ColorFilter.mode(
                            context.customColor.text1,
                            BlendMode.srcIn,
                          ),
                        ),
                        backgroundColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(vertical: 14.r),
                        borderRadius: BorderRadius.circular(15.r),
                        spaceBetweenTextAndIcon: 7,
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRow({
    required BuildContext context,
    required String title,
    required String assetName,
    String? value,
    bool showCurrency = false,
    Widget? customWidget,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppSvg(
                assetName: assetName,
                width: 16.r,
                colorFilter: ColorFilter.mode(
                  context.customColor.text3,
                  BlendMode.srcIn,
                ),
              ),
              5.horizontalSpace,
              Flexible(
                child: Text(
                  title,
                  style: AppStyles.s13W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ),
            ],
          ),
        ),
        10.verticalSpace,
        ?customWidget,
        if (value != null && customWidget == null) ...[
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (showCurrency) const SaudiRiyalSvgWidget(),
                3.horizontalSpace,
                Flexible(
                  child: Text(
                    value,
                    style: AppStyles.s13W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
