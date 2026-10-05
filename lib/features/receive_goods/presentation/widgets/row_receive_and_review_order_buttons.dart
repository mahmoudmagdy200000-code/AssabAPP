import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/custom_text_button.dart';

class RowReceiveAndReviewOrderButtons extends StatelessWidget {
  final VoidCallback onReceiveTap;

  const RowReceiveAndReviewOrderButtons({
    super.key,
    required this.onReceiveTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        13.verticalSpace,
        const CustomDivider(),
        10.verticalSpace,
        Row(
          children: [
            // CustomTextButton(
            //   text: context.tr.review,
            //   onTap: () {},
            //   borderRadius: 1000.r,
            //   padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 21.r),
            //   textColor: context.customColor.text1,
            // ),
            // 10.horizontalSpace,
            Expanded(
              child: CustomTextButton(
                text: context.tr.receiveThisOrder,
                onTap: onReceiveTap,
                borderRadius: 1000.r,
                padding: EdgeInsets.symmetric(vertical: 12.r),
                borderColor: Colors.transparent,
                backgroundColor: context.theme.primaryColor,
                textColor: context.customColor.reversedTextColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
