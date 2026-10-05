import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:flutter/material.dart';

class FixedAssetsModificationDetailsHeaderWidget extends StatelessWidget {
  const FixedAssetsModificationDetailsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 30.r,
      child: Row(
        children: [
          const AppBackButton(isTransparent: false),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.modificationDetails,
                  style: AppStyles.s16W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                4.verticalSpace,
                Text(
                  context.tr.viewDetailsTimelinesAndStatuses,
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
