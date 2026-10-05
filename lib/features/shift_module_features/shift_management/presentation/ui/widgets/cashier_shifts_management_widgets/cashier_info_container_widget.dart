import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/widgets/custom_divider.dart';

class CashierInfoContainerWidget extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const CashierInfoContainerWidget({
    super.key,
    this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        border: Border.all(color: context.customColor.border, width: 1.w),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10.h,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: AppStyles.s14W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
            const CustomDivider(),
          ],

          ...children,
        ],
      ),
    );
  }
}
