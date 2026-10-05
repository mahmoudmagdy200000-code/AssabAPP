import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';

class SelectItemSubCategoryListViewItem extends StatelessWidget {
  final String title;
  final String desc;
  final BoxBorder? border;

  const SelectItemSubCategoryListViewItem({
    super.key,
    required this.title,
    required this.desc,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border:
            border ??
            BorderDirectional(
              bottom: BorderSide(color: context.customColor.border),
              end: BorderSide(color: context.customColor.border),
            ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.r),
        margin: EdgeInsets.symmetric(vertical: 12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ),
                12.horizontalSpace,
                Icon(
                  Icons.keyboard_arrow_right_rounded,
                  color: context.customColor.text1,
                  size: 18.r,
                ),
              ],
            ),
            if (desc.isNotEmpty) ...[
              10.verticalSpace,
              Text(
                desc,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.s12W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
