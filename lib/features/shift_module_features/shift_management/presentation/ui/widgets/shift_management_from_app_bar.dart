import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/styles/app_styles.dart';
import '../../../../../../core/widgets/app_back_button.dart';
import '../../../../../../core/widgets/app_padding_widget.dart';

class ShiftManagementFromAppBar extends StatelessWidget {
  final String text;

  const ShiftManagementFromAppBar({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 30.r,
      child: Row(
        children: [
          const AppBackButton(isTransparent: true),
          12.horizontalSpace,
          Expanded(
            child: Text(
              text,
              softWrap: true,
              style: AppStyles.s20W400.copyWith(
                color: context.customColor.reversedTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
