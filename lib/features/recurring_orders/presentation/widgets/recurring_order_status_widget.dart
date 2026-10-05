import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_asset_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../branch_manager_requests/presentation/widgets/branch_requests_status_widget.dart';

class RecurringOrderStatusWidget extends StatelessWidget {
  final String status;
  final Color statusColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? backgroundColorStatus;
  final String title;
  final String description;
  final String? image;
  final double? imageSize;

  const RecurringOrderStatusWidget({
    super.key,
    required this.status,
    required this.statusColor,
    this.borderColor,
    this.backgroundColor,
    this.backgroundColorStatus,
    required this.title,
    required this.description,
    this.image,
    this.imageSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: borderColor ?? context.customColor.border),
        color: backgroundColor,
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        spacing: 12.h,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppStyles.s16W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ),
              10.horizontalSpace,
              BranchRequestsStatusWidget(
                status: status,
                textColor: statusColor,
                borderColor: borderColor ?? context.customColor.border,
                backgroundColor: backgroundColorStatus,
              ),
            ],
          ),
          if (image != null)
            AppAssetImage(
              image: image ?? '',
              width: imageSize ?? 80.r,
              height: imageSize ?? 80.r,
            ),
          Text(
            description,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),
        ],
      ),
    );
  }
}
