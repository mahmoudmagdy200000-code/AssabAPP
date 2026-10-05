import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/widgets/app_asset_image.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_network_image.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/button_text_icon.dart';
import '../../data/models/brand_owner_asset_overview_model.dart';
import '../cubit/brand_owner_asset_overview_branch_details/brand_owner_asset_overview_branch_details_cubit.dart';
import '../cubit/brand_owner_asset_overview_branch_details/brand_owner_asset_overview_branch_details_state.dart';
import '../cubit/brand_owner_asset_overview_search/brand_owner_asset_overview_search_cubit.dart';
import '../cubit/brand_owner_asset_overview_search/brand_owner_asset_overview_search_state.dart';

class BrandOwnerAssetOverviewScreenViewDetailsBranchBottomSheet
    extends StatelessWidget {
  final String branchId;

  const BrandOwnerAssetOverviewScreenViewDetailsBranchBottomSheet({
    super.key,
    required this.branchId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<BrandOwnerAssetOverviewBranchDetailsCubit>()
                ..load(branchId: branchId),
        ),
        BlocProvider(
          create: (context) => getIt<BrandOwnerAssetOverviewSearchCubit>(),
        ),
      ],
      child: Scaffold(
        body: AppPaddingWidget(
          top: 30.r,
          child:
              BlocBuilder<
                BrandOwnerAssetOverviewBranchDetailsCubit,
                BrandOwnerAssetOverviewBranchDetailsState
              >(
                builder: (context, state) {
                  return switch (state) {
                    BrandOwnerAssetOverviewBranchDetailsInitial() ||
                    BrandOwnerAssetOverviewBranchDetailsLoading() =>
                      const AppLoadingWidget(),
                    BrandOwnerAssetOverviewBranchDetailsFailure(
                      :final failure,
                    ) =>
                      AppFailureWidget(
                        failure: failure,
                        onRetry: () {
                          context
                              .read<BrandOwnerAssetOverviewBranchDetailsCubit>()
                              .load(branchId: branchId);
                        },
                      ),
                    BrandOwnerAssetOverviewBranchDetailsSuccess(
                      :final branch,
                    ) =>
                      _buildContent(context, branch),
                  };
                },
              ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    BrandOwnerAssetOverviewBranchModel branch,
  ) {
    context.read<BrandOwnerAssetOverviewSearchCubit>().setData(
      branches: [branch],
      assets: branch.assets.cast<BrandOwnerAssetOverviewAssetModel>().toList(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppAssetImage(
              image: AppAssets.darkLogo,
              borderRadius: BorderRadius.zero,
              width: 60.r,
            ),
            ButtonTextIcon(
              onTap: () => NavigationService.I.pop(),
              label: 'Close',
              icon: Icon(Icons.close, color: context.customColor.text4),
              textColor: context.customColor.text4,
              padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
              backgroundColor: context.customColor.text2,
              borderRadius: BorderRadius.circular(1000.r),
            ),
          ],
        ),
        10.verticalSpace,
        Text(
          branch.branchName,
          style: AppStyles.s16W500.copyWith(color: context.customColor.text1),
        ),
        5.verticalSpace,
        Text(
          '${branch.assetsCount} Asset\'s are linked to this branch',
          style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
        ),
        10.verticalSpace,
        const CustomDivider(),
        10.verticalSpace,
        _buildConditionSummary(context, branch),
        10.verticalSpace,
        Text(
          'Advanced Search:',
          style: AppStyles.s16W500.copyWith(color: context.customColor.text3),
        ),
        5.verticalSpace,
        _buildSearchField(context, branch),
        10.verticalSpace,
        Expanded(child: _buildAssetsList(context, branch)),
      ],
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

  Widget _buildSearchField(
    BuildContext context,
    BrandOwnerAssetOverviewBranchModel branch,
  ) {
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
                context.read<BrandOwnerAssetOverviewSearchCubit>().search(
                  value,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetsList(
    BuildContext context,
    BrandOwnerAssetOverviewBranchModel branch,
  ) {
    return BlocBuilder<
      BrandOwnerAssetOverviewSearchCubit,
      BrandOwnerAssetOverviewSearchState
    >(
      builder: (context, state) {
        final assets = switch (state) {
          BrandOwnerAssetOverviewSearchResult(:final assets) => assets,
          _ => branch.assets,
        };

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: assets.length,
          itemBuilder: (context, index) {
            final asset = assets[index] as BrandOwnerAssetOverviewAssetModel;
            return _buildAssetCard(context, asset);
          },
        );
      },
    );
  }

  Widget _buildAssetCard(
    BuildContext context,
    BrandOwnerAssetOverviewAssetModel asset,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.customColor.border),
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(12.r),
      margin: EdgeInsets.only(bottom: 10.r),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AppNetworkImage(
                  image: asset.imageUrl,
                  borderRadius: BorderRadius.circular(12.r),
                  height: 100.h,
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      asset.name,
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    5.verticalSpace,
                    Text(
                      asset.code,
                      style: AppStyles.s12W400.copyWith(
                        color: context.customColor.text3,
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
          _buildRow(context, 'Zone', asset.zoneName),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildRow(
            context,
            'In custody',
            '${asset.custodianName} (${asset.custodyDuration})',
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildRow(context, 'Last Audit:', asset.lastAuditDate),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildRow(context, 'Photo', asset.photoDate),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildRow(context, 'Transfers', '${asset.transfersCount}'),
          15.verticalSpace,
          ButtonTextIcon(
            onTap: () {},
            label: 'View Full History',
            reversed: true,
            spaceBetweenTextAndIcon: 7,
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: context.customColor.reversedTextColor,
              size: 16.r,
            ),
            textColor: context.customColor.reversedTextColor,
            padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
            backgroundColor: context.customColor.dark,
            borderRadius: BorderRadius.circular(8.r),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: AppStyles.s14W500.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
