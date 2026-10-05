import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/download_service.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_icon_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/app_svg_button.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../generated/l10n.dart';
import '../../domain/entities/brand_owner_break_even_analysis_entity.dart';
import '../../domain/strategies/brand_owner_break_even_analysis_status_strategy.dart';
import '../cubit/break_even_analysis_cubit.dart';
import '../cubit/break_even_analysis_state.dart';
import '../cubit/export_break_even_analysis_cubit.dart';
import '../cubit/export_break_even_analysis_state.dart';
import '../widgets/break_even_analysis_filter_bottom_sheet.dart';
import '../widgets/break_even_zone_chart_widget.dart';

class BrandOwnerBreakEvenAnalysisScreen extends StatefulWidget {
  const BrandOwnerBreakEvenAnalysisScreen({super.key});

  @override
  State<BrandOwnerBreakEvenAnalysisScreen> createState() =>
      _BrandOwnerBreakEvenAnalysisScreenState();
}

class _BrandOwnerBreakEvenAnalysisScreenState
    extends State<BrandOwnerBreakEvenAnalysisScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BreakEvenAnalysisCubit>().loadBreakEvenAnalysis();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BreakEvenAnalysisCubit, BreakEvenAnalysisState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.theme.primaryColor,
          body: Column(
            children: [
              AppPaddingWidget(
                top: 30.r,
                child: Row(
                  children: [
                    const AppBackButton(isTransparent: true),
                    10.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).breakEvenAnalysis,
                            style: AppStyles.s15W500.copyWith(
                              color: context.customColor.reversedTextColor,
                            ),
                          ),
                          Text(
                            switch (state) {
                              BreakEvenAnalysisSuccess(:final data) =>
                                data.branchName,
                              _ => '-',
                            },
                            style: AppStyles.s12W400.copyWith(
                              color: context.customColor.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    10.horizontalSpace,
                    AppIconButton(
                      icon: Icons.refresh,
                      onPressed: () {
                        if (state is BreakEvenAnalysisLoading) return;
                        context
                            .read<BreakEvenAnalysisCubit>()
                            .loadBreakEvenAnalysis();
                      },
                      backgroundColor: Colors.transparent,
                      iconColor: context.customColor.reversedTextColor,
                      borderColor: context.customColor.reversedTextColor,
                      borderRadius: 12.r,
                      padding: 10.r,
                      size: 16.r,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.customColor.reversedTextColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.r),
                      topRight: Radius.circular(24.r),
                    ),
                  ),
                  padding: EdgeInsets.all(16.r),
                  child: switch (state) {
                    BreakEvenAnalysisInitial() => const SizedBox.shrink(),
                    BreakEvenAnalysisLoading() => const AppLoadingWidget(),
                    BreakEvenAnalysisSuccess(:final data) => _buildContent(
                      context,
                      data,
                    ),
                    BreakEvenAnalysisFailure(:final failure) =>
                      AppFailureWidget(
                        failure: failure,
                        onRetry: () => context
                            .read<BreakEvenAnalysisCubit>()
                            .loadBreakEvenAnalysis(),
                      ),
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, BreakEvenAnalysisEntity data) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).analysisSettings,
                  style: AppStyles.s16W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                Text(
                  S.of(context).applyYourPreferredFiltersToShowBetterResults,
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                10.verticalSpace,
                _buildFilterBar(context, data),
                15.verticalSpace,
                _buildFinancialSafetyStatus(context, data),
                15.verticalSpace,
                _buildAutomaticCalculationDetails(context, data),
                15.verticalSpace,
                _buildScenarioAnalysisSection(context, data),
              ],
            ),
          ),
        ),
        20.verticalSpace,
        _buildExportSection(context, data),
      ],
    );
  }

  Widget _buildFilterBar(BuildContext context, BreakEvenAnalysisEntity data) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.customColor.border),
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Wrap(
              runSpacing: 10.r,
              children: [
                AppSvg(
                  assetName: AppAssets.calendar,
                  width: 16.r,
                  colorFilter: ColorFilter.mode(
                    context.customColor.text3,
                    BlendMode.srcIn,
                  ),
                ),
                5.horizontalSpace,
                Text(
                  '${data.monthName} ${data.year}',
                  style: AppStyles.s13W400.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                15.horizontalSpace,
                AppSvg(
                  assetName: AppAssets.branchStoreSvg,
                  width: 16.r,
                  colorFilter: ColorFilter.mode(
                    context.customColor.text3,
                    BlendMode.srcIn,
                  ),
                ),
                5.horizontalSpace,
                Text(
                  data.branchName,
                  style: AppStyles.s13W400.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ],
            ),
          ),
          10.horizontalSpace,
          AppSvgButton(
            assetName: AppAssets.filter,
            onTap: () {
              final cubit = context.read<BreakEvenAnalysisCubit>();
              AppBottomSheet.customPageRoute(
                context,
                (context) => BreakEvenAnalysisFilterBottomSheet(
                  onApplyFilter: (month, year, branchId) {
                    NavigationService.I.pop();
                    cubit.applyFilter(
                      year: year,
                      month: month.value,
                      branchId: branchId ?? '1',
                    );
                  },
                  onReset: () {
                    NavigationService.I.pop();
                    cubit.resetFilter();
                  },
                ),
              );
            },
            borderColor: context.theme.primaryColor,
            iconSize: 13.r,
            padding: EdgeInsets.all(10.r),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialSafetyStatus(
    BuildContext context,
    BreakEvenAnalysisEntity data,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: context.customColor.text2,
      ),
      padding: EdgeInsets.all(12.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).financialSafetyStatus,
            style: AppStyles.s16W500.copyWith(color: context.customColor.text1),
          ),
          10.verticalSpace,
          BrandOwnerBreakEvenAnalysisStatusStrategy.fromString(
            data.status,
          ).buildStatus(context),
        ],
      ),
    );
  }

  Widget _buildAutomaticCalculationDetails(
    BuildContext context,
    BreakEvenAnalysisEntity data,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).automaticCalculationDetails,
          style: AppStyles.s16W500.copyWith(color: context.customColor.text1),
        ),
        10.verticalSpace,
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            color: const Color(0xffDFFEFF),
          ),
          padding: EdgeInsets.all(10.r),
          child: Column(
            children: [
              _buildFixedCostsCard(context, data.fixedCosts),
              10.verticalSpace,
              _buildContributionMarginCard(context, data.contributionMargin),
              10.verticalSpace,
              _buildFormulaCard(context, data.formula),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFixedCostsCard(
    BuildContext context,
    BreakEvenAnalysisFixedCostsEntity fixedCosts,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: context.customColor.reversedTextColor,
      ),
      padding: EdgeInsets.all(12.r),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSvg(
                assetName: AppAssets.chart,
                width: 16.r,
                colorFilter: ColorFilter.mode(
                  context.customColor.text1,
                  BlendMode.srcIn,
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).monthlyFixedCosts,
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    5.verticalSpace,
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(color: context.customColor.border),
                      ),
                      child: Column(
                        children: [
                          _buildRow(
                            context: context,
                            title: S.of(context).rentAndUtilities,
                            value: fixedCosts.rentAndUtilities.toStringAsFixed(
                              0,
                            ),
                          ),
                          _buildRow(
                            context: context,
                            title: S.of(context).salaries,
                            value: fixedCosts.salaries.toStringAsFixed(0),
                          ),
                          _buildRow(
                            context: context,
                            title: S.of(context).insuranceAndLicenses,
                            value: fixedCosts.insuranceAndLicenses
                                .toStringAsFixed(0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildRow(
            context: context,
            title: S.of(context).totalFixed,
            value: fixedCosts.totalFixed.toStringAsFixed(0),
            icon: AppAssets.formula,
            iconColor: context.theme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildContributionMarginCard(
    BuildContext context,
    BreakEvenAnalysisContributionMarginEntity contributionMargin,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: context.customColor.reversedTextColor,
      ),
      padding: EdgeInsets.all(12.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSvg(
            assetName: AppAssets.chart,
            width: 16.r,
            colorFilter: ColorFilter.mode(
              context.customColor.text1,
              BlendMode.srcIn,
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).contributionMargin,
                  style: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                5.verticalSpace,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(color: context.customColor.border),
                  ),
                  child: Column(
                    children: [
                      _buildRow(
                        context: context,
                        title: S.of(context).grossProfitMargin,
                        value:
                            '${contributionMargin.grossProfitMargin.toStringAsFixed(1)}%',
                        showCurrency: false,
                      ),
                      _buildRow(
                        context: context,
                        title: S.of(context).variableCosts,
                        value:
                            '${contributionMargin.variableCosts.toStringAsFixed(1)}%',
                        showCurrency: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormulaCard(
    BuildContext context,
    BreakEvenAnalysisFormulaEntity formula,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: context.customColor.reversedTextColor,
      ),
      padding: EdgeInsets.all(12.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSvg(
            assetName: AppAssets.formula,
            width: 16.r,
            colorFilter: ColorFilter.mode(
              context.customColor.text1,
              BlendMode.srcIn,
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).formula,
                  style: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                5.verticalSpace,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(color: context.customColor.border),
                  ),
                  padding: EdgeInsets.all(12.r),
                  child: Column(
                    children: [
                      Text(
                        'Break-even = Fixed Costs \u00f7 Contribution Margin',
                        style: AppStyles.s13W400.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                      10.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              '= ${formula.fixedCosts.toStringAsFixed(0)} \u00f7 ${formula.contributionMargin.toStringAsFixed(3)} =',
                              style: AppStyles.s13W400.copyWith(
                                color: context.customColor.text3,
                              ),
                            ),
                          ),
                          10.horizontalSpace,
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SaudiRiyalSvgWidget(),
                                3.horizontalSpace,
                                Text(
                                  formula.result.toStringAsFixed(0),
                                  style: AppStyles.s13W500.copyWith(
                                    color: context.customColor.text1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioAnalysisSection(
    BuildContext context,
    BreakEvenAnalysisEntity data,
  ) {
    return Column(
      children: [
        Text(
          S.of(context).scenarioAnalysisInteractiveChart,
          style: AppStyles.s16W500.copyWith(color: context.customColor.text1),
        ),
        5.verticalSpace,
        Text(
          S.of(context).whatIfConditionsChange,
          style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
        ),
        10.verticalSpace,
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            color: context.customColor.text2,
          ),
          padding: EdgeInsets.all(12.r),
          child: Column(
            children: [
              Text(
                S.of(context).interactiveChartForRiskAssessment,
                style: AppStyles.s14W500.copyWith(
                  color: context.customColor.text4,
                ),
              ),
              10.verticalSpace,
              BreakEvenChart(
                data: BreakEvenChartData.fromApiValues(
                  currentPointXInt: data.metrics.currentPointX.toInt(),
                  currentPointY: data.metrics.currentPointY,
                  fixedCostXInt: data.metrics.fixedCostX.toInt(),
                  fixedCostY: data.metrics.fixedCostY,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExportSection(
    BuildContext context,
    BreakEvenAnalysisEntity data,
  ) {
    return BlocListener<
      ExportBreakEvenAnalysisCubit,
      ExportBreakEvenAnalysisState
    >(
      listener: (context, state) {
        if (state is ExportBreakEvenAnalysisSuccess) {
          getIt<DownloadService>().downloadFile(
            url: state.fileUrl,
            fileName: state.fileUrl.split('/').last,
          );
        } else if (state is ExportBreakEvenAnalysisFailure) {
          AppDialog.showErrorDialog(context: context, failure: state.failure);
        }
      },
      child:
          BlocBuilder<
            ExportBreakEvenAnalysisCubit,
            ExportBreakEvenAnalysisState
          >(
            builder: (context, exportState) {
              return switch (exportState) {
                ExportBreakEvenAnalysisLoading() => const AppLoadingWidget(),
                _ => ButtonTextIcon(
                  onTap: () {
                    context
                        .read<ExportBreakEvenAnalysisCubit>()
                        .exportBreakEvenAnalysis(
                          year: data.year,
                          month: data.month,
                          branchId: data.branchId,
                          formatType: 'pdf',
                        );
                  },
                  label: 'PDF',
                  icon: AppSvg(assetName: AppAssets.pdfSvg, width: 23.r),
                  backgroundColor: context.customColor.text2,
                  borderRadius: BorderRadius.circular(12.r),
                  isFlexible: true,
                  padding: EdgeInsets.all(12.r),
                ),
              };
            },
          ),
    );
  }

  Widget _buildRow({
    required BuildContext context,
    required String title,
    required String value,
    String? icon,
    Widget? anotherWidget,
    bool showCurrency = true,
    Color? iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: context.customColor.reversedTextColor,
      ),
      padding: EdgeInsets.all(12.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  AppSvg(
                    assetName: icon,
                    width: 16.r,
                    colorFilter: ColorFilter.mode(
                      iconColor ?? context.customColor.text3,
                      BlendMode.srcIn,
                    ),
                  ),
                  5.horizontalSpace,
                ],
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
          10.horizontalSpace,
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showCurrency) ...[
                  const SaudiRiyalSvgWidget(),
                  3.horizontalSpace,
                ],
                Flexible(
                  child: Text(
                    value,
                    style: AppStyles.s13W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ),
                if (anotherWidget != null) 10.horizontalSpace,
                if (anotherWidget != null) anotherWidget,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
