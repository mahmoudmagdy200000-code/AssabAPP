import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../generated/l10n.dart';

abstract class BrandOwnerBreakEvenAnalysisStatusStrategy {
  static BrandOwnerBreakEvenAnalysisStatusStrategy fromString(String status) {
    switch (status) {
      case 'very_safe':
        return BrandOwnerBreakEvenAnalysisVerySafeStatusStrategy();
      case 'safe':
        return BrandOwnerBreakEvenAnalysisSafeStatusStrategy();
      case 'at_break_even':
        return BrandOwnerBreakEvenAnalysisAtBreakEvenStatusStrategy();
      case 'risk':
        return BrandOwnerBreakEvenAnalysisRiskStatusStrategy();
      case 'high_risk':
        return BrandOwnerBreakEvenAnalysisHighRiskStatusStrategy();
      default:
        return BrandOwnerBreakEvenAnalysisVerySafeStatusStrategy();
    }
  }

  Widget buildStatus(BuildContext context);
}

Widget _status({
  required BuildContext context,
  required String statusText,
  required Color statusColor,
  required String assetName,
  required Color iconColor,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15.r),
      color: statusColor,
    ),
    padding: EdgeInsets.all(12.r),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppSvg(
                assetName: assetName,
                width: 16.r,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
              5.horizontalSpace,
              Flexible(
                child: Text(
                  context.tr.status,
                  style: AppStyles.s13W400.copyWith(
                    color: context.customColor.reversedTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        10.horizontalSpace,
        Text(
          statusText,
          style: AppStyles.s13W500.copyWith(
            color: context.customColor.reversedTextColor,
          ),
        ),
      ],
    ),
  );
}

class BrandOwnerBreakEvenAnalysisVerySafeStatusStrategy
    extends BrandOwnerBreakEvenAnalysisStatusStrategy {
  @override
  Widget buildStatus(BuildContext context) {
    return _status(
      context: context,
      statusText: S.of(context).verySafe,
      statusColor: AppColors.darkGreen,
      assetName: AppAssets.securitySettingsSvg,
      iconColor: AppColors.lightGreen,
    );
  }
}

class BrandOwnerBreakEvenAnalysisSafeStatusStrategy
    extends BrandOwnerBreakEvenAnalysisStatusStrategy {
  @override
  Widget buildStatus(BuildContext context) {
    return _status(
      context: context,
      statusText: S.of(context).safe,
      statusColor: AppColors.darkGreen.withValues(alpha: 0.8),
      assetName: AppAssets.securitySettingsSvg,
      iconColor: context.customColor.reversedTextColor.withValues(alpha: 0.6),
    );
  }
}

class BrandOwnerBreakEvenAnalysisAtBreakEvenStatusStrategy
    extends BrandOwnerBreakEvenAnalysisStatusStrategy {
  @override
  Widget buildStatus(BuildContext context) {
    return _status(
      context: context,
      statusText: S.of(context).atBreakEven,
      statusColor: AppColors.yellow,
      assetName: AppAssets.warning,
      iconColor: context.customColor.reversedTextColor.withValues(alpha: 0.6),
    );
  }
}

class BrandOwnerBreakEvenAnalysisRiskStatusStrategy
    extends BrandOwnerBreakEvenAnalysisStatusStrategy {
  @override
  Widget buildStatus(BuildContext context) {
    return _status(
      context: context,
      statusText: S.of(context).risk,
      statusColor: AppColors.darkYellow,
      assetName: AppAssets.warning,
      iconColor: context.customColor.reversedTextColor.withValues(alpha: 0.6),
    );
  }
}

class BrandOwnerBreakEvenAnalysisHighRiskStatusStrategy
    extends BrandOwnerBreakEvenAnalysisStatusStrategy {
  @override
  Widget buildStatus(BuildContext context) {
    return _status(
      context: context,
      statusText: S.of(context).highRisk,
      statusColor: AppColors.red,
      assetName: AppAssets.warning,
      iconColor: context.customColor.reversedTextColor.withValues(alpha: 0.6),
    );
  }
}
