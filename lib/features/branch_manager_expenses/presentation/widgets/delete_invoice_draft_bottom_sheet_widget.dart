import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../../data/models/expense_data_model.dart';
import 'expenses_widget.dart';

class DeleteInvoiceDraftBottomSheetWidget extends StatelessWidget {
  final ExpenseDataModel expenseDataModel;
  final VoidCallback onDelete;

  const DeleteInvoiceDraftBottomSheetWidget({
    super.key,
    required this.expenseDataModel,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 0,
      child: Column(
        children: [
          Text(
            context.tr.deleteInvoiceDraft,
            style: AppStyles.s20W600.copyWith(color: context.customColor.text1),
          ),
          12.verticalSpace,
          Text(
            context.tr.thisActionIsPermanentAndCannotBeUndone,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),
          Text(
            context.tr.areYouSureYouWantToDeleteThisDraft,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),
          24.verticalSpace,
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: context.customColor.border),
            ),
            child: ExpensesWidget(
              amount: expenseDataModel.amount,
              createdAt: expenseDataModel.createdAt,
              date: expenseDataModel.date,
              expenseName: expenseDataModel.expenseName,
              expenseType: expenseDataModel.expenseType,
              status: expenseDataModel.status,
              onClickDraft: () => NavigationService.I.pop(),
            ),
          ),
          const Spacer(),
          CustomTextButton(
            text: context.tr.delete,
            backgroundColor: context.customColor.error,
            textColor: context.customColor.reversedTextColor,
            borderColor: context.customColor.error,
            borderRadius: 20.r,
            padding: EdgeInsets.symmetric(vertical: 19.r, horizontal: 25.r),
            onTap: onDelete,
          ),
        ],
      ),
    );
  }
}
