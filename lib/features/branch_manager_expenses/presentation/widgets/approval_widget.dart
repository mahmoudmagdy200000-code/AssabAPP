import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';

class ApprovalWidget extends StatelessWidget {
  final String name;
  final String? position;
  final String status;
  final Color? statusColor;

  const ApprovalWidget({
    super.key,
    required this.name,
    this.position,
    required this.status,
    this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        children: [
          AppSvg(assetName: AppAssets.noProfile, width: 43.w),
          12.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppStyles.s14W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),
              if (position != null) ...[
                4.verticalSpace,
                Text(
                  position ?? '-',
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ],
              4.verticalSpace,
              Text(
                status,
                style: AppStyles.s10W400.copyWith(color: statusColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
