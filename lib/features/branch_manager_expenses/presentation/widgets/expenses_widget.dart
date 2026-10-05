import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/price_label.dart';
import 'package:assab/features/branch_manager_expenses/data/models/expense_status_model.dart';
import 'package:assab/features/branch_manager_expenses/data/models/expense_type_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/enums/expenses_status.dart';
import '../../../../core/enums/expenses_steragies_keys.dart';

class ExpensesWidget extends StatelessWidget {
  final String expenseName;
  final ExpenseTypeModel expenseType;
  final ExpenseStatusModel status;
  final double amount;
  final String date;
  final String createdAt;
  final VoidCallback? onClickDraft;
  final BoxBorder? border;

  const ExpensesWidget({
    super.key,
    required this.expenseName,
    required this.expenseType,
    required this.status,
    required this.amount,
    required this.date,
    required this.createdAt,
    this.onClickDraft,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final expensesStrategy = ExpensesStrategiesKeys.fromType(
      expenseType.value,
    ).strategy;

    final expensesStatus = ExpensesStatus.fromString(status.value);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(20.r),
        border: border,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 16.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSvg(assetName: expensesStrategy.assetName, width: 20.w),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        expenseName,
                        style: AppStyles.s13W600.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ),
                    PriceLabel(amount: amount.toString()),
                  ],
                ),
                4.verticalSpace,
                Text(
                  expensesStrategy.displayName(context),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text6,
                  ),
                ),
                4.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '$date - ${DateFormatter.formatTimeHM(DateTime.tryParse(createdAt)) ?? ''}',
                        style: AppStyles.s12W400.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                    ),
                    if (expensesStatus == ExpensesStatus.draft) ...[
                      AppGestureDetectorButton(
                        onTap: onClickDraft ?? () {},
                        child: Container(
                          decoration: BoxDecoration(
                            color: context.customColor.text2,
                            borderRadius: BorderRadius.circular(1000.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.r,
                            vertical: 5.r,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.mode_edit_outline_outlined,
                                color: context.customColor.text3,
                              ),
                              5.horizontalSpace,
                              Text(
                                context.tr.draft,
                                style: AppStyles.s10W500.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    if (expensesStatus == ExpensesStatus.approved ||
                        expensesStatus == ExpensesStatus.rejected ||
                        expensesStatus == ExpensesStatus.pending) ...[
                      Text(
                        expensesStatus.displayName(context),
                        style: AppStyles.s14W400.copyWith(
                          color: expensesStatus.statusColor(),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
