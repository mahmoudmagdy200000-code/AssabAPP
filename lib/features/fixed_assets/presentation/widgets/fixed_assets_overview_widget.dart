import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:flutter/material.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../data/models/fixed_assets_overview_response.dart';

class FixedAssetsOverviewWidget extends StatelessWidget {
  final FixedAssetsOverviewResponse overview;

  const FixedAssetsOverviewWidget({super.key, required this.overview});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.tr.assetsOverview,
          style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: context.customColor.reversedTextColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: context.customColor.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                context,
                overview.totalAssets.toString(),
                context.tr.total,
                context.theme.primaryColor,
              ),
              Container(
                width: 1.w,
                height: 40.h,
                color: context.customColor.text2,
              ),
              _buildStatItem(
                context,
                overview.totalAssetsExcellent.toString(),
                context.tr.excellent,
                AppColors.lightGreen,
              ),
              Container(
                width: 1.w,
                height: 40.h,
                color: context.customColor.text2,
              ),
              _buildStatItem(
                context,
                overview.totalAssetsMaintenance.toString(),
                context.tr.maintenance,
                AppColors.orange,
              ),
              Container(
                width: 1.w,
                height: 40.h,
                color: context.customColor.text2,
              ),
              _buildStatItem(
                context,
                overview.totalAssetsProblem.toString(),
                context.tr.problem,
                context.customColor.error,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String count,
    String label,
    Color dotColor,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.r,
          height: 8.r,
          decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
        ),
        SizedBox(height: 4.h),
        Text(
          count,
          style: AppStyles.s14W500.copyWith(color: context.customColor.text1),
        ),
        Text(
          label,
          style: AppStyles.s12W500.copyWith(color: context.customColor.text4),
        ),
      ],
    );
  }
}
