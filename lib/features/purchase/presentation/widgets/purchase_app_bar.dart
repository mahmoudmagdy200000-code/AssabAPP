import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/styles/app_styles.dart';
import '../../../../../../core/widgets/app_back_button.dart';
import '../../../../../../core/widgets/app_padding_widget.dart';

class PurchaseAppBar extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color? iconColor;
  final Color? titleColor;
  final double? paddingTop;
  final double? paddingBottom;

  const PurchaseAppBar({
    super.key,
    required this.title,
    required this.subtitle,
    this.iconColor,
    this.titleColor,
    this.paddingTop,
    this.paddingBottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: paddingTop ?? 30.r,
      bottom: paddingBottom ?? 20.r,
      child: Row(
        children: [
          AppBackButton(isTransparent: true, iconColor: iconColor),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  softWrap: true,
                  style: AppStyles.s20W400.copyWith(
                    color: titleColor ?? context.customColor.reversedTextColor,
                  ),
                ),
                4.verticalSpace,
                Text(
                  subtitle,
                  softWrap: true,
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
