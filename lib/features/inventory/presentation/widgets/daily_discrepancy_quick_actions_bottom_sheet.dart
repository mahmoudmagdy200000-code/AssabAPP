import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';

import 'daily_discrepancy_quick_actions_justifications_bottom_sheet.dart';

class DailyDiscrepancyQuickActionsBottomSheet extends StatelessWidget {
  const DailyDiscrepancyQuickActionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr.quickActions,
            style: AppStyles.s20W600.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          8.verticalSpace,
          // Description
          Text(
            context.tr.howWouldYouLikeToRespondToTheDiscrepancyOfFreshMilkNadec,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),
          14.verticalSpace,
          // Actions
          _buildActionItem(
            context,
            context.tr.editPurchases,
            AppAssets.package,
            () {
              // Handle edit purchases
            },
          ),
          12.verticalSpace,
          _buildActionItem(
            context,
            context.tr.recordWasteDamage,
            AppAssets.waste,
            () {
              // Handle record waste
            },
          ),
          12.verticalSpace,
          _buildActionItem(
            context,
            context.tr.addJustification,
            AppAssets.edit,
            () {
              AppBottomSheet.show(
                context,
                (context) =>
                    const DailyDiscrepancyQuickActionsJustificationsBottomSheet(),
              );
            },
          ),
          12.verticalSpace,
          Text(
            context.tr.mainAction,
            style: AppStyles.s14W600.copyWith(color: context.customColor.text4),
          ),
          10.verticalSpace,
          CustomTextButton(
            onTap: () {
              Navigator.of(context).pop();
            },
            text: context.tr.approveWithoutChange,
            backgroundColor: context.theme.primaryColor,
            textColor: context.customColor.reversedTextColor,
            padding: EdgeInsets.symmetric(vertical: 16.r),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context,
    String label,
    String iconAsset,
    VoidCallback onTap,
  ) {
    return AppGestureDetectorButton(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: context.customColor.reversedTextColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: context.customColor.border),
        ),
        child: Row(
          children: [
            AppSvg(
              assetName: iconAsset,
              width: 16.r,
              height: 16.r,
              colorFilter: ColorFilter.mode(
                context.theme.primaryColor,
                BlendMode.srcIn,
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: Text(
                label,
                style: AppStyles.s14W500.copyWith(
                  color: context.customColor.text4,
                ),
              ),
            ),
            AppSvg(
              assetName: AppAssets.arrowRight,
              width: 10.r,
              height: 10.r,
              colorFilter: ColorFilter.mode(
                context.customColor.text1,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
