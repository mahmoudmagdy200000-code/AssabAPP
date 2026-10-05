import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/download_service.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/utils/app_snack_bar.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../../../generated/l10n.dart';
import '../../domain/entities/price_simulator_saved_scenario_entity.dart';
import '../../domain/entities/price_simulator_simulation_result_entity.dart';
import '../cubit/price_simulator_scenario_details_cubit.dart';
import '../cubit/price_simulator_scenario_details_state.dart';
import 'brand_owner_financial_reporting_exports_buttons.dart';

class PriceSimulatorSimulationSavedSenarioDetailsBottomSheet
    extends StatelessWidget {
  final PriceSimulatorSavedScenarioEntity scenario;

  const PriceSimulatorSimulationSavedSenarioDetailsBottomSheet({
    super.key,
    required this.scenario,
  });

  @override
  Widget build(BuildContext context) {
    final result = scenario.details;

    return BlocConsumer<
      PriceSimulatorScenarioDetailsCubit,
      PriceSimulatorScenarioDetailsState
    >(
      listener: (context, state) {
        if (state is PriceSimulatorScenarioDetailsExportSuccess) {
          AppSnackBar.showSuccess(context, 'Report exported successfully');
          getIt<DownloadService>().downloadFile(
            url: state.fileUrl,
            fileName: state.fileUrl.split('/').last,
          );
        }
        if (state is PriceSimulatorScenarioDetailsExportFailure) {
          AppDialog.showErrorDialog(context: context, failure: state.failure);
        }
        if (state is PriceSimulatorScenarioDetailsEmailSuccess) {
          AppSnackBar.showSuccess(
            context,
            'Report sent via email successfully',
          );
        }
        if (state is PriceSimulatorScenarioDetailsEmailFailure) {
          AppDialog.showErrorDialog(context: context, failure: state.failure);
        }
      },
      builder: (context, detailsState) {
        final isExporting =
            detailsState is PriceSimulatorScenarioDetailsExportLoading;
        final isEmailing =
            detailsState is PriceSimulatorScenarioDetailsEmailLoading;

        return Scaffold(
          body: AppPaddingWidget(
            top: 0,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AppSvg(
                              assetName: AppAssets.receipt,
                              width: 20.r,
                              colorFilter: ColorFilter.mode(
                                context.theme.primaryColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            10.horizontalSpace,
                            Flexible(
                              child: Text(
                                S.of(context).savedScenarioResult,
                                style: AppStyles.s16W500.copyWith(
                                  color: context.theme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        10.verticalSpace,
                        _buildSimulationResults(context, result),
                        10.verticalSpace,
                        _buildSimulationData(context, result),
                        10.verticalSpace,
                        _buildSimulationItemData(context, result),
                      ],
                    ),
                  ),
                ),
                20.verticalSpace,
                isExporting || isEmailing
                    ? const AppLoadingWidget()
                    : BrandOwnerFinancialReportingExportsButtons(
                        pdf: () {
                          context
                              .read<PriceSimulatorScenarioDetailsCubit>()
                              .exportPdf(scenario.id);
                        },
                        excel: () {
                          context
                              .read<PriceSimulatorScenarioDetailsCubit>()
                              .exportExcel(scenario.id);
                        },
                        email: (emailAddress) {
                          NavigationService.I.pop();
                          context
                              .read<PriceSimulatorScenarioDetailsCubit>()
                              .emailScenario(
                                scenarioId: scenario.id,
                                email: emailAddress,
                              );
                        },
                        showText: false,
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSimulationResults(
    BuildContext context,
    PriceSimulatorSimulationResultEntity result,
  ) {
    return Container(
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
            style: AppStyles.s14W500.copyWith(color: context.customColor.text1),
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
                      style: AppStyles.s13W500.copyWith(color: AppColors.red),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SaudiRiyalSvgWidget(),
                  5.horizontalSpace,
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        text: '${result.newUnitProfit.toStringAsFixed(1)} ',
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
                                '${result.newUnitProfitChangePercentage >= 0 ? '+' : ''}${result.newUnitProfitChangePercentage.toStringAsFixed(1)}%',
                            style: AppStyles.s13W500.copyWith(
                              color: AppColors.lightGreen,
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
            value: result.newMonthlyProfit.toStringAsFixed(0),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SaudiRiyalSvgWidget(),
                        3.horizontalSpace,
                        Text(
                          '${result.profitChange >= 0 ? '+' : ''}${result.profitChange.toStringAsFixed(0)}',
                          style: AppStyles.s13W500.copyWith(
                            color: context.customColor.text1,
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
                          colorFilter: const ColorFilter.mode(
                            AppColors.lightGreen,
                            BlendMode.srcIn,
                          ),
                        ),
                        3.horizontalSpace,
                        Flexible(
                          child: Text(
                            '${result.profitChangePercentage >= 0 ? '+' : ''}${result.profitChangePercentage.toStringAsFixed(1)}%',
                            style: AppStyles.s12W400.copyWith(
                              color: AppColors.lightGreen,
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
    );
  }

  Widget _buildSimulationData(
    BuildContext context,
    PriceSimulatorSimulationResultEntity result,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.customColor.border),
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.all(12.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).simulationData,
            style: AppStyles.s14W500.copyWith(color: context.customColor.text1),
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
    );
  }

  Widget _buildSimulationItemData(
    BuildContext context,
    PriceSimulatorSimulationResultEntity result,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.customColor.border),
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.all(12.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).simulationItemData,
            style: AppStyles.s14W500.copyWith(color: context.customColor.text1),
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildRow(
            context: context,
            title: S.of(context).currentSellingPrice,
            assetName: AppAssets.wallet,
            value: result.currentSellingPrice.toStringAsFixed(0),
            showCurrency: true,
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildRow(
            context: context,
            title: S.of(context).productionCost,
            assetName: AppAssets.expenseSvg,
            value: result.productionCost.toStringAsFixed(1),
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
            value: '${result.expectedGrowthPercentage.toStringAsFixed(0)}%',
          ),
        ],
      ),
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
