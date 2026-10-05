import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/selection_circule.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_styles.dart';
import '../enums/fixed_assets_condition_enum.dart';

abstract class FixedAssetsConditionStrategy {
  static FixedAssetsConditionStrategy fromCondition(String condition) {
    if (condition == FixedAssetsConditionEnum.excellent.value) {
      return ExcellentConditionStrategy();
    } else if (condition == FixedAssetsConditionEnum.needAttention.value) {
      return NeedAttentionConditionStrategy();
    } else if (condition == FixedAssetsConditionEnum.problem.value) {
      return ProblemConditionStrategy();
    } else {
      return ExcellentConditionStrategy();
    }
  }

  FixedAssetsConditionEnum get condition;

  Widget buildConditionWidget(BuildContext context);

  Widget buildRecipientInspectionWidget(
    BuildContext context, {
    required bool isSelected,
    VoidCallback? onTap,
  });
}

class ExcellentConditionStrategy extends FixedAssetsConditionStrategy {
  @override
  FixedAssetsConditionEnum get condition => FixedAssetsConditionEnum.excellent;

  @override
  Widget buildConditionWidget(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.circle, size: 15.r, color: AppColors.lightGreen),
        5.horizontalSpace,
        Text(
          context.tr.excellentCondition,
          style: AppStyles.s12W400.copyWith(color: context.customColor.text4),
        ),
      ],
    );
  }

  @override
  Widget buildRecipientInspectionWidget(
    BuildContext context, {
    required bool isSelected,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: context.customColor.border),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppSvg(
              assetName: AppAssets.check,
              colorFilter: ColorFilter.mode(
                AppColors.lightGreen,
                BlendMode.srcIn,
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fully Agree',
                    style: AppStyles.s14W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  Text(
                    'Asset is accepted as-is, no issues.',
                    style: AppStyles.s12W400.copyWith(
                      color: context.customColor.text4,
                    ),
                  ),
                ],
              ),
            ),
            10.horizontalSpace,
            SelectionCircule(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

class NeedAttentionConditionStrategy extends FixedAssetsConditionStrategy {
  @override
  FixedAssetsConditionEnum get condition =>
      FixedAssetsConditionEnum.needAttention;

  @override
  Widget buildConditionWidget(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.circle, size: 10.r, color: AppColors.orange),
        5.horizontalSpace,
        Text(
          context.tr.needsAttention,
          style: AppStyles.s12W400.copyWith(color: context.customColor.text4),
        ),
      ],
    );
  }

  @override
  Widget buildRecipientInspectionWidget(
    BuildContext context, {
    required bool isSelected,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: context.customColor.border),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppSvg(
              assetName: AppAssets.warning,
              colorFilter: ColorFilter.mode(AppColors.orange, BlendMode.srcIn),
            ),
            10.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Minor Notes',
                    style: AppStyles.s14W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  Text(
                    'Asset is accepted but has minor notes.',
                    style: AppStyles.s12W400.copyWith(
                      color: context.customColor.text4,
                    ),
                  ),
                ],
              ),
            ),
            10.horizontalSpace,
            SelectionCircule(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

class ProblemConditionStrategy extends FixedAssetsConditionStrategy {
  @override
  FixedAssetsConditionEnum get condition => FixedAssetsConditionEnum.problem;

  @override
  Widget buildConditionWidget(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.circle, size: 10.r, color: AppColors.red),
        5.horizontalSpace,
        Text(
          context.tr.problem,
          style: AppStyles.s12W400.copyWith(color: context.customColor.text4),
        ),
      ],
    );
  }

  @override
  Widget buildRecipientInspectionWidget(
    BuildContext context, {
    required bool isSelected,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: context.customColor.border),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppSvg(
              assetName: AppAssets.broken,
              colorFilter: ColorFilter.mode(AppColors.red, BlendMode.srcIn),
            ),
            10.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Major Issue',
                    style: AppStyles.s14W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  Text(
                    'Asset has significant issues requiring review.',
                    style: AppStyles.s12W400.copyWith(
                      color: context.customColor.text4,
                    ),
                  ),
                ],
              ),
            ),
            10.horizontalSpace,
            SelectionCircule(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}
