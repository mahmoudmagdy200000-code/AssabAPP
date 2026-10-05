import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/download_service.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/utils/app_snack_bar.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_icon_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_svg_button.dart';
import '../../../../generated/l10n.dart';
import '../../domain/entities/smart_comparison_entity.dart';
import '../../domain/enums/brand_owner_smart_compare_type_enum.dart';
import '../cubit/export_smart_comparison_cubit.dart';
import '../cubit/export_smart_comparison_state.dart';
import '../cubit/smart_comparison_cubit.dart';
import '../cubit/smart_comparison_state.dart';
import '../widgets/brand_owner_compare_tow_branches_chart_widget.dart';
import '../widgets/brand_owner_compare_tow_month_chart_widget.dart';
import '../widgets/brand_owner_financial_reporting_exports_buttons.dart';
import '../widgets/smart_comparisons_filter_bottom_sheet.dart';

class BrandOwnerSmartComparisonsScreen extends StatefulWidget {
  const BrandOwnerSmartComparisonsScreen({super.key});

  @override
  State<BrandOwnerSmartComparisonsScreen> createState() =>
      _BrandOwnerSmartComparisonsScreenState();
}

class _BrandOwnerSmartComparisonsScreenState
    extends State<BrandOwnerSmartComparisonsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SmartComparisonCubit>().loadSmartComparison();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SmartComparisonCubit, SmartComparisonState>(
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
                            switch (state) {
                              SmartComparisonSuccess(:final data) =>
                                data.type ==
                                        BrandOwnerSmartCompareTypeEnum.branch
                                    ? S.of(context).smartBranchComparisons
                                    : S.of(context).smartMonthlyComparisons,
                              _ => S.of(context).smartMonthlyComparisons,
                            },
                            style: AppStyles.s15W500.copyWith(
                              color: context.customColor.reversedTextColor,
                            ),
                          ),
                          Text(
                            switch (state) {
                              SmartComparisonSuccess(:final data) =>
                                data.branchName,
                              _ => context.tr.nakheelRestaurantChain,
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
                        if (state is SmartComparisonLoading) return;
                        context
                            .read<SmartComparisonCubit>()
                            .loadSmartComparison();
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
                    SmartComparisonInitial() => const SizedBox.shrink(),
                    SmartComparisonLoading() => const AppLoadingWidget(),
                    SmartComparisonSuccess(:final data) => _buildContent(
                      context,
                      data,
                    ),
                    SmartComparisonFailure(:final failure) => AppFailureWidget(
                      failure: failure,
                      onRetry: () => context
                          .read<SmartComparisonCubit>()
                          .loadSmartComparison(),
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

  Widget _buildContent(BuildContext context, SmartComparisonEntity data) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).comparisonSettings,
                  style: AppStyles.s16W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                5.verticalSpace,
                Text(
                  S.of(context).applyYourPreferredFiltersToShowBetterResults,
                  style: AppStyles.s13W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
                10.verticalSpace,
                switch (data.type) {
                  BrandOwnerSmartCompareTypeEnum.branch =>
                    _buildBranchComparisonBar(context, data),
                  BrandOwnerSmartCompareTypeEnum.month =>
                    _buildMonthComparisonBar(context, data),
                },
                15.verticalSpace,
                switch (data.type) {
                  BrandOwnerSmartCompareTypeEnum.branch => _buildBranchSummary(
                    context,
                    data,
                  ),
                  BrandOwnerSmartCompareTypeEnum.month => _buildMonthSummary(
                    context,
                    data,
                  ),
                },
                15.verticalSpace,
                switch (data.type) {
                  BrandOwnerSmartCompareTypeEnum.branch => _buildBranchChart(
                    context,
                    data,
                  ),
                  BrandOwnerSmartCompareTypeEnum.month => _buildMonthChart(
                    context,
                    data,
                  ),
                },
              ],
            ),
          ),
        ),
        20.verticalSpace,
        _buildExportSection(context, data),
      ],
    );
  }

  Widget _buildMonthComparisonBar(
    BuildContext context,
    SmartComparisonEntity data,
  ) {
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
                Text(
                  S.of(context).comparedWith,
                  style: AppStyles.s13W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
                5.horizontalSpace,
                Text(
                  '${data.comparedMonthName} ${data.comparedYear}',
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
              final smartComparisonCubit = context.read<SmartComparisonCubit>();
              AppBottomSheet.customPageRoute(
                context,
                (context) => SmartComparisonsFilterBottomSheet(
                  onApplyMonthFilter: (month, year, cMonth, cYear, branchId) {
                    NavigationService.I.pop();
                    smartComparisonCubit.applyFilter(
                      year: year,
                      month: month.value,
                      comparedYear: cYear,
                      comparedMonth: cMonth.value,
                      type: BrandOwnerSmartCompareTypeEnum.month,
                      branchId: branchId,
                    );
                  },
                  onApplyBranchFilter:
                      (month, year, branchId, comparedBranchId) {
                        NavigationService.I.pop();
                        smartComparisonCubit.applyFilter(
                          year: year,
                          month: month.value,
                          type: BrandOwnerSmartCompareTypeEnum.branch,
                          branchId: branchId,
                          comparedBranchId: comparedBranchId,
                        );
                      },
                  onReset: () {
                    NavigationService.I.pop();
                    smartComparisonCubit.resetFilter();
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

  Widget _buildBranchComparisonBar(
    BuildContext context,
    SmartComparisonEntity data,
  ) {
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
                15.horizontalSpace,
                Text(
                  S.of(context).comparedWith,
                  style: AppStyles.s13W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
                5.horizontalSpace,
                Text(
                  data.comparedBranchName ?? '-',
                  style: AppStyles.s13W400.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                15.horizontalSpace,
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
              ],
            ),
          ),
          10.horizontalSpace,
          AppSvgButton(
            assetName: AppAssets.filter,
            onTap: () {
              final smartComparisonCubit = context.read<SmartComparisonCubit>();
              AppBottomSheet.customPageRoute(
                context,
                (context) => SmartComparisonsFilterBottomSheet(
                  onApplyMonthFilter: (month, year, cMonth, cYear, branchId) {
                    NavigationService.I.pop();
                    smartComparisonCubit.applyFilter(
                      year: year,
                      month: month.value,
                      comparedYear: cYear,
                      comparedMonth: cMonth.value,
                      type: BrandOwnerSmartCompareTypeEnum.month,
                      branchId: branchId,
                    );
                  },
                  onApplyBranchFilter:
                      (month, year, branchId, comparedBranchId) {
                        NavigationService.I.pop();
                        smartComparisonCubit.applyFilter(
                          year: year,
                          month: month.value,
                          type: BrandOwnerSmartCompareTypeEnum.branch,
                          branchId: branchId,
                          comparedBranchId: comparedBranchId,
                        );
                      },
                  onReset: () {
                    NavigationService.I.pop();
                    smartComparisonCubit.resetFilter();
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

  Widget _buildMonthSummary(BuildContext context, SmartComparisonEntity data) {
    final s = data.summary;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.customColor.text2.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).profitabilitySummary,
            style: AppStyles.s16W500.copyWith(color: context.customColor.text1),
          ),
          10.verticalSpace,
          _buildSummaryRow(
            context,
            icon: AppAssets.cash,
            label: S.of(context).totalSales,
            amount: s.totalSales.toStringAsFixed(0),
          ),
          10.verticalSpace,
          _buildSummaryRow(
            context,
            icon: AppAssets.expenseSvg,
            label: S.of(context).totalProfitability,
            amount: s.totalProfitability.toStringAsFixed(0),
            percentage:
                '(${s.totalProfitabilityPercentage.toStringAsFixed(1)}%)',
            showPercentage: true,
            percentageColor: context.customColor.text3,
          ),
          10.verticalSpace,
          _buildSummaryRow(
            context,
            icon: AppAssets.over,
            label: S.of(context).netProfit,
            amount: context.tr.directSales,
            percentage: '(${s.netProfitPercentage.toStringAsFixed(1)}%)',
            showPercentage: true,
            percentageColor: context.customColor.text3,
            showCurrency: false,
          ),
          10.verticalSpace,
          _buildSummaryRow(
            context,
            icon: AppAssets.chart,
            label: S.of(context).profitMargin,
            amount: context.tr.otherApps,
            percentage: '(${s.profitMarginPercentage.toStringAsFixed(1)}%)',
            showPercentage: true,
            percentageColor: context.customColor.text3,
            showCurrency: false,
          ),
          10.verticalSpace,
          ButtonTextIcon(
            onTap: () {},
            label: S.of(context).forMoreDetailsViewLevel2Report,
            icon: AppSvg(
              assetName: AppAssets.eye,
              colorFilter: ColorFilter.mode(
                context.customColor.reversedTextColor,
                BlendMode.srcIn,
              ),
            ),
            backgroundColor: context.theme.primaryColor,
            textStyle: AppStyles.s14W500.copyWith(
              color: context.customColor.reversedTextColor,
            ),
            borderColor: Colors.transparent,
            padding: EdgeInsets.all(12.r),
            spaceBetweenTextAndIcon: 7,
            borderRadius: BorderRadius.circular(15.r),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchSummary(BuildContext context, SmartComparisonEntity data) {
    final s = data.summary;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.customColor.text2.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppSvg(
                assetName: AppAssets.branchStoreSvg,
                width: 16.r,
                colorFilter: ColorFilter.mode(
                  context.customColor.text3,
                  BlendMode.srcIn,
                ),
              ),
              10.horizontalSpace,
              Flexible(
                child: Text(
                  S.of(context).branchRanking,
                  style: AppStyles.s16W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ),
            ],
          ),
          10.verticalSpace,
          _buildBranchCard(
            context,
            branchName: data.branchName,
            amount: data.chartData.mainValue.toStringAsFixed(0),
            percentage: s.totalProfitabilityPercentage.toStringAsFixed(1),
            label: '${S.of(context).profitability} ${data.monthName}',
          ),
          10.verticalSpace,
          _buildBranchCard(
            context,
            branchName: data.comparedBranchName!,
            amount: data.chartData.comparedValue.toStringAsFixed(0),
            percentage: s.netProfitPercentage.toStringAsFixed(1),
            label: '${S.of(context).profitability} ${data.monthName}',
          ),
          10.verticalSpace,
          ButtonTextIcon(
            onTap: () {},
            label: S.of(context).forMoreDetailsViewLevel2Report,
            icon: AppSvg(
              assetName: AppAssets.eye,
              colorFilter: ColorFilter.mode(
                context.customColor.reversedTextColor,
                BlendMode.srcIn,
              ),
            ),
            backgroundColor: context.theme.primaryColor,
            textStyle: AppStyles.s14W500.copyWith(
              color: context.customColor.reversedTextColor,
            ),
            borderColor: Colors.transparent,
            padding: EdgeInsets.all(12.r),
            spaceBetweenTextAndIcon: 7,
            borderRadius: BorderRadius.circular(15.r),
          ),
        ],
      ),
    );
  }

  Widget _buildExportSection(BuildContext context, SmartComparisonEntity data) {
    return BlocListener<ExportSmartComparisonCubit, ExportSmartComparisonState>(
      listener: (context, state) {
        if (state is ExportSmartComparisonSuccess) {
          getIt<DownloadService>().downloadFile(
            url: state.fileUrl,
            fileName: state.fileUrl.split('/').last,
          );
        } else if (state is ExportSmartComparisonEmailSuccess) {
          AppSnackBar.showSuccess(
            context,
            S.of(context).reportSentToEmailSuccessfully,
          );
        } else if (state is ExportSmartComparisonFailure) {
          AppDialog.showErrorDialog(context: context, failure: state.failure);
        } else if (state is ExportSmartComparisonEmailFailure) {
          AppDialog.showErrorDialog(context: context, failure: state.failure);
        }
      },
      child:
          BlocBuilder<ExportSmartComparisonCubit, ExportSmartComparisonState>(
            builder: (context, exportState) {
              return switch (exportState) {
                ExportSmartComparisonLoading() ||
                ExportSmartComparisonEmailLoading() => const AppLoadingWidget(),
                _ => BrandOwnerFinancialReportingExportsButtons(
                  pdf: () {
                    context
                        .read<ExportSmartComparisonCubit>()
                        .exportSmartComparison(
                          year: data.year,
                          month: data.month,
                          comparedYear: data.comparedYear,
                          comparedMonth: data.comparedMonth,
                          type: data.type,
                          branchId: data.branchId,
                          comparedBranchId: data.comparedBranchId,
                          formatType: 'pdf',
                        );
                  },
                  excel: () {
                    context
                        .read<ExportSmartComparisonCubit>()
                        .exportSmartComparison(
                          year: data.year,
                          month: data.month,
                          comparedYear: data.comparedYear,
                          comparedMonth: data.comparedMonth,
                          type: data.type,
                          branchId: data.branchId,
                          comparedBranchId: data.comparedBranchId,
                          formatType: 'excel',
                        );
                  },
                  email: (email) {
                    NavigationService.I.pop();
                    context
                        .read<ExportSmartComparisonCubit>()
                        .exportSmartComparisonByEmail(
                          year: data.year,
                          month: data.month,
                          comparedYear: data.comparedYear,
                          comparedMonth: data.comparedMonth,
                          type: data.type,
                          branchId: data.branchId,
                          comparedBranchId: data.comparedBranchId,
                          email: email,
                        );
                  },
                ),
              };
            },
          ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context, {
    required String icon,
    required String label,
    required String amount,
    bool showPercentage = false,
    bool showCurrency = true,
    String percentage = '',
    Color percentageColor = AppColors.lightGreen,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(12.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                AppSvg(
                  assetName: icon,
                  width: 16.r,
                  colorFilter: ColorFilter.mode(
                    context.customColor.text3,
                    BlendMode.srcIn,
                  ),
                ),
                10.horizontalSpace,
                Flexible(
                  child: Text(
                    label,
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
                  5.horizontalSpace,
                ],
                Flexible(
                  child: Text(
                    amount,
                    style: AppStyles.s13W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ),
                if (showPercentage) ...[
                  10.horizontalSpace,
                  Text(
                    percentage,
                    style: AppStyles.s13W400.copyWith(color: percentageColor),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchCard(
    BuildContext context, {
    required String branchName,
    required String amount,
    required String percentage,
    required String label,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(12.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            branchName,
            style: AppStyles.s14W500.copyWith(color: context.customColor.text4),
          ),
          8.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SaudiRiyalSvgWidget(),
                  5.horizontalSpace,
                  Text(
                    amount,
                    style: AppStyles.s13W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: context.customColor.border),
                  borderRadius: BorderRadius.circular(1000.r),
                ),
                padding: EdgeInsets.all(4.r),
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
                    5.horizontalSpace,
                    Text(
                      '$percentage%',
                      style: AppStyles.s11W500.copyWith(
                        color: percentage.startsWith('-')
                            ? AppColors.red
                            : AppColors.lightGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          5.verticalSpace,
          Text(
            label.toUpperCase(),
            style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthChart(BuildContext context, SmartComparisonEntity data) {
    final chartData = data.chartData;
    return BrandOwnerCompareTwoMonthsChartWidget(
      currentMonth: DateTime(chartData.mainYear, chartData.mainMonth),
      currentValue: chartData.mainValue,
      comparedMonth: DateTime(chartData.comparedYear, chartData.comparedMonth),
      comparedValue: chartData.comparedValue,
      lineColor: context.theme.primaryColor,
      currentColor: context.theme.primaryColor,
      comparedColor: context.theme.primaryColor,
    );
  }

  Widget _buildBranchChart(BuildContext context, SmartComparisonEntity data) {
    final chartData = data.chartData;
    return BrandOwnerCompareTwoBranchesChartWidget(
      branch1Name: data.branchName,
      branch1Value: chartData.mainValue,
      branch2Name: data.comparedBranchName ?? data.branchName,
      branch2Value: chartData.comparedValue,
      branch1Color: const Color(0xff6B5CE7),
      branch2Color: const Color(0xff00B4A6),
    );
  }
}
