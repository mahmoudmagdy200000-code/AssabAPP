import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/widgets/app_svg.dart';

class ShiftDetailsRowWidget extends StatelessWidget {
  final String title;
  final String? value;
  final String iconSVGAsset;
  final TextAlign? textAlign;
  final Widget? valueWidget;
  const ShiftDetailsRowWidget({
    super.key,
    required this.title,
    required this.iconSVGAsset,
    this.value,
    this.valueWidget,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final Widget effectiveValueWidget = valueWidget ??
        Text(
          value ?? '',
          style: AppStyles.s13W500,
          textAlign: textAlign ?? TextAlign.end,
          softWrap: true,
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 2,
          fit: FlexFit.loose,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppSvg(assetName: iconSVGAsset, width: 20.w, height: 20.h),
              6.horizontalSpace,
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  title,
                  style: AppStyles.s12W500.copyWith(
                    color: context.customColor.text3,
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 3,
          fit: FlexFit.loose,
          child: Padding(
            padding: EdgeInsetsDirectional.only(start: 8.w),
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: effectiveValueWidget,
            ),
          ),
        ),
      ],
    );
  }
}
