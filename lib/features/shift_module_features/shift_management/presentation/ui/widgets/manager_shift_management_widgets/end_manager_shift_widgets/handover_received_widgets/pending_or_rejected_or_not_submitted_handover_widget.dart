import 'package:flutter/material.dart';

import '../../../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../../../core/styles/app_colors.dart';
import '../../../../../../../../../core/styles/app_styles.dart';

class PendingOrRejectedOrNotSubmittedHandoverNoteWidget
    extends StatelessWidget {
  final String title;
  final List<Widget> widgetsUnderTheMainTitle;
  final double? width;
  final double? height;

  const PendingOrRejectedOrNotSubmittedHandoverNoteWidget({
    super.key,
    required this.title,
    required this.widgetsUnderTheMainTitle,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: width ?? 5.w,
          height: height ?? 90.h,
          decoration: BoxDecoration(
            color: AppColors.red,
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),

        10.horizontalSpace,

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(title, style: AppStyles.s15W500),

              5.verticalSpace,

              ...widgetsUnderTheMainTitle,
            ],
          ),
        ),
      ],
    );
  }
}
