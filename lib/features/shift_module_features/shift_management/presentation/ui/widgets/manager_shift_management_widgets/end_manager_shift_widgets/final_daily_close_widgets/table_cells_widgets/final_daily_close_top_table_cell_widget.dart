import 'package:flutter/material.dart';

import '../../../../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../../../../core/styles/app_colors.dart';
import '../../../../../../../../../../core/styles/app_styles.dart';
import '../final_daily_close_table_cell_widget.dart';

class FinalDailyCloseTopTableCellWidget extends StatelessWidget {
  const FinalDailyCloseTopTableCellWidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return FinalDailyCloseTableCellWidget(
      topStartBorderRadius: 10.r,
      cellColor: AppColors.lightGray,
      bottomBorderSide: BorderSide(
        color: context.customColor.border,
        width: 1.w,
      ),
      endBorderSide: BorderSide(color: context.customColor.border, width: 1.w),

      child: Text(
        text,
        style: AppStyles.s14W500.copyWith(color: context.customColor.text1),
      ),
    );
  }
}
