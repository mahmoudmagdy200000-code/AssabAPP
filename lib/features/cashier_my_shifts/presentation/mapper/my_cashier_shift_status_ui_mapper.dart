import 'package:flutter/cupertino.dart';

import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/styles/app_colors.dart';
import '../../domain/enums/my_shifts_status.dart';

extension MyCashierShiftStatusUiMapper on MyShiftStatusType {
  String label(BuildContext context) {
    switch (this) {
      case MyShiftStatusType.pending:
        return context.tr.not_started;
      case MyShiftStatusType.completed:
        return context.tr.completed_name;
      case MyShiftStatusType.inProgress:
        return context.tr.in_progress_name;
      case MyShiftStatusType.reassigned:
        return context.tr.shiftReassigned;
    }
  }

  Color textColor(BuildContext context) {
    switch (this) {
      case MyShiftStatusType.pending:
        return context.customColor.text1;
      case MyShiftStatusType.completed:
        return AppColors.darkGreen;
      case MyShiftStatusType.inProgress:
        return AppColors.cyan;
      case MyShiftStatusType.reassigned:
        return AppColors.dark2Yellow;
    }
  }
}
