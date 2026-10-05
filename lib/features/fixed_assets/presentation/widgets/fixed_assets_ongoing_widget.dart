import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/widgets/app_svg.dart';

class FixedAssetsOngoingWidget extends StatelessWidget {
  const FixedAssetsOngoingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.tr.ongoingOperations,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: context.customColor.text1,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          spacing: 8.w,
          children: [
            Expanded(
              child: _buildOperationCard(
                context,
                context.tr.monthlyCount,
                '51%',
              ),
            ),
            Expanded(
              child: _buildOperationCard(
                context,
                context.tr.handoverSession,
                '20%',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOperationCard(
    BuildContext context,
    String title,
    String progressText,
  ) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: context.customColor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: AppStyles.s14W500.copyWith(color: context.customColor.text1),
          ),
          8.verticalSpace,
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999.r),
                  border: Border.all(color: context.customColor.border),
                ),
                child: Text(
                  context.tr.inProgress,
                  style: AppStyles.s10W500.copyWith(
                    color: context.theme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            height: 6.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1000.r),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: double.parse(progressText.replaceAll('%', '')) / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(1000.r),
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            spacing: 8.w,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  context.tr.progress,
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  '($progressText)',
                  style: AppStyles.s12W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ButtonTextIcon(
            onTap: () {},
            label: context.tr.seeDetails,
            icon: AppSvg(
              assetName: AppAssets.arrowRight,
              colorFilter: ColorFilter.mode(
                context.customColor.text1,
                BlendMode.srcIn,
              ),
            ),
            reversed: true,
            spaceBetweenTextAndIcon: 7.w,
            padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 12.r),
            borderRadius: BorderRadius.circular(1000.r),
          ),
        ],
      ),
    );
  }
}
