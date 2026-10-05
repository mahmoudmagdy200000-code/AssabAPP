import 'package:flutter/material.dart';

import '../../../../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../../../../core/styles/app_colors.dart';
import '../../../../../../../../../../core/widgets/custom_text_field.dart';
import '../final_daily_close_table_cell_widget.dart';

class FinalDailyCloseBottomCenterTableCellWidget extends StatelessWidget {
  const FinalDailyCloseBottomCenterTableCellWidget({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return FinalDailyCloseTableCellWidget(
      bottomStartBorderRadius: 10.r,
      cellColor: AppColors.lightGray,
      bottomBorderSide: BorderSide(
        color: context.customColor.border,
        width: 1.w,
      ),
      endBorderSide: BorderSide(color: context.customColor.border, width: 1.w),

      child: CustomTextField(
        textAlign: TextAlign.center,
        isFilled: true,
        fillColor: AppColors.lightGray,
        isEnabled: false,
        controller: TextEditingController(text: text),
      ),
    );
  }
}
