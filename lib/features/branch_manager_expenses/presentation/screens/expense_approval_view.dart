import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/features/branch_manager_expenses/data/models/expenses_approval_model.dart';
import 'package:flutter/material.dart';

import '../widgets/approval_widget.dart';

class ExpenseApprovalView extends StatelessWidget {
  final ExpensesApprovalModel? approval;
  const ExpenseApprovalView({super.key, required this.approval});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.text2,
        borderRadius: BorderRadius.circular(30.r),
      ),
      padding: EdgeInsets.all(24.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.tr.approvalDesc,
            textAlign: TextAlign.center,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text1),
          ),
          12.verticalSpace,
          if (approval != null)
            ApprovalWidget(
              name: approval!.name,
              status: approval!.status.displayName(context),
              position: approval!.role,
              statusColor: approval!.status.statusColor(),
            ),
        ],
      ),
    );
  }
}
