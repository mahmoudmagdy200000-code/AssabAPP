import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/expenses_steragies_keys.dart';
import '../../../../core/styles/app_styles.dart';
import '../../data/models/expense_data_model.dart';
import '../../domain/strategies/expense_category.dart';
import '../cubit/branch_manager_expenses_history/branch_manager_expenses_history_cubit.dart';
import '../cubit/branch_manager_expenses_history/branch_manager_expenses_history_state.dart';
import '../widgets/delete_invoice_draft_bottom_sheet_widget.dart';

class DraftExpenseDetailsScreen extends StatelessWidget {
  final ExpenseDataModel expenseDataModel;

  const DraftExpenseDetailsScreen({super.key, required this.expenseDataModel});

  void _whenClickDeleteExpense(BuildContext context) {
    final branchManagerExpensesHistoryCubit = context
        .read<BranchManagerExpensesHistoryCubit>();

    AppBottomSheet.showModal(
      context,
      (context) => DeleteInvoiceDraftBottomSheetWidget(
        expenseDataModel: expenseDataModel,
        onDelete: () {
          branchManagerExpensesHistoryCubit.removeDraftExpense(
            id: expenseDataModel.id,
          );

          NavigationService.I.pop();
        },
      ),
    );
  }

  void _whenClickContinueEditing(BuildContext context) {
    NavigationService.I.pop();

    NavigationService.I.push(
      MaterialPageRoute(
        builder: (context) => ExpensesStrategiesKeys.fromType(
          expenseDataModel.expenseType.value,
        ).strategy.expenseScreen(context, expenseDataModel.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 40.r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr.expenseDetails,
              style: AppStyles.s20W600.copyWith(
                color: context.customColor.text1,
              ),
            ),
            Text(
              context.tr.expenseDetailsDesc,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
            18.verticalSpace,
            Expanded(
              child: ExpensesStrategiesKeys.fromType(
                expenseDataModel.expenseType.value,
              ).strategy.expenseDetailsView(expenseDataModel.id),
            ),
            15.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocConsumer<
                  BranchManagerExpensesHistoryCubit,
                  BranchManagerExpensesHistoryState
                >(
                  listener: (context, state) {
                    if (state
                        is BranchManagerExpensesHistoryRemoveDraftSuccess) {
                      context
                          .read<BranchManagerExpensesHistoryCubit>()
                          .loadExpenses(type: const DraftExpense());
                      NavigationService.I.pop();
                    } else if (state is BranchManagerExpensesHistoryFailure) {
                      AppDialog.showErrorDialog(
                        context: context,
                        failure: state.failure,
                      );
                    }
                  },
                  buildWhen: (previous, current) =>
                      (current
                          is BranchManagerExpensesHistoryRemoveDraftLoading),
                  listenWhen: (previous, current) =>
                      (current
                          is BranchManagerExpensesHistoryRemoveDraftSuccess) ||
                      (current is BranchManagerExpensesHistoryFailure),
                  builder: (context, state) {
                    if (state
                        is BranchManagerExpensesHistoryRemoveDraftLoading) {
                      return const AppLoadingWidget();
                    }

                    return ButtonTextIcon(
                      onTap: () => _whenClickDeleteExpense(context),
                      label: context.tr.delete,
                      padding: EdgeInsets.symmetric(
                        vertical: 13.r,
                        horizontal: 25.r,
                      ),
                      spaceBetweenTextAndIcon: 5,
                      borderRadius: BorderRadius.circular(15.r),
                      icon: const AppSvg(assetName: AppAssets.trashSvg),
                    );
                  },
                ),
                12.horizontalSpace,
                Expanded(
                  child: ButtonTextIcon(
                    onTap: () => _whenClickContinueEditing(context),
                    label: context.tr.continueEditing,
                    padding: EdgeInsets.symmetric(
                      vertical: 13.r,
                      horizontal: 25.r,
                    ),
                    textColor: context.customColor.reversedTextColor,
                    borderRadius: BorderRadius.circular(15.r),
                    isTransparent: false,
                    spaceBetweenTextAndIcon: 5,
                    icon: AppSvg(
                      assetName: AppAssets.edit,
                      colorFilter: ColorFilter.mode(
                        context.customColor.reversedTextColor,
                        BlendMode.srcIn,
                      ),
                      width: 16.w,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
