import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_padding_widget.dart';

class BranchManagerRequestDetailsAppBar extends StatelessWidget {
  final String title;
  final String desc;

  const BranchManagerRequestDetailsAppBar({
    super.key,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 50.r,
      child: Row(
        children: [
          const AppBackButton(),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.s16W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                Text(
                  desc,
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
