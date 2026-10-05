import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/routing/app_route_name.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../data/models/brand_owner_control_panel_model.dart';
import '../cubit/brand_owner_control_panel/brand_owner_control_panel_cubit.dart';
import '../cubit/brand_owner_control_panel/brand_owner_control_panel_state.dart';
import 'brand_owner_asset_overview_screen.dart';

class BrandOwnerFixedAssetsControlPanalScreen extends StatefulWidget {
  const BrandOwnerFixedAssetsControlPanalScreen({super.key});

  @override
  State<BrandOwnerFixedAssetsControlPanalScreen> createState() =>
      _BrandOwnerFixedAssetsControlPanalScreenState();
}

class _BrandOwnerFixedAssetsControlPanalScreenState
    extends State<BrandOwnerFixedAssetsControlPanalScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<BrandOwnerControlPanelCubit>()..load(),
      child: Scaffold(
        backgroundColor: context.customColor.reversedTextColor,
        body: Column(
          children: [
            AppPaddingWidget(
              top: 30.r,
              child: Row(
                children: [
                  const AppBackButton(),
                  10.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Asab Owner Control Panel',
                          style: AppStyles.s16W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        Text(
                          'Nakheel Restaurant Chain',
                          style: AppStyles.s12W400.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  10.horizontalSpace,
                  AppGestureDetectorButton(
                    onTap: () {
                      NavigationService.I.pushNamed(
                        AppRouteName.brandOwnerFixedAssetsRequestsScreen,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.customColor.reversedTextColor,
                        border: Border.all(color: context.customColor.border),
                      ),
                      child: AppSvg(
                        assetName: AppAssets.transactionHistorySvg,
                        width: 20.r,
                        height: 20.r,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<
                BrandOwnerControlPanelCubit,
                BrandOwnerControlPanelState
              >(
                builder: (context, state) => switch (state) {
                  BrandOwnerControlPanelInitial() ||
                  BrandOwnerControlPanelLoading() =>
                    const AppLoadingWidget(),
                  BrandOwnerControlPanelFailure(:final failure) =>
                    AppFailureWidget(
                      failure: failure,
                      onRetry: () =>
                          context
                              .read<BrandOwnerControlPanelCubit>()
                              .load(),
                    ),
                  BrandOwnerControlPanelSuccess(:final data) =>
                    _buildContent(context, data),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, BrandOwnerControlPanelModel data) {
    return Container(
      color: context.customColor.text2,
      padding: EdgeInsets.all(12.r),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContainerCustomTextField(
              padding: EdgeInsets.all(5.r),
              borderColor: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(1000.r),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: context.customColor.reversedTextColor,
                      borderRadius: BorderRadius.circular(1000.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.r,
                      vertical: 6.r,
                    ),
                    child: Row(
                      children: [
                        AppSvg(
                          assetName: AppAssets.branchStoreSvg,
                          width: 20.w,
                          height: 20.h,
                        ),
                        5.horizontalSpace,
                        Text(
                          'All Store Branches',
                          style: AppStyles.s12W400.copyWith(
                            color: context.customColor.text1,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        5.horizontalSpace,
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: context.customColor.text1,
                        ),
                      ],
                    ),
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.customColor.reversedTextColor,
                        borderRadius: BorderRadius.circular(1000.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.r,
                        vertical: 6.r,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              _monthName(2),
                              style: AppStyles.s12W400.copyWith(
                                color: context.customColor.text1,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          5.horizontalSpace,
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: context.customColor.text1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            10.verticalSpace,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildStrategicOverviewCard(context, data),
                  20.horizontalSpace,
                  _buildBranchPerformanceCard(context, data),
                  20.horizontalSpace,
                  _buildExecutiveSummaryCard(context, data),
                ],
              ),
            ),
            10.verticalSpace,
            Text(
              'Quick Links',
              style: AppStyles.s16W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
            10.verticalSpace,
            Container(
              decoration: BoxDecoration(
                color: context.customColor.text3.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.all(8.r),
              child: Row(
                children: [
                  Expanded(
                    child: _buildQuickActionItem(
                      context,
                      'Asset Overview',
                      AppAssets.search,
                      onTap: () {
                        AppBottomSheet.customPageRoute(
                          context,
                          (context) =>
                              const BrandOwnerAssetOverviewScreen(),
                        );
                      },
                    ),
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: _buildQuickActionItem(
                      context,
                      'Modifications',
                      AppAssets.settings,
                      onTap: () {},
                    ),
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: _buildQuickActionItem(
                      context,
                      'Reports',
                      AppAssets.chart,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
            10.verticalSpace,
            _buildBottomExecutiveSummaryCard(context, data),
          ],
        ),
      ),
    );
  }

  Widget _buildStrategicOverviewCard(
    BuildContext context,
    BrandOwnerControlPanelModel data,
  ) {
    final overview = data.strategicOverview;
    return Container(
      width: 300.w,
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(12.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Strategic Overview',
            style: AppStyles.s14W500.copyWith(
              color: context.customColor.text1,
            ),
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildDetailRow(
            context,
            'Total Chain Assets',
            '${overview.totalChainAssets}',
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildDetailRow(
            context,
            'Excellent Status',
            overview.excellentStatus,
            statusColor: AppColors.lightGreen,
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildDetailRow(
            context,
            'Branches',
            '${overview.branchesCount}',
            statusColor: AppColors.lightGreen,
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildDetailRow(
            context,
            'Total Investment',
            overview.totalInvestment,
            showCurrency: true,
            statusColor: AppColors.lightGreen,
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Critical Value Impact',
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        overview.criticalValueImpact,
                        style: AppStyles.s14W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ),
                    10.horizontalSpace,
                    AppSvg(
                      assetName: AppAssets.warning,
                      width: 20.r,
                      height: 20.r,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBranchPerformanceCard(
    BuildContext context,
    BrandOwnerControlPanelModel data,
  ) {
    return Container(
      width: 300.w,
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(12.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Strategic Branch Performance',
            style: AppStyles.s14W500.copyWith(
              color: context.customColor.text1,
            ),
          ),
          10.verticalSpace,
          const CustomDivider(),
          ...data.branchPerformance.items.map((item) => [
            10.verticalSpace,
            _buildDetailRow(
              context,
              '${_branchEmoji(data.branchPerformance.items.indexOf(item))} ${item.name}:',
              '${item.percentage} (${item.status})',
            ),
            10.verticalSpace,
            const CustomDivider(),
          ]).expand((e) => e),
        ],
      ),
    );
  }

  Widget _buildExecutiveSummaryCard(
    BuildContext context,
    BrandOwnerControlPanelModel data,
  ) {
    final summary = data.executiveSummary;
    return Container(
      width: 300.w,
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(12.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Executive Summary',
            style: AppStyles.s14W500.copyWith(
              color: context.customColor.text1,
            ),
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildDetailRow(context, 'Photo Accuracy:', summary.photoAccuracy),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildDetailRow(
            context,
            'Audit Completion:',
            summary.auditCompletion,
          ),
          20.verticalSpace,
          ButtonTextIcon(
            onTap: () {},
            label: 'Detailed Analytics',
            icon: AppSvg(
              assetName: AppAssets.viewReports,
              width: 15.r,
              colorFilter: ColorFilter.mode(
                context.theme.primaryColor,
                BlendMode.srcIn,
              ),
            ),
            textColor: context.theme.primaryColor,
            borderColor: context.theme.primaryColor,
            padding: EdgeInsets.symmetric(vertical: 10.r),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomExecutiveSummaryCard(
    BuildContext context,
    BrandOwnerControlPanelModel data,
  ) {
    final summary = data.executiveSummary;
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(12.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Executive Summary',
            style: AppStyles.s14W500.copyWith(
              color: context.customColor.text1,
            ),
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildDetailRow(context, 'Photo Accuracy:', summary.photoAccuracy),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildDetailRow(
            context,
            'Audit Completion:',
            summary.auditCompletion,
          ),
          20.verticalSpace,
          ButtonTextIcon(
            onTap: () {},
            label: 'Detailed Analytics',
            icon: AppSvg(
              assetName: AppAssets.viewReports,
              width: 15.r,
              colorFilter: ColorFilter.mode(
                context.theme.primaryColor,
                BlendMode.srcIn,
              ),
            ),
            textColor: context.theme.primaryColor,
            borderColor: context.theme.primaryColor,
            padding: EdgeInsets.symmetric(vertical: 10.r),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ],
      ),
    );
  }

  String _branchEmoji(int index) {
    const emojis = ['🥇', '🥈', '🥉', '🔄'];
    return index < emojis.length ? emojis[index] : '🔄';
  }

  Widget _buildQuickActionItem(
    BuildContext context,
    String title,
    String iconPath, {
    required VoidCallback onTap,
  }) {
    return AppGestureDetectorButton(
      onTap: onTap,
      child: Container(
        width: 90.w,
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: context.customColor.reversedTextColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: context.customColor.border),
              ),
              child: AppSvg(
                assetName: iconPath,
                width: 14.r,
                colorFilter: ColorFilter.mode(
                  context.theme.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              title,
              textAlign: TextAlign.center,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.s11W500.copyWith(
                color: context.customColor.text4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    Color? statusColor,
    bool showCurrency = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
          ),
        ),
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showCurrency) ...[
                const SaudiRiyalSvgWidget(),
                4.horizontalSpace,
              ],
              Flexible(
                child: Text(
                  value,
                  style: AppStyles.s14W500.copyWith(
                    color: statusColor ?? context.customColor.text1,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

const _monthNames = [
  '',
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

String _monthName(int month) {
  return _monthNames[month.clamp(1, 12)];
}
