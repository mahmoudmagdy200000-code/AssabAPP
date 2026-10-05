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
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_svg_button.dart';
import '../../../../generated/l10n.dart';
import '../../domain/entities/profit_and_loss_statement_entity.dart';
import '../cubit/export_profit_and_loss_statement_cubit.dart';
import '../cubit/export_profit_and_loss_statement_state.dart';
import '../cubit/profit_and_loss_statement_cubit.dart';
import '../cubit/profit_and_loss_statement_state.dart';
import '../widgets/brand_owner_financial_reporting_exports_buttons.dart';
import '../widgets/profit_and_loss_statement_filter_bottom_sheet.dart';

class _ChartItem {
  final String label;
  final double amount;
  final Color color;

  const _ChartItem({
    required this.label,
    required this.amount,
    required this.color,
  });
}

class BrandOwnerProfitAndLossStatementScreen extends StatefulWidget {
  const BrandOwnerProfitAndLossStatementScreen({super.key});

  @override
  State<BrandOwnerProfitAndLossStatementScreen> createState() =>
      _BrandOwnerProfitAndLossStatementScreenState();
}

class _BrandOwnerProfitAndLossStatementScreenState
    extends State<BrandOwnerProfitAndLossStatementScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfitAndLossStatementCubit>().loadProfitAndLossStatement();
  }

  List<Color> _buildGradient(Color color) {
    return [
      color.withValues(alpha: 0.9),
      color.withValues(alpha: 0.6),
      color.withValues(alpha: 0.3),
      color.withValues(alpha: 0.0),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      ProfitAndLossStatementCubit,
      ProfitAndLossStatementState
    >(
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
                            context.tr.profitLossStatement,
                            style: AppStyles.s15W500.copyWith(
                              color: context.customColor.reversedTextColor,
                            ),
                          ),
                          Text(
                            context.tr.nakheelRestaurantChain,
                            style: AppStyles.s12W400.copyWith(
                              color: context.customColor.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    10.horizontalSpace,
                    BlocBuilder<
                      ProfitAndLossStatementCubit,
                      ProfitAndLossStatementState
                    >(
                      builder: (context, state) {
                        return AppIconButton(
                          icon: Icons.refresh,
                          onPressed: () {
                            if (state is ProfitAndLossStatementLoading) {
                              return;
                            }

                            context
                                .read<ProfitAndLossStatementCubit>()
                                .loadProfitAndLossStatement();
                          },
                          backgroundColor: Colors.transparent,
                          iconColor: context.customColor.reversedTextColor,
                          borderColor: context.customColor.reversedTextColor,
                          borderRadius: 12.r,
                          padding: 10.r,
                          size: 16.r,
                        );
                      },
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
                    ProfitAndLossStatementInitial() => const SizedBox.shrink(),
                    ProfitAndLossStatementLoading() => const AppLoadingWidget(),
                    ProfitAndLossStatementSuccess(:final data) =>
                      _buildContent(
                        context,
                        data,
                        data.year,
                        data.month,
                      ),
                    ProfitAndLossStatementFailure(:final failure) =>
                      AppFailureWidget(
                        failure: failure,
                        onRetry: () => context
                            .read<ProfitAndLossStatementCubit>()
                            .loadProfitAndLossStatement(),
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

  Widget _buildContent(
    BuildContext context,
    ProfitAndLossStatementEntity data,
    int year,
    int month,
  ) {
    final summary = data.summary;
    final chart = data.chart;

    final chartItems = [
      _ChartItem(
        label: S.of(context).totalRevenue,
        amount: chart.turnoverTotal,
        color: AppColors.lightGreen,
      ),
      _ChartItem(
        label: S.of(context).directCostTotal,
        amount: chart.directCostTotal,
        color: AppColors.red,
      ),
      _ChartItem(
        label: S.of(context).grossProfit,
        amount: chart.grossProfit,
        color: AppColors.lightGreen,
      ),
      _ChartItem(
        label: S.of(context).grandTotalCost,
        amount: chart.grandTotalCost,
        color: AppColors.red,
      ),
      _ChartItem(
        label: S.of(context).profitabilityAmount,
        amount: chart.profitabilityAmount,
        color: AppColors.lightGreen,
      ),
      _ChartItem(
        label: S.of(context).gaExpenses,
        amount: chart.gAndAExpenses,
        color: AppColors.red,
      ),
      _ChartItem(
        label: S.of(context).otherIncomeexpenses,
        amount: chart.otherIncomeExpenses,
        color: AppColors.red,
      ),
      _ChartItem(
        label: S.of(context).netProfitLoss,
        amount: chart.netProfitAndLoss,
        color: AppColors.lightGreen,
      ),
    ];

    final monthNames = [
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
    final monthLabel = monthNames[month - 1];

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.displaySettings,
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
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: context.customColor.border),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.r,
                    vertical: 8.r,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
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
                            Flexible(
                              child: Text(
                                '$monthLabel $year',
                                style: AppStyles.s13W400.copyWith(
                                  color: context.customColor.text1,
                                ),
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
                            Flexible(
                              child: Text(
                                data.branchName.isNotEmpty ? data.branchName : '-',
                                style: AppStyles.s13W400.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      10.horizontalSpace,
                      AppSvgButton(
                        assetName: AppAssets.filter,
                        onTap: () {
                          final profitAndLossStatementCubit = context
                              .read<ProfitAndLossStatementCubit>();

                          AppBottomSheet.customPageRoute(
                            context,
                            (context) =>
                                ProfitAndLossStatementFilterBottomSheet(
                                  onApplyFilter:
                                      (
                                        selectedMonth,
                                        selectedYear,
                                        selectedBranch,
                                      ) {
                                        profitAndLossStatementCubit.applyFilter(
                                          year: selectedYear,
                                          month: selectedMonth.value,
                                          branchId: selectedBranch,
                                        );

                                        NavigationService.I.pop();
                                      },
                                  onReset: () {
                                    NavigationService.I.pop();
                                    profitAndLossStatementCubit.applyFilter(
                                      branchId: null,
                                    );
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
                ),
                20.verticalSpace,
                Container(
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
                        style: AppStyles.s16W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                      10.verticalSpace,
                      _buildSummaryRow(
                        context,
                        icon: AppAssets.cash,
                        label: S.of(context).totalRevenue,
                        amount: summary.totalRevenue.toStringAsFixed(0),
                      ),
                      10.verticalSpace,
                      _buildSummaryRow(
                        context,
                        icon: AppAssets.expenseSvg,
                        label: S.of(context).totalExpenses,
                        amount: summary.totalExpenses.toStringAsFixed(0),
                      ),
                      10.verticalSpace,
                      _buildSummaryRow(
                        context,
                        icon: AppAssets.over,
                        label: S.of(context).netProfit,
                        amount: summary.netProfit.toStringAsFixed(0),
                        showPercentage: true,
                        percentage:
                            '${summary.profitMarginPercentage.toStringAsFixed(1)}%',
                        percentageColor: summary.isProfit
                            ? AppColors.lightGreen
                            : AppColors.red,
                      ),
                      10.verticalSpace,
                      _buildSummaryRow(
                        context,
                        icon: AppAssets.chart,
                        label: S.of(context).profitMargin,
                        amount:
                            '${summary.profitMarginPercentage.toStringAsFixed(1)}%',
                        showPercentage: false,
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
                ),
                10.verticalSpace,
                Text(
                  S.of(context).profitLoss,
                  style: AppStyles.s16W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                5.verticalSpace,
                Text(
                  S.of(context).visualizeRevenueExpensesAndNetProfitTrends,
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
                const CustomDivider(),
                10.verticalSpace,
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: chartItems.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final height = _calculateChartHeight(
                        index,
                        chartItems.length,
                      );

                      return _buildChartWidget(
                        context,
                        color: item.color,
                        height: height,
                        title: item.label,
                        amount: item.amount.toStringAsFixed(0),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        20.verticalSpace,
        BlocListener<
          ExportProfitAndLossStatementCubit,
          ExportProfitAndLossStatementState
        >(
          listener: (context, state) {
            if (state is ExportProfitAndLossStatementSuccess) {
              getIt<DownloadService>().downloadFile(
                url: state.fileUrl,
                fileName: state.fileUrl.split('/').last,
              );
            } else if (state is ExportProfitAndLossStatementEmailSuccess) {
              AppSnackBar.showSuccess(
                context,
                'Report sent to email successfully',
              );
            } else if (state is ExportProfitAndLossStatementFailure) {
              AppDialog.showErrorDialog(
                context: context,
                failure: state.failure,
              );
            } else if (state is ExportProfitAndLossStatementEmailFailure) {
              AppDialog.showErrorDialog(
                context: context,
                failure: state.failure,
              );
            }
          },
          child:
              BlocBuilder<
                ExportProfitAndLossStatementCubit,
                ExportProfitAndLossStatementState
              >(
                builder: (context, exportState) {
                  return switch (exportState) {
                    ExportProfitAndLossStatementLoading() ||
                    ExportProfitAndLossStatementEmailLoading() =>
                      const AppLoadingWidget(),
                    _ => _buildExportButtons(context, data),
                  };
                },
              ),
        ),
      ],
    );
  }

  Widget _buildExportButtons(
    BuildContext context,
    ProfitAndLossStatementEntity data,
  ) {
    return BrandOwnerFinancialReportingExportsButtons(
      pdf: () {
        context
            .read<ExportProfitAndLossStatementCubit>()
            .exportProfitAndLossStatement(
              year: data.year,
              month: data.month,
              branchId: data.branchId,
              formatType: 'pdf',
            );
      },
      excel: () {
        context
            .read<ExportProfitAndLossStatementCubit>()
            .exportProfitAndLossStatement(
              year: data.year,
              month: data.month,
              branchId: data.branchId,
              formatType: 'excel',
            );
      },
      email: (email) {
        NavigationService.I.pop();
        context
            .read<ExportProfitAndLossStatementCubit>()
            .exportProfitAndLossStatementByEmail(
              year: data.year,
              month: data.month,
              branchId: data.branchId,
              email: email,
            );
      },
    );
  }

  Widget _buildSummaryRow(
    BuildContext context, {
    required String icon,
    required String label,
    required String amount,
    bool showPercentage = false,
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
                const SaudiRiyalSvgWidget(),
                5.horizontalSpace,
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
                  AppSvg(
                    assetName: AppAssets.redShort,
                    width: 16.r,
                    colorFilter: ColorFilter.mode(
                      percentageColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  5.horizontalSpace,
                  Flexible(
                    child: Text(
                      percentage,
                      style: AppStyles.s13W400.copyWith(color: percentageColor),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _calculateChartHeight(int index, int total) {
    final baseHeights = [400, 400, 350, 300, 250, 200, 150, 100];
    if (index < baseHeights.length) {
      return baseHeights[index].h;
    }
    return (400 - (index * 50)).h;
  }

  Widget _buildChartWidget(
    BuildContext context, {
    required String title,
    required String amount,
    required double height,
    required Color color,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SaudiRiyalSvgWidget(),
              5.horizontalSpace,
              Text(
                amount,
                style: AppStyles.s13W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
            ],
          ),
          8.verticalSpace,
          Container(
            width: 28.w,
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _buildGradient(color),
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
            ),
          ),
        ],
      ),
    );
  }
}
