import 'package:flutter/material.dart';

import '../../../../../core/extensions/number_extensions.dart';
import '../../../../../core/styles/app_colors.dart';
import '../../../../../core/styles/app_styles.dart';

class CardLabelWidget extends StatelessWidget {
  const CardLabelWidget({super.key, required this.title, this.textColor});
  final Color? textColor;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.only(
        start: 10.w,
        end: 10.w,
        top: 5.h,
        bottom: 5.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        title,
        style: AppStyles.s10W400.copyWith(color: textColor ?? AppColors.sBlack),
      ),
    );
  }
}
