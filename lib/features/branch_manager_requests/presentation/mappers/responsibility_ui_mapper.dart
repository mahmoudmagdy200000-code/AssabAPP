import 'package:assab/core/styles/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../domain/enums/responsibility_status.dart';

extension ResponsibilityStatusUiText on ResponsibilityStatus {
  String title(BuildContext context) {
    switch (this) {
      case ResponsibilityStatus.approved:
        return context.tr.approved;
      case ResponsibilityStatus.rejected:
        return context.tr.rejected;
      case ResponsibilityStatus.notSubmitted:
        return context.tr.pendingYourApproval;
    }
  }
}

extension ResponsibilityStatusUiColor on ResponsibilityStatus {
  Color textColor() {
    switch (this) {
      case ResponsibilityStatus.approved:
        return AppColors.lightGreen;
      case ResponsibilityStatus.rejected:
        return AppColors.red;
      case ResponsibilityStatus.notSubmitted:
        return AppColors.darkOrange;
    }
  }
}

extension ResponsibilityStatusCardDescContent on ResponsibilityStatus {
  String varianceStatusDescription(
    BuildContext context, {
    required String text,
  }) {
    switch (this) {
      case ResponsibilityStatus.approved:
        return context.tr.youAcceptedYourPartAt(text);
      case ResponsibilityStatus.rejected:
        return context.tr.youRejectedYourPartAt(text);
      case ResponsibilityStatus.notSubmitted:
        return context.tr.variancePendingApprovalDesc(text);
    }
  }
}
