import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/app_svg.dart';

class RecurringOrdersEmptyWidget extends StatelessWidget {
  final String icon;
  final String text;
  final Widget? customWidgetAfterText;

  const RecurringOrdersEmptyWidget({
    super.key,
    required this.icon,
    required this.text,
    this.customWidgetAfterText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.customColor.text2,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.all(8.r),
      child: Container(
        decoration: BoxDecoration(
          color: context.customColor.reversedTextColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        padding: EdgeInsets.all(40.r),
        child: Column(
          spacing: 16.h,
          children: [
            AppSvg(
              assetName: icon,
              width: 40.r,
              height: 40.r,
              colorFilter: ColorFilter.mode(
                context.customColor.text3,
                BlendMode.srcIn,
              ),
            ),
            Text(
              text,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text3,
              ),
              textAlign: TextAlign.center,
            ),
            ?customWidgetAfterText,
          ],
        ),
      ),
    );
  }
}
