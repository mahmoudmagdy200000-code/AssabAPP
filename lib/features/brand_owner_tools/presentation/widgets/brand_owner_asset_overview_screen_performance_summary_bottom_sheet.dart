import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/brand_owner_asset_overview_performance_summary/brand_owner_asset_overview_performance_summary_cubit.dart';
import '../cubit/brand_owner_asset_overview_performance_summary/brand_owner_asset_overview_performance_summary_state.dart';

class BrandOwnerAssetOverviewScreenPerformanceSummaryBottomSheet
    extends StatelessWidget {
  const BrandOwnerAssetOverviewScreenPerformanceSummaryBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<BrandOwnerAssetOverviewPerformanceSummaryCubit>()..load(),
      child: Scaffold(
        body: AppPaddingWidget(
          top: 0,
          child:
              BlocBuilder<
                BrandOwnerAssetOverviewPerformanceSummaryCubit,
                BrandOwnerAssetOverviewPerformanceSummaryState
              >(
                builder: (context, state) {
                  return switch (state) {
                    BrandOwnerAssetOverviewPerformanceSummaryInitial() ||
                    BrandOwnerAssetOverviewPerformanceSummaryLoading() =>
                      const AppLoadingWidget(),
                    BrandOwnerAssetOverviewPerformanceSummaryFailure(
                      :final failure,
                    ) =>
                      AppFailureWidget(
                        failure: failure,
                        onRetry: () {
                          context
                              .read<
                                BrandOwnerAssetOverviewPerformanceSummaryCubit
                              >()
                              .load();
                        },
                      ),
                    BrandOwnerAssetOverviewPerformanceSummarySuccess(
                      :final summary,
                    ) =>
                      _buildContent(context, summary),
                  };
                },
              ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, dynamic summary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSvg(
          assetName: AppAssets.viewReports,
          width: 24.r,
          colorFilter: ColorFilter.mode(
            context.theme.primaryColor,
            BlendMode.srcIn,
          ),
        ),
        10.verticalSpace,
        Text(
          'Performance Summary',
          style: AppStyles.s16W500.copyWith(color: context.customColor.text1),
        ),
        5.verticalSpace,
        Text(
          'Snapshot of your asset handling, audit score, and overall compliance.',
          style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
        ),
        10.verticalSpace,
        Container(
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
                  text: 'assets in Excellent condition ',
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text3,
                  ),
                  children: [
                    TextSpan(
                      text: '${summary.assetsInExcellentCondition} ',
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    TextSpan(
                      text: '(${summary.excellentPercent})',
                      style: AppStyles.s14W500.copyWith(
                        color: AppColors.lightGreen,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: ' photo compliance ',
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text3,
                  ),
                  children: [
                    TextSpan(
                      text: '${summary.photoCompliance}',
                      style: AppStyles.s14W500.copyWith(
                        color: AppColors.lightGreen,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Average resolution time for discrepancies ',
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text3,
                  ),
                  children: [
                    TextSpan(
                      text: '${summary.averageResolutionTime}',
                      style: AppStyles.s14W500.copyWith(
                        color: AppColors.lightGreen,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Last audit score ',
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text3,
                  ),
                  children: [
                    TextSpan(
                      text: '${summary.lastAuditScore} ',
                      style: AppStyles.s14W500.copyWith(
                        color: AppColors.lightGreen,
                      ),
                    ),
                    TextSpan(
                      text: 'out of 100',
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Missed deadlines or failed handovers ',
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text3,
                  ),
                  children: [
                    TextSpan(
                      text: '21',
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text1,
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
}
