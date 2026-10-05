import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/download_service.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/utils/app_snack_bar.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_icon_button.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/app_svg_button.dart';
import '../../../../generated/l10n.dart';
import '../../domain/entities/brand_owner_menu_engineering_entity.dart';
import '../cubit/export_menu_engineering_cubit.dart';
import '../cubit/export_menu_engineering_state.dart';
import '../cubit/menu_engineering_cubit.dart';
import '../cubit/menu_engineering_state.dart';
import '../widgets/brand_owner_financial_reporting_exports_buttons.dart';
import '../widgets/menu_engineering_filter_bottom_sheet.dart';
import 'brand_owner_menu_engineering_details_screen.dart';

class BrandOwnerMenuEngineeringScreen extends StatefulWidget {
  const BrandOwnerMenuEngineeringScreen({super.key});

  @override
  State<BrandOwnerMenuEngineeringScreen> createState() =>
      _BrandOwnerMenuEngineeringScreenState();
}

class _BrandOwnerMenuEngineeringScreenState
    extends State<BrandOwnerMenuEngineeringScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MenuEngineeringCubit>().loadMenuEngineering();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuEngineeringCubit, MenuEngineeringState>(
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
                            S.of(context).menuEngineering,
                            style: AppStyles.s15W500.copyWith(
                              color: context.customColor.reversedTextColor,
                            ),
                          ),
                          Text(
                            switch (state) {
                              MenuEngineeringSuccess(:final data) =>
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
                        if (state is MenuEngineeringLoading) return;
                        context
                            .read<MenuEngineeringCubit>()
                            .loadMenuEngineering();
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
                    MenuEngineeringInitial() => const SizedBox.shrink(),
                    MenuEngineeringLoading() => const AppLoadingWidget(),
                    MenuEngineeringSuccess(:final data) => _buildContent(
                      context,
                      data,
                    ),
                    MenuEngineeringFailure(:final failure) => AppFailureWidget(
                      failure: failure,
                      onRetry: () => context
                          .read<MenuEngineeringCubit>()
                          .loadMenuEngineering(),
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

  Widget _buildContent(BuildContext context, MenuEngineeringEntity data) {
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
                5.verticalSpace,
                Text(
                  S.of(context).applyYourPreferredFiltersToShowBetterResults,
                  style: AppStyles.s13W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
                10.verticalSpace,
                _buildFilterBar(context, data),
                20.verticalSpace,
                _buildOverviewMatrix(context, data),
                15.verticalSpace,
                _buildCategoryAnalysis(context, data),
              ],
            ),
          ),
        ),
        20.verticalSpace,
        _buildExportSection(context, data),
      ],
    );
  }

  Widget _buildFilterBar(BuildContext context, MenuEngineeringEntity data) {
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
              final cubit = context.read<MenuEngineeringCubit>();
              AppBottomSheet.customPageRoute(
                context,
                (context) => MenuEngineeringFilterBottomSheet(
                  onApplyFilter: (month, year, cMonth, cYear, branchId) {
                    NavigationService.I.pop();
                    cubit.applyFilter(
                      year: year,
                      month: month.value,
                      comparedYear: cYear,
                      comparedMonth: cMonth.value,
                      branchId: branchId,
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

  Widget _buildOverviewMatrix(
    BuildContext context,
    MenuEngineeringEntity data,
  ) {
    final items = [
      _OverviewItem(label: S.of(context).puzzles, item: data.puzzles),
      _OverviewItem(label: S.of(context).stars, item: data.stars),
      _OverviewItem(label: S.of(context).dogs, item: data.dogs),
      _OverviewItem(label: S.of(context).workhorses, item: data.workhorses),
    ];

    final highProfitability = items
        .where((e) => e.item.isHighProfitability)
        .toList();
    final lowProfitability = items
        .where((e) => !e.item.isHighProfitability)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).overviewMatrix,
          style: AppStyles.s16W500.copyWith(color: context.customColor.text1),
        ),
        Row(
          children: [
            AppSvg(
              assetName: AppAssets.chart,
              width: 18.r,
              colorFilter: ColorFilter.mode(
                context.customColor.text3,
                BlendMode.srcIn,
              ),
            ),
            5.horizontalSpace,
            Flexible(
              child: Text(
                S.of(context).itemDistributionByPerformance,
                style: AppStyles.s14W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
            ),
          ],
        ),
        5.verticalSpace,
        Container(
          decoration: BoxDecoration(
            color: const Color(0xffFFF0AB),
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.all(12.r),
          child: Column(
            children: [
              Text(
                S.of(context).highProfitability,
                style: AppStyles.s13W500.copyWith(
                  color: context.customColor.text4,
                ),
              ),
              5.verticalSpace,
              Row(
                spacing: 12.r,
                children: highProfitability
                    .map(
                      (e) => _buildContainerOverview(
                        context: context,
                        label: e.label,
                        item: e.item,
                      ),
                    )
                    .toList(),
              ),
              5.verticalSpace,
              Text(
                S.of(context).lowProfitability,
                style: AppStyles.s13W500.copyWith(
                  color: context.customColor.text4,
                ),
              ),
              5.verticalSpace,
              Row(
                spacing: 12.r,
                children: lowProfitability
                    .map(
                      (e) => _buildContainerOverview(
                        context: context,
                        label: e.label,
                        item: e.item,
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryAnalysis(
    BuildContext context,
    MenuEngineeringEntity data,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).categoryAnalysis,
          style: AppStyles.s16W500.copyWith(color: context.customColor.text1),
        ),
        5.verticalSpace,
        Container(
          decoration: BoxDecoration(
            color: context.customColor.text2,
            borderRadius: BorderRadius.circular(15.r),
          ),
          padding: EdgeInsets.all(10.r),
          child: Column(
            spacing: 10.r,
            children: [
              IntrinsicHeight(
                child: Row(
                  spacing: 10.r,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildContainerCategoryAnalysis(
                      context: context,
                      category: data.puzzlesCategory,
                      title: S.of(context).puzzles,
                      onTap: () => _openDetails(
                        context,
                        S.of(context).puzzles,
                        data.puzzlesCategory,
                      ),
                    ),
                    _buildContainerCategoryAnalysis(
                      context: context,
                      category: data.starsCategory,
                      title: S.of(context).stars,
                      onTap: () => _openDetails(
                        context,
                        S.of(context).stars,
                        data.starsCategory,
                      ),
                    ),
                  ],
                ),
              ),
              IntrinsicHeight(
                child: Row(
                  spacing: 10.r,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildContainerCategoryAnalysis(
                      context: context,
                      category: data.dogsCategory,
                      title: S.of(context).dogs,
                      onTap: () => _openDetails(
                        context,
                        S.of(context).dogs,
                        data.dogsCategory,
                      ),
                    ),
                    _buildContainerCategoryAnalysis(
                      context: context,
                      category: data.workhorsesCategory,
                      title: S.of(context).workhorses,
                      onTap: () => _openDetails(
                        context,
                        S.of(context).workhorses,
                        data.workhorsesCategory,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _openDetails(
    BuildContext context,
    String type,
    MenuEngineeringCategoryEntity category,
  ) {
    AppBottomSheet.showModal(
      context,
      isScrollControlled: true,
      (context) => BrandOwnerMenuEngineeringDetailsScreen(
        type: type,
        itemsCount: category.itemsCount.toString(),
        items: category.items,
      ),
    );
  }

  Widget _buildExportSection(BuildContext context, MenuEngineeringEntity data) {
    return BlocListener<ExportMenuEngineeringCubit, ExportMenuEngineeringState>(
      listener: (context, state) {
        if (state is ExportMenuEngineeringSuccess) {
          getIt<DownloadService>().downloadFile(
            url: state.fileUrl,
            fileName: state.fileUrl.split('/').last,
          );
        } else if (state is ExportMenuEngineeringEmailSuccess) {
          AppSnackBar.showSuccess(context, 'Report sent to email successfully');
        } else if (state is ExportMenuEngineeringFailure) {
          AppDialog.showErrorDialog(context: context, failure: state.failure);
        } else if (state is ExportMenuEngineeringEmailFailure) {
          AppDialog.showErrorDialog(context: context, failure: state.failure);
        }
      },
      child:
          BlocBuilder<ExportMenuEngineeringCubit, ExportMenuEngineeringState>(
            builder: (context, state) {
              if (state is ExportMenuEngineeringLoading ||
                  state is ExportMenuEngineeringEmailLoading) {
                return const AppLoadingWidget();
              }

              return BrandOwnerFinancialReportingExportsButtons(
                showExcel: false,
                pdf: () {
                  context
                      .read<ExportMenuEngineeringCubit>()
                      .exportMenuEngineering(
                        year: data.year,
                        month: data.month,
                        comparedYear: data.comparedYear,
                        comparedMonth: data.comparedMonth,
                        branchId: data.branchId,
                      );
                },
                email: (email) {
                  NavigationService.I.pop();
                  context
                      .read<ExportMenuEngineeringCubit>()
                      .exportMenuEngineeringByEmail(
                        year: data.year,
                        month: data.month,
                        comparedYear: data.comparedYear,
                        comparedMonth: data.comparedMonth,
                        branchId: data.branchId,
                        email: email,
                      );
                },
              );
            },
          ),
    );
  }

  Widget _buildContainerOverview({
    required BuildContext context,
    required String label,
    required MenuEngineeringOverviewItemEntity item,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: context.customColor.reversedTextColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        padding: EdgeInsets.all(12.r),
        child: Column(
          children: [
            Text(
              label,
              style: AppStyles.s14W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
            5.verticalSpace,
            Text(
              '${item.itemsCount} ${S.of(context).items}',
              style: AppStyles.s12W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
            5.verticalSpace,
            Text(
              '📊 ${item.percentage.toStringAsFixed(1)}%',
              style: AppStyles.s12W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContainerCategoryAnalysis({
    required BuildContext context,
    required MenuEngineeringCategoryEntity category,
    required String title,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: context.customColor.reversedTextColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 12.r, left: 12.r, right: 12.r),
              child: Column(
                children: [
                  Text(
                    '$title - ${category.itemsCount} ${S.of(context).items}',
                    style: AppStyles.s14W500.copyWith(
                      color: context.customColor.text1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  5.verticalSpace,
                  const CustomDivider(),
                  5.verticalSpace,
                  Wrap(
                    spacing: 5.r,
                    runSpacing: 5.r,
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SaudiRiyalSvgWidget(size: 14.r),
                          5.horizontalSpace,
                          Flexible(
                            child: Text(
                              category.amount.toStringAsFixed(0),
                              style: AppStyles.s16W500.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '(${category.amountPercentage.toStringAsFixed(0)}%)',
                        style: AppStyles.s12W400.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                    ],
                  ),
                  5.verticalSpace,
                  const CustomDivider(),
                  5.verticalSpace,
                  Wrap(
                    spacing: 5.r,
                    runSpacing: 5.r,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runAlignment: WrapAlignment.center,
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        S.of(context).averageProfitability,
                        style: AppStyles.s12W400.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                      Text(
                        '${category.percentage.toStringAsFixed(1)}%',
                        style: AppStyles.s14W600.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            5.verticalSpace,
            const CustomDivider(),
            const Spacer(),
            AppGestureDetectorButton(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.all(12.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppSvg(
                      assetName: AppAssets.eye,
                      width: 14.r,
                      colorFilter: ColorFilter.mode(
                        context.theme.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    7.horizontalSpace,
                    Flexible(
                      child: Text(
                        context.tr.viewDetails,
                        style: AppStyles.s13W400.copyWith(
                          color: context.theme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewItem {
  final String label;
  final MenuEngineeringOverviewItemEntity item;

  const _OverviewItem({required this.label, required this.item});
}
