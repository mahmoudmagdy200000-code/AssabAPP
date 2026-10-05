import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_icon_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/profile_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../data/models/brand_owner_asset_overview_model.dart';
import '../cubit/brand_owner_asset_overview/brand_owner_asset_overview_cubit.dart';
import '../cubit/brand_owner_asset_overview/brand_owner_asset_overview_state.dart';
import '../cubit/brand_owner_asset_overview_export/brand_owner_asset_overview_export_cubit.dart';
import '../cubit/brand_owner_asset_overview_search/brand_owner_asset_overview_search_cubit.dart';
import '../cubit/brand_owner_asset_overview_search/brand_owner_asset_overview_search_state.dart';
import '../widgets/brand_owner_asset_overview_screen_export_bottom_sheet.dart';
import '../widgets/brand_owner_asset_overview_screen_performance_summary_bottom_sheet.dart';
import '../widgets/brand_owner_asset_overview_screen_view_details_branch_bottom_sheet.dart';

class BrandOwnerAssetOverviewScreen extends StatefulWidget {
  const BrandOwnerAssetOverviewScreen({super.key});

  @override
  State<BrandOwnerAssetOverviewScreen> createState() =>
      _BrandOwnerAssetOverviewScreenState();
}

class _BrandOwnerAssetOverviewScreenState
    extends State<BrandOwnerAssetOverviewScreen> {
  bool _isExpanded = true;

  void _toggleExpanded() {
    setState(() => _isExpanded = !_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<BrandOwnerAssetOverviewCubit>()..load(),
        ),
        BlocProvider(
          create: (context) => getIt<BrandOwnerAssetOverviewSearchCubit>(),
        ),
      ],
      child: Scaffold(
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
                          'Comprehensive Asset Overview',
                          style: AppStyles.s16W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        Text(
                          'Search, Manage and relocate assets',
                          style: AppStyles.s12W400.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  BlocBuilder<
                    BrandOwnerAssetOverviewCubit,
                    BrandOwnerAssetOverviewState
                  >(
                    builder: (context, state) {
                      return switch (state) {
                        BrandOwnerAssetOverviewInitial() ||
                        BrandOwnerAssetOverviewLoading() =>
                          const AppLoadingWidget(),
                        BrandOwnerAssetOverviewFailure(:final failure) =>
                          AppFailureWidget(
                            failure: failure,
                            onRetry: () {
                              context
                                  .read<BrandOwnerAssetOverviewCubit>()
                                  .load();
                            },
                          ),
                        BrandOwnerAssetOverviewSuccess(:final overview) =>
                          _buildContent(context, overview),
                      };
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    BrandOwnerAssetOverviewResponseModel overview,
  ) {
    return ColoredBox(
      color: context.customColor.text2,
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    color: context.customColor.reversedTextColor,
                    padding: EdgeInsets.all(16.r),
                    margin: EdgeInsets.only(top: 12.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Advanced Search + Branch Summary',
                                    style: AppStyles.s16W500.copyWith(
                                      color: context.customColor.text1,
                                    ),
                                  ),
                                  Text(
                                    'Search branches in your store.',
                                    style: AppStyles.s12W400.copyWith(
                                      color: context.customColor.text3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            10.horizontalSpace,
                            AnimatedRotation(
                              turns: _isExpanded ? 0.5 : 0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: AppIconButton(
                                icon: Icons.keyboard_arrow_down_sharp,
                                onPressed: _toggleExpanded,
                                backgroundColor: context.customColor.text2,
                                iconColor: context.customColor.text1,
                              ),
                            ),
                          ],
                        ),
                        AnimatedCrossFade(
                          duration: const Duration(milliseconds: 300),
                          sizeCurve: Curves.easeInOut,
                          firstCurve: Curves.easeInOut,
                          secondCurve: Curves.easeInOut,
                          crossFadeState: _isExpanded
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          firstChild: _buildSearchAndBranchSection(
                            context,
                            overview,
                          ),
                          secondChild: const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    color: context.customColor.reversedTextColor,
                    padding: EdgeInsets.all(16.r),
                    margin: EdgeInsets.only(top: 12.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Network Statistics',
                          style: AppStyles.s16W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        5.verticalSpace,
                        _buildNetworkStatistics(
                          context,
                          overview.networkStatistics
                              as BrandOwnerAssetOverviewNetworkStatisticsModel,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          20.verticalSpace,
          _buildBottomButtons(context, overview),
        ],
      ),
    );
  }

  Widget _buildSearchAndBranchSection(
    BuildContext context,
    BrandOwnerAssetOverviewResponseModel overview,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.verticalSpace,
        Text(
          'Advanced Search:',
          style: AppStyles.s16W500.copyWith(color: context.customColor.text1),
        ),
        5.verticalSpace,
        _buildSearchField(context, overview),
        10.verticalSpace,
        Text(
          'Branch Audit Summary',
          style: AppStyles.s16W500.copyWith(color: context.customColor.text1),
        ),
        5.verticalSpace,
        _buildBranchList(context, overview),
      ],
    );
  }

  Widget _buildSearchField(
    BuildContext context,
    BrandOwnerAssetOverviewResponseModel overview,
  ) {
    return BlocBuilder<
      BrandOwnerAssetOverviewSearchCubit,
      BrandOwnerAssetOverviewSearchState
    >(
      builder: (context, searchState) {
        final searchCubit = context.read<BrandOwnerAssetOverviewSearchCubit>();
        if (searchState is BrandOwnerAssetOverviewSearchInitial) {
          searchCubit.setData(
            branches: overview.branches
                .cast<BrandOwnerAssetOverviewBranchModel>()
                .toList(),
            assets: overview.branches
                .expand((b) => b.assets)
                .cast<BrandOwnerAssetOverviewAssetModel>()
                .toList(),
          );
        }
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: context.customColor.border),
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
          child: Row(
            children: [
              AppSvg(assetName: AppAssets.search, width: 15.r),
              10.horizontalSpace,
              Expanded(
                child: CustomTextField(
                  hintText: 'Search by name',
                  onChanged: (value) {
                    searchCubit.search(value);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBranchList(
    BuildContext context,
    BrandOwnerAssetOverviewResponseModel overview,
  ) {
    return BlocBuilder<
      BrandOwnerAssetOverviewSearchCubit,
      BrandOwnerAssetOverviewSearchState
    >(
      builder: (context, state) {
        final branches = switch (state) {
          BrandOwnerAssetOverviewSearchResult(:final branches) => branches,
          _ =>
            overview.branches
                .cast<BrandOwnerAssetOverviewBranchModel>()
                .toList(),
        };

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: context.customColor.text2,
          ),
          padding: EdgeInsets.only(left: 8.r, right: 8.r, top: 8.r),
          child: ListView.builder(
            itemCount: branches.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final branch = branches[index];
              return _buildBranchCard(context, branch);
            },
          ),
        );
      },
    );
  }

  Widget _buildBranchCard(
    BuildContext context,
    BrandOwnerAssetOverviewBranchModel branch,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(12.r),
      margin: EdgeInsets.only(bottom: 8.r),
      child: Column(
        children: [
          Row(
            children: [
              AppSvg(
                assetName: AppAssets.branchStoreSvg,
                colorFilter: ColorFilter.mode(
                  context.customColor.text1,
                  BlendMode.srcIn,
                ),
                width: 24.r,
              ),
              10.horizontalSpace,
              Expanded(
                child: Text(
                  '${branch.branchName}: ${branch.assetsCount} Assets',
                  style: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ),
            ],
          ),
          10.verticalSpace,
          _buildConditionSummary(context, branch),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Manager',
                  style: AppStyles.s14W400.copyWith(
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
                    ProfileImageWidget(
                      image: branch.managerImageUrl,
                      width: 30.r,
                      height: 30.r,
                    ),
                    10.horizontalSpace,
                    Flexible(
                      child: Text(
                        branch.managerName,
                        style: AppStyles.s14W400.copyWith(
                          color: context.customColor.text1,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          10.verticalSpace,
          Row(
            spacing: 10.w,
            children: [
              Expanded(
                child: ButtonTextIcon(
                  onTap: () {
                    AppBottomSheet.customPageRoute(
                      context,
                      (context) => BlocProvider(
                        create: (context) =>
                            getIt<BrandOwnerAssetOverviewExportCubit>(),
                        child: BrandOwnerAssetOverviewScreenExportBottomSheet(
                          branchId: branch.id,
                          branchName: branch.branchName,
                        ),
                      ),
                    );
                  },
                  label: 'Report',
                  icon: AppSvg(
                    assetName: AppAssets.chart,
                    colorFilter: ColorFilter.mode(
                      context.customColor.text1,
                      BlendMode.srcIn,
                    ),
                    width: 16.r,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.r,
                    vertical: 8.r,
                  ),
                  backgroundColor: context.customColor.text2,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              Expanded(
                child: ButtonTextIcon(
                  onTap: () {
                    AppBottomSheet.customPageRoute(
                      context,
                      (context) =>
                          BrandOwnerAssetOverviewScreenViewDetailsBranchBottomSheet(
                            branchId: branch.id,
                          ),
                    );
                  },
                  label: 'View details',
                  icon: AppSvg(
                    assetName: AppAssets.eye,
                    colorFilter: ColorFilter.mode(
                      context.customColor.reversedTextColor,
                      BlendMode.srcIn,
                    ),
                    width: 16.r,
                  ),
                  textColor: context.customColor.reversedTextColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.r,
                    vertical: 8.r,
                  ),
                  backgroundColor: context.customColor.dark,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConditionSummary(
    BuildContext context,
    BrandOwnerAssetOverviewBranchModel branch,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.customColor.border),
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
      child: Row(
        spacing: 10.w,
        children: [
          Expanded(
            child: Column(
              children: [
                Icon(Icons.circle, color: AppColors.lightGreen, size: 12.r),
                5.verticalSpace,
                Text(
                  '${branch.excellentCount} Excellent',
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Icon(Icons.circle, color: AppColors.orange, size: 12.r),
                5.verticalSpace,
                Text(
                  '${branch.attentionCount} Attention',
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Icon(Icons.circle, color: AppColors.red, size: 12.r),
                5.verticalSpace,
                Text(
                  '${branch.problemCount} Problem',
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkStatistics(
    BuildContext context,
    BrandOwnerAssetOverviewNetworkStatisticsModel stats,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.customColor.border),
      ),
      padding: EdgeInsets.all(12.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10.h,
        children: [
          RichText(
            text: TextSpan(
              text: 'Total Assets: ',
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text3,
              ),
              children: [
                TextSpan(
                  text: ' ${stats.totalAssets}',
                  style: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: 'Excellent Status: ',
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text3,
              ),
              children: [
                TextSpan(
                  text: ' ${stats.excellentStatus}',
                  style: AppStyles.s14W500.copyWith(
                    color: AppColors.lightGreen,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: 'Photo Accuracy: ',
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text3,
              ),
              children: [
                TextSpan(
                  text: stats.photoAccuracy,
                  style: AppStyles.s14W500.copyWith(
                    color: AppColors.lightGreen,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: 'Average Asset Age: ',
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text3,
              ),
              children: [
                TextSpan(
                  text: ' ${stats.averageAssetAge}',
                  style: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(
    BuildContext context,
    BrandOwnerAssetOverviewResponseModel overview,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        spacing: 10.w,
        children: [
          Expanded(
            child: ButtonTextIcon(
              onTap: () {
                AppBottomSheet.showModal(
                  context,
                  (context) =>
                      const BrandOwnerAssetOverviewScreenPerformanceSummaryBottomSheet(),
                );
              },
              label: 'Performance Summary',
              icon: AppSvg(
                assetName: AppAssets.viewReports,
                colorFilter: ColorFilter.mode(
                  context.customColor.text1,
                  BlendMode.srcIn,
                ),
                width: 16.r,
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 14.r),
              borderRadius: BorderRadius.circular(12.r),
              isFlexible: true,
            ),
          ),
          Expanded(
            child: ButtonTextIcon(
              onTap: () {},
              label: 'Send',
              icon: AppSvg(
                assetName: AppAssets.shareSvg,
                colorFilter: ColorFilter.mode(
                  context.customColor.reversedTextColor,
                  BlendMode.srcIn,
                ),
                width: 16.r,
              ),
              textColor: context.customColor.reversedTextColor,
              padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 14.r),
              backgroundColor: context.theme.primaryColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ],
      ),
    );
  }
}
