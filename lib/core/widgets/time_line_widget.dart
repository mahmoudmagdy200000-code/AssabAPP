import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../styles/app_styles.dart';

class TimeLineWidget extends StatelessWidget {
  final String title;
  final String date;
  final String desc;
  final Widget icon;

  const TimeLineWidget({
    super.key,
    required this.title,
    required this.date,
    required this.desc,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              icon,
              Expanded(
                child: Container(width: 1.w, color: context.customColor.border),
              ),
            ],
          ),
          12.horizontalSpace,
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: context.customColor.border),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 8.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppStyles.s14W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  6.verticalSpace,
                  Text(
                    date,
                    style: AppStyles.s12W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  6.verticalSpace,
                  Text(
                    desc,
                    style: AppStyles.s13W500.copyWith(
                      color: context.customColor.text4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
