import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/final_handover.dart';
import 'package:flutter/material.dart';

import '../../../../../../generated/l10n.dart';

extension ShiftStatusUiMapper on FinalHandOverStatus {
  String get label {
    switch (this) {
      case FinalHandOverStatus.pending:
        return S.current.pending;
      case FinalHandOverStatus.rejected:
        return S.current.rejected;
      case FinalHandOverStatus.completed:
        return S.current.completed_name;
      case FinalHandOverStatus.notSubmitted:
        return S.current.pendingHandover;
    }
  }

  String text(String accountantName, String? dateAndTime) {
    switch (this) {
      case FinalHandOverStatus.pending:
        return S.current.handoverPendingDesc(accountantName);
      case FinalHandOverStatus.completed:
        return S.current.handoverAcceptedDesc(accountantName, dateAndTime!);
      case FinalHandOverStatus.rejected:
        return S.current.handoverRejectedDesc(accountantName);
      case FinalHandOverStatus.notSubmitted:
        return S.current.handoverPendingDesc(accountantName);
    }
  }

  Color get cardColor {
    switch (this) {
      case FinalHandOverStatus.pending:
        return AppColors.darkOrange.withAlpha(10);
      case FinalHandOverStatus.completed:
        return AppColors.green.withAlpha(10);
      case FinalHandOverStatus.rejected:
        return AppColors.red.withAlpha(10);
      case FinalHandOverStatus.notSubmitted:
        return AppColors.darkOrange.withAlpha(10);
    }
  }

  Color get textColor {
    switch (this) {
      case FinalHandOverStatus.pending:
        return AppColors.darkOrange;
      case FinalHandOverStatus.completed:
        return AppColors.darkGreen;
      case FinalHandOverStatus.rejected:
        return Colors.red;
      case FinalHandOverStatus.notSubmitted:
        return AppColors.darkOrange;
    }
  }
}
