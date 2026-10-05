import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_padding_widget.dart';

class CustodyAppBar extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Color? titleColor;
  final Color? iconColor;
  final TextStyle? titleStyle;
  final bool isTransparent;

  const CustodyAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.titleColor,
    this.iconColor,
    this.titleStyle,
    this.isTransparent = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 30.r,
      child: Row(
        children: [
          AppBackButton(isTransparent: isTransparent, iconColor: iconColor),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  softWrap: true,
                  style:
                      titleStyle ??
                      AppStyles.s20W400.copyWith(
                        color:
                            titleColor ?? context.customColor.reversedTextColor,
                      ),
                ),
                4.verticalSpace,
                if (subtitle != null)
                  Text(
                    subtitle!,
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
