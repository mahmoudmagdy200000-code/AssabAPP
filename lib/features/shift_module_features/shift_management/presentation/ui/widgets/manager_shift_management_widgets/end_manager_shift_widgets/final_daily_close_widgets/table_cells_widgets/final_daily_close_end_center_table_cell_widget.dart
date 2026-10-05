import 'package:flutter/material.dart';

import '../../../../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../../../../core/styles/app_styles.dart';
import '../final_daily_close_table_cell_widget.dart';

class FinalDailyCloseEndCenterTableCellWidget extends StatelessWidget {
  const FinalDailyCloseEndCenterTableCellWidget({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return FinalDailyCloseTableCellWidget(
      endBorderSide: BorderSide(color: context.customColor.border, width: 1.w),
      bottomBorderSide: BorderSide(
        color: context.customColor.border,
        width: 1.w,
      ),
      startBorderSide: BorderSide(
        color: context.customColor.border,
        width: 1.w,
      ),
      topBorderSide: BorderSide(color: context.customColor.border, width: 1.w),
      child: Text(
        text,
        style: AppStyles.s14W500.copyWith(color: context.customColor.text1),
      ),
    );
  }
}
