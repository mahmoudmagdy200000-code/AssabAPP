import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/responsive/app_responsive.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/widgets/app_svg.dart';

class CashierInfoRowWidget extends StatelessWidget {
  final bool isStatus;
  final bool valueHasIcon;
  final String? iconSVGAsset;
  final String title;
  final String? value;
  final Color? svgColor;
  final Color? statusColor;
  final Widget? valueWidget;

  const CashierInfoRowWidget({
    super.key,
    this.isStatus = false,
    this.valueHasIcon = false,
    this.svgColor,
    this.iconSVGAsset,
    this.statusColor,
    this.value,
    this.valueWidget,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppStyles.s12W500.copyWith(color: context.customColor.text3),
        ),

        isStatus
            ? Container(
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: context.customColor.border,
                    width: AppResponsive.screenWidth * 0.001,
                  ),
                ),
                child: Text(
                  value!,
                  style: AppStyles.s12W500.copyWith(color: statusColor),
                ),
              )
            : valueWidget != null
            ? valueWidget!
            : valueHasIcon
            ? Row(
                children: [
                  AppSvg(
                    assetName: iconSVGAsset!,
                    width: 20.w,
                    height: 20.h,
                    colorFilter: svgColor != null
                        ? ColorFilter.mode(svgColor!, BlendMode.srcIn)
                        : null,
                  ),
                  4.horizontalSpace,
                  Text(value!, style: AppStyles.s13W500),
                ],
              )
            : Text(value!, style: AppStyles.s13W500),
      ],
    );
  }
}
