import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_colors.dart';
import '../../../branch_manager_requests/presentation/widgets/branch_requests_status_widget.dart';

abstract class MonthlyInventoryStatusStrategy {
  static MonthlyInventoryStatusStrategy getStrategy(String status) {
    switch (status) {
      case 'in_progress':
        return InProgressMonthlyInventoryStatusStrategy();
      case 'completed':
        return CompletedMonthlyInventoryStatusStrategy();
      default:
        return InProgressMonthlyInventoryStatusStrategy();
    }
  }

  Widget buildStatus(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget buildStatusDetails(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class InProgressMonthlyInventoryStatusStrategy
    extends MonthlyInventoryStatusStrategy {
  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.inProgress,
      textColor: AppColors.orange,
      borderColor: context.customColor.border,
    );
  }

  @override
  Widget buildStatusDetails(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.inProgress,
      textColor: AppColors.orange,
      borderColor: Colors.transparent,
      backgroundColor: context.customColor.reversedTextColor,
    );
  }
}

class CompletedMonthlyInventoryStatusStrategy
    extends MonthlyInventoryStatusStrategy {
  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.completed,
      textColor: AppColors.lightGreen,
      borderColor: context.customColor.border,
    );
  }

  @override
  Widget buildStatusDetails(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.completed,
      textColor: AppColors.lightGreen,
      borderColor: Colors.transparent,
      backgroundColor: context.customColor.reversedTextColor,
    );
  }
}
