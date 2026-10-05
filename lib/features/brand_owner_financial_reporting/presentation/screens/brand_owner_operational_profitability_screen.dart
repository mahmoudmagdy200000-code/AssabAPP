import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/download_service.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/utils/app_snack_bar.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_icon_button.dart';
import '../../../../generated/l10n.dart';
import '../../domain/entities/brand_owner_operational_profitability_entity.dart';
import '../cubit/export_operational_profitability_cubit.dart';
import '../cubit/export_operational_profitability_state.dart';
import '../cubit/operational_profitability_cubit.dart';
import '../cubit/operational_profitability_state.dart';
import '../widgets/brand_owner_financial_reporting_exports_buttons.dart';

class BrandOwnerOperationalProfitabilityScreen extends StatefulWidget {
  const BrandOwnerOperationalProfitabilityScreen({super.key});

  @override
  State<BrandOwnerOperationalProfitabilityScreen> createState() =>
      _BrandOwnerOperationalProfitabilityScreenState();
}

class _BrandOwnerOperationalProfitabilityScreenState
    extends State<BrandOwnerOperationalProfitabilityScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<OperationalProfitabilityCubit>()
        .loadOperationalProfitability();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      OperationalProfitabilityCubit,
      OperationalProfitabilityState
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
                            S.of(context).operationalProfitability,
                            style: AppStyles.s15W500.copyWith(
                              color: context.customColor.reversedTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    10.horizontalSpace,
                    AppIconButton(
                      icon: Icons.refresh,
                      onPressed: () {
                        if (state is OperationalProfitabilityLoading) return;
                        context
                            .read<OperationalProfitabilityCubit>()
                            .loadOperationalProfitability();
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
                    OperationalProfitabilityInitial() =>
                      const SizedBox.shrink(),
                    OperationalProfitabilityLoading() =>
                      const AppLoadingWidget(),
                    OperationalProfitabilitySuccess(:final data) =>
                      _buildContent(context, data),
                    OperationalProfitabilityFailure(:final failure) =>
                      AppFailureWidget(
                        failure: failure,
                        onRetry: () => context
                            .read<OperationalProfitabilityCubit>()
                            .loadOperationalProfitability(),
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
    OperationalProfitabilityEntity data,
  ) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).keyPerformanceIndicators,
                  style: AppStyles.s16W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                10.verticalSpace,
                _buildKPICards(context, data.metrics),
                15.verticalSpace,
                _buildCoreProfitabilitySection(context, data.coreIndicators),
                15.verticalSpace,
                _buildOperationalEfficiencySection(context, data.efficiency),
                15.verticalSpace,
                _buildBenchmarkSection(context, data.benchmark),
              ],
            ),
          ),
        ),
        20.verticalSpace,
        _buildExportSection(context),
      ],
    );
  }

  Widget _buildKPICards(
    BuildContext context,
    OperationalProfitabilityMetricsEntity metrics,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.text2,
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.all(8.r),
      child: Column(
        children: [
          _buildRow(
            context: context,
            title: S.of(context).overallPerformance,
            value: metrics.overallPerformance,
            showCurrency: false,
            icon: AppAssets.target,
            anotherWidget: Row(
              spacing: 5.r,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(metrics.starsCount, (index) {
                return AppSvg(assetName: AppAssets.star, width: 14.r);
              }),
            ),
          ),
          10.verticalSpace,
          _buildRow(
            context: context,
            title: S.of(context).overallPerformance,
            value: metrics.overallScore,
            showCurrency: false,
            icon: AppAssets.viewReports,
          ),
        ],
      ),
    );
  }

  Widget _buildCoreProfitabilitySection(
    BuildContext context,
    OperationalProfitabilityCoreIndicatorsEntity core,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).coreProfitabilityIndicators,
          style: AppStyles.s16W500.copyWith(color: context.customColor.text1),
        ),
        10.verticalSpace,
        Container(
          decoration: BoxDecoration(
            color: context.customColor.text2,
            borderRadius: BorderRadius.circular(15.r),
          ),
          padding: EdgeInsets.all(8.r),
          child: Column(
            children: [
              _buildRow(
                context: context,
                title: S.of(context).operatingProfit,
                value: NumberFormat('#,###').format(core.operatingProfit),
                icon: AppAssets.target,
                anotherWidget: _buildChangeIndicator(
                  context: context,
                  value: core.operatingProfitChange,
                  isPositive: core.operatingProfitIsPositive,
                ),
              ),
              10.verticalSpace,
              _buildRow(
                context: context,
                title: S.of(context).ebitda,
                value: NumberFormat('#,###').format(core.ebitda),
                icon: AppAssets.viewReports,
                anotherWidget: _buildChangeIndicator(
                  context: context,
                  value: core.ebitdaChange,
                  isPositive: core.ebitdaIsPositive,
                ),
              ),
              10.verticalSpace,
              _buildRow(
                context: context,
                title: S.of(context).grossProfitMargin,
                value: NumberFormat('#,###').format(core.grossProfitMargin),
                icon: AppAssets.chart,
                anotherWidget: _buildChangeIndicator(
                  context: context,
                  value: core.grossProfitMarginChange,
                  isPositive: core.grossProfitMarginIsPositive,
                ),
              ),
              10.verticalSpace,
              _buildRow(
                context: context,
                title: S.of(context).returnOnSales,
                value: '${core.returnOnSales.toStringAsFixed(1)}%',
                showCurrency: false,
                icon: AppAssets.viewReports,
                anotherWidget: Text(
                  '(${core.returnOnSalesLabel}) ',
                  style: AppStyles.s13W500.copyWith(
                    color: AppColors.lightGreen,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOperationalEfficiencySection(
    BuildContext context,
    OperationalProfitabilityEfficiencyEntity efficiency,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).operationalEfficiencyIndicators,
          style: AppStyles.s16W500.copyWith(color: context.customColor.text1),
        ),
        10.verticalSpace,
        Container(
          decoration: BoxDecoration(
            color: context.customColor.text2,
            borderRadius: BorderRadius.circular(15.r),
          ),
          padding: EdgeInsets.all(8.r),
          child: Column(
            children: [
              _buildRow(
                context: context,
                title: S.of(context).productivityPerEmployee,
                value:
                    '${NumberFormat('#,###').format(efficiency.productivityPerEmployee)} /${S.of(context).employee}',
                icon: AppAssets.personSvg,
                anotherWidget: _buildChangeIndicator(
                  context: context,
                  value: efficiency.productivityPerEmployeeChange,
                  isPositive: efficiency.productivityIsPositive,
                ),
              ),
              10.verticalSpace,
              _buildRow(
                context: context,
                title: S.of(context).laborCost,
                value: '${efficiency.laborCost.toStringAsFixed(1)}%',
                showCurrency: false,
                icon: AppAssets.over,
                anotherWidget: Text(
                  '(${efficiency.laborCostLabel}) ',
                  style: AppStyles.s13W500.copyWith(
                    color: AppColors.lightGreen,
                  ),
                ),
              ),
              10.verticalSpace,
              _buildRow(
                context: context,
                title: S.of(context).inventoryTurnover,
                value:
                    '${efficiency.inventoryTurnover.toStringAsFixed(0)} ${efficiency.inventoryTurnoverUnit}',
                showCurrency: false,
                icon: AppAssets.recurringOrders,
              ),
              10.verticalSpace,
              _buildRow(
                context: context,
                title: S.of(context).averageTransactionValue,
                value: efficiency.averageTransactionValue.toStringAsFixed(1),
                icon: AppAssets.wallet,
              ),
              10.verticalSpace,
              _buildRow(
                context: context,
                title: 'Space efficiency',
                value:
                    '${NumberFormat('#,###').format(efficiency.spaceEfficiency)} ${efficiency.spaceEfficiencyUnit}',
                icon: AppAssets.direction,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBenchmarkSection(
    BuildContext context,
    OperationalProfitabilityBenchmarkEntity benchmark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).industryBenchmarkComparison,
          style: AppStyles.s16W500.copyWith(color: context.customColor.text1),
        ),
        10.verticalSpace,
        Container(
          decoration: BoxDecoration(
            color: context.customColor.text2,
            borderRadius: BorderRadius.circular(15.r),
          ),
          padding: EdgeInsets.all(8.r),
          child: Column(
            spacing: 8.h,
            children: [
              _buildBenchmarkCard(
                context: context,
                icon: AppAssets.chart,
                title: S.of(context).profitMargin,
                yourValue:
                    '${benchmark.profitMarginYourRestaurant.toStringAsFixed(1)}%',
                industryValue:
                    '${benchmark.profitMarginIndustry.toStringAsFixed(1)}%',
              ),
              _buildBenchmarkCard(
                context: context,
                icon: AppAssets.power,
                title: S.of(context).laborCost,
                yourValue:
                    '${benchmark.laborCostYourRestaurant.toStringAsFixed(1)}%',
                industryValue:
                    '${benchmark.laborCostIndustry.toStringAsFixed(1)}%',
              ),
              _buildBenchmarkCard(
                context: context,
                icon: AppAssets.box,
                title: S.of(context).inventoryTurnover,
                yourValue: benchmark.inventoryTurnoverYourRestaurant
                    .toStringAsFixed(0),
                industryValue: benchmark.inventoryTurnoverIndustry
                    .toStringAsFixed(0),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBenchmarkCard({
    required BuildContext context,
    required String icon,
    required String title,
    required String yourValue,
    required String industryValue,
  }) {
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
            assetName: icon,
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
                  title,
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
                        title: S.of(context).yourRestaurant,
                        value: yourValue,
                        showCurrency: false,
                      ),
                      _buildRow(
                        context: context,
                        title: S.of(context).industry,
                        value: industryValue,
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

  Widget _buildChangeIndicator({
    required BuildContext context,
    required double value,
    required bool isPositive,
  }) {
    return Row(
      spacing: 5.r,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppSvg(
          assetName: AppAssets.redShort,
          width: 14.r,
          colorFilter: ColorFilter.mode(
            isPositive ? AppColors.lightGreen : AppColors.red,
            BlendMode.srcIn,
          ),
        ),
        Flexible(
          child: Text(
            '${value.toStringAsFixed(1)}%',
            style: AppStyles.s13W500.copyWith(
              color: isPositive ? AppColors.lightGreen : AppColors.red,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExportSection(BuildContext context) {
    return BlocListener<
      ExportOperationalProfitabilityCubit,
      ExportOperationalProfitabilityState
    >(
      listener: (context, state) {
        if (state is ExportOperationalProfitabilitySuccess) {
          getIt<DownloadService>().downloadFile(
            url: state.fileUrl,
            fileName: state.fileUrl.split('/').last,
          );
        } else if (state is ExportOperationalProfitabilityFailure) {
          AppDialog.showErrorDialog(context: context, failure: state.failure);
        } else if (state is ExportOperationalProfitabilityEmailSuccess) {
          AppSnackBar.showSuccess(
            context,
            'Report sent successfully to your email',
          );
        } else if (state is ExportOperationalProfitabilityEmailFailure) {
          AppDialog.showErrorDialog(context: context, failure: state.failure);
        }
      },
      child:
          BlocBuilder<
            ExportOperationalProfitabilityCubit,
            ExportOperationalProfitabilityState
          >(
            builder: (context, state) {
              if (state is ExportOperationalProfitabilityLoading ||
                  state is ExportOperationalProfitabilityEmailLoading) {
                return const AppLoadingWidget();
              }

              return BrandOwnerFinancialReportingExportsButtons(
                pdf: () => context
                    .read<ExportOperationalProfitabilityCubit>()
                    .exportOperationalProfitability(formatType: 'pdf'),
                excel: () => context
                    .read<ExportOperationalProfitabilityCubit>()
                    .exportOperationalProfitability(formatType: 'excel'),
                email: (email) {
                  NavigationService.I.pop();
                  context
                      .read<ExportOperationalProfitabilityCubit>()
                      .exportOperationalProfitabilityByEmail(email: email);
                },
              );
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
            child: Wrap(
              spacing: 10.w,
              runSpacing: 5.h,
              alignment: WrapAlignment.end,
              children: [
                Row(
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
                  ],
                ),
                if (anotherWidget != null) anotherWidget,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
