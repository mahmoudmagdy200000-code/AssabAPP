import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/download_service.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_dialog.dart';
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
import '../../../../core/utils/app_snack_bar.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_svg_button.dart';
import '../../../../generated/l10n.dart';
import '../../domain/entities/sales_channel_analysis_entity.dart';
import '../cubit/export_sales_channel_analysis_cubit.dart';
import '../cubit/export_sales_channel_analysis_state.dart';
import '../cubit/sales_channel_analysis_cubit.dart';
import '../cubit/sales_channel_analysis_state.dart';
import '../widgets/brand_owner_compare_tow_month_chart_widget.dart';
import '../widgets/brand_owner_financial_reporting_exports_buttons.dart';
import '../widgets/sales_channel_analysis_filter_bottom_sheet.dart';

class BrandOwnerSalesChannelAnalysisScreen extends StatefulWidget {
  const BrandOwnerSalesChannelAnalysisScreen({super.key});

  @override
  State<BrandOwnerSalesChannelAnalysisScreen> createState() =>
      _BrandOwnerSalesChannelAnalysisScreenState();
}

class _BrandOwnerSalesChannelAnalysisScreenState
    extends State<BrandOwnerSalesChannelAnalysisScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SalesChannelAnalysisCubit>().loadSalesChannelAnalysis();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesChannelAnalysisCubit, SalesChannelAnalysisState>(
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
                            S.of(context).salesChannelAnalysis,
                            style: AppStyles.s15W500.copyWith(
                              color: context.customColor.reversedTextColor,
                            ),
                          ),
                          Text(
                            switch (state) {
                              SalesChannelAnalysisSuccess(:final data) =>
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
                        if (state is SalesChannelAnalysisLoading) return;
                        context
                            .read<SalesChannelAnalysisCubit>()
                            .loadSalesChannelAnalysis();
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
                    SalesChannelAnalysisInitial() => const SizedBox.shrink(),
                    SalesChannelAnalysisLoading() => const AppLoadingWidget(),
                    SalesChannelAnalysisSuccess(:final data) => _buildContent(
                      context,
                      data,
                    ),
                    SalesChannelAnalysisFailure(:final failure) =>
                      AppFailureWidget(
                        failure: failure,
                        onRetry: () => context
                            .read<SalesChannelAnalysisCubit>()
                            .loadSalesChannelAnalysis(),
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

  Widget _buildContent(BuildContext context, SalesChannelAnalysisEntity data) {
    final chartData = data.chartData;

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
                _buildComparisonBar(context, data),
                20.verticalSpace,
                _buildSummary(context, data),
                10.verticalSpace,
                BrandOwnerCompareTwoMonthsChartWidget(
                  currentMonth: DateTime(
                    chartData.mainYear,
                    chartData.mainMonth,
                  ),
                  currentValue: chartData.mainValue,
                  comparedMonth: DateTime(
                    chartData.comparedYear,
                    chartData.comparedMonth,
                  ),
                  comparedValue: chartData.comparedValue,
                  lineColor: context.theme.primaryColor,
                  currentColor: context.theme.primaryColor,
                  comparedColor: context.theme.primaryColor,
                ),
              ],
            ),
          ),
        ),
        20.verticalSpace,
        _buildExportSection(context, data),
      ],
    );
  }

  Widget _buildComparisonBar(
    BuildContext context,
    SalesChannelAnalysisEntity data,
  ) {
    final currentLabel = '${data.monthName} ${data.year}';
    final comparedLabel =
        '${_monthName(data.comparedMonth)} ${data.comparedYear}';
    final branchName = data.branchName;

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
                  currentLabel,
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
                  comparedLabel,
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
                  branchName,
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
              final salesChannelAnalysisCubit = context
                  .read<SalesChannelAnalysisCubit>();
              AppBottomSheet.customPageRoute(
                context,
                (context) => SalesChannelAnalysisFilterBottomSheet(
                  onApplyFilter: (month, year, cMonth, cYear, branchId) {
                    NavigationService.I.pop();
                    salesChannelAnalysisCubit.applyFilter(
                      year: year,
                      month: month.value,
                      comparedYear: cYear,
                      comparedMonth: cMonth.value,
                      branchId: branchId,
                    );
                  },
                  onReset: () {
                    NavigationService.I.pop();
                    salesChannelAnalysisCubit.resetFilter();
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

  Widget _buildSummary(BuildContext context, SalesChannelAnalysisEntity data) {
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
            S.of(context).overallPerformance,
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
            onTap: () {
              NavigationService.I.pushNamed(
                AppRouteName.brandOwnerSalesChannelLevel2Screen,
              );
            },
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

  Widget _buildExportSection(
    BuildContext context,
    SalesChannelAnalysisEntity data,
  ) {
    return BlocListener<
      ExportSalesChannelAnalysisCubit,
      ExportSalesChannelAnalysisState
    >(
      listener: (context, state) {
        if (state is ExportSalesChannelAnalysisSuccess) {
          getIt<DownloadService>().downloadFile(
            url: state.fileUrl,
            fileName: state.fileUrl.split('/').last,
          );
        } else if (state is ExportSalesChannelAnalysisFailure) {
          AppDialog.showErrorDialog(context: context, failure: state.failure);
        } else if (state is ExportSalesChannelAnalysisEmailSuccess) {
          AppSnackBar.showSuccess(context, 'Report sent to email successfully');
        } else if (state is ExportSalesChannelAnalysisEmailFailure) {
          AppDialog.showErrorDialog(context: context, failure: state.failure);
        }
      },
      child:
          BlocBuilder<
            ExportSalesChannelAnalysisCubit,
            ExportSalesChannelAnalysisState
          >(
            builder: (context, exportState) {
              return switch (exportState) {
                ExportSalesChannelAnalysisLoading() => const AppLoadingWidget(),
                ExportSalesChannelAnalysisEmailLoading() =>
                  const AppLoadingWidget(),
                _ => BrandOwnerFinancialReportingExportsButtons(
                  pdf: () {
                    context
                        .read<ExportSalesChannelAnalysisCubit>()
                        .exportSalesChannelAnalysis(
                          year: data.year,
                          month: data.month,
                          comparedYear: data.comparedYear,
                          comparedMonth: data.comparedMonth,
                          branchId: data.branchId,
                          formatType: 'pdf',
                        );
                  },
                  excel: () {
                    context
                        .read<ExportSalesChannelAnalysisCubit>()
                        .exportSalesChannelAnalysis(
                          year: data.year,
                          month: data.month,
                          comparedYear: data.comparedYear,
                          comparedMonth: data.comparedMonth,
                          branchId: data.branchId,
                          formatType: 'excel',
                        );
                  },
                  email: (email) {
                    NavigationService.I.pop();
                    context
                        .read<ExportSalesChannelAnalysisCubit>()
                        .exportSalesChannelAnalysisByEmail(
                          year: data.year,
                          month: data.month,
                          comparedYear: data.comparedYear,
                          comparedMonth: data.comparedMonth,
                          branchId: data.branchId,
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

  String _monthName(int month) {
    const names = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return names[month - 1];
  }
}
