import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/widgets/app_svg.dart';

class FixedAssetsUrgentActionsWidget extends StatelessWidget {
  const FixedAssetsUrgentActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      context.tr.receiveAssetsFromFinance,
      context.tr.receiveConveyorFromCentral,
      context.tr.approvedTransferToEast,
      context.tr.approvedDisposal,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            AppSvg(
              assetName: AppAssets.warning,
              width: 20.r,
              height: 20.r,
              colorFilter: ColorFilter.mode(
                context.customColor.error,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              context.tr.urgentActions,
              style: AppStyles.s16W600.copyWith(
                color: context.customColor.text1,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: context.customColor.text2,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: context.customColor.border),
          ),
          child: Column(
            children: actions
                .map((action) => _buildActionItem(context, action))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildActionItem(BuildContext context, String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: context.customColor.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              text,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text1,
              ),
            ),
          ),
          AppSvg(
            assetName: AppAssets.arrowRight,
            width: 15.r,
            colorFilter: ColorFilter.mode(
              context.theme.primaryColor,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}
