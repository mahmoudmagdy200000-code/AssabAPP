import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../../core/styles/app_colors.dart';
import '../../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../../core/widgets/app_svg.dart';
import '../../../../../../../../core/widgets/custom_divider.dart';
import '../../cashier_shifts_management_widgets/cashier_info_container_widget.dart';

class ManagerCommentWidget extends StatelessWidget {
  const ManagerCommentWidget({
    super.key,
    required this.cashierName,
    required this.handoverAt,
    required this.subtitle,
    required this.messageContent,
    this.messageTitle,
    this.alignedWithNameAndSubtitle = false,
  });

  final String cashierName;
  final String subtitle;
  final String handoverAt;
  final String? messageTitle;
  final String messageContent;
  final bool alignedWithNameAndSubtitle;

  @override
  Widget build(BuildContext context) {
    return CashierInfoContainerWidget(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSvg(assetName: AppAssets.noProfile, width: 40.w, height: 45.h),

            15.horizontalSpace,

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cashierName, style: AppStyles.s14W500),

                  5.verticalSpace,

                  Text(
                    subtitle,
                    style: AppStyles.s11W400.copyWith(
                      color: context.customColor.text4,
                    ),
                  ),
                  Text(
                    handoverAt,
                    style: AppStyles.s11W400.copyWith(
                      color: context.customColor.text4,
                    ),
                  ),

                  if (alignedWithNameAndSubtitle)
                    Container(
                      margin: EdgeInsetsDirectional.only(top: 15.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightGray,
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      child: Text(messageContent, style: AppStyles.s13W400),
                    ),
                ],
              ),
            ),
          ],
        ),

        const CustomDivider(),

        if (messageTitle != null)
          Text(
            messageTitle!,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text4),
          ),

        if (!alignedWithNameAndSubtitle)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Text(messageContent, style: AppStyles.s13W400),
          ),
      ],
    );
  }
}
