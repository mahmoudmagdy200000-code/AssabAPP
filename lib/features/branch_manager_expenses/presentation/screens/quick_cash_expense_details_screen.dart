import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/features/branch_manager_expenses/data/models/attachment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/navigation/navigation_service.dart';
import '../../data/models/quick_cash_expense_data_model.dart';
import '../../domain/strategies/expenses_strategy.dart';
import '../../domain/strategies/quick_cash_draft_strategy.dart';
import '../cubit/quick_cash/quick_cash_cubit.dart';
import '../cubit/quick_cash/quick_cash_state.dart';
import '../widgets/expense_app_bar.dart';
import '../widgets/quick_cash_expense_details_middle_section.dart';
import '../widgets/quick_cash_expense_details_top_section.dart';
import 'expense_submitted_success.dart';

class QuickCashExpenseDetailsScreen extends StatelessWidget {
  final QuickCashDraftStrategy strategy;
  final QuickCashExpenseData quickCashExpenseData;
  final List<AttachmentModel> apiAttachments;
  final String expenseId;

  const QuickCashExpenseDetailsScreen({
    super.key,
    required this.strategy,
    required this.quickCashExpenseData,
    required this.apiAttachments,
    required this.expenseId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.primaryColor,
      body: Column(
        children: [
          ExpenseAppBar(text: context.tr.quickCashExpense),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              child: AppPaddingWidget(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const QuickCashExpenseDetailsTopSection(),
                          QuickCashExpenseDetailsMiddleSection(
                            quickCashExpenseData: quickCashExpenseData,
                          ),
                          14.verticalSpace,
                          Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Text(
                              context.tr.expenseInvoiceReceipt,
                              style: AppStyles.s18W600.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                          ),
                          14.verticalSpace,
                        ],
                      ),
                    ),
                    strategy.buildSummaryAttachmentSection(
                      context,
                      quickCashExpenseData,
                      apiAttachments,
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          47.verticalSpace,
                          BlocConsumer<QuickCashCubit, QuickCashState>(
                            listener: (context, state) {
                              if (state is QuickCashSuccess) {
                                NavigationService.I.popToFirst();

                                NavigationService.I.push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ExpenseSubmittedSuccess(
                                          expensesStrategy:
                                              QuickCashExpensesStrategy(),
                                          expenseTypeModel:
                                              state.response.expenseType,
                                          expenseId: state.response.id,
                                        ),
                                  ),
                                );
                              } else if (state is QuickCashFailure) {
                                AppDialog.showErrorDialog(
                                  context: context,
                                  failure: state.failure,
                                );
                              }
                            },
                            builder: (context, state) {
                              if (state is QuickCashLoading) {
                                return const AppButtonLoading();
                              }

                              return Row(
                                children: [
                                  Expanded(
                                    child: AppButton(
                                      onClick: () => strategy.saveDraft(
                                        context,
                                        quickCashExpenseData,
                                        id: expenseId,
                                      ),
                                      enabled: true,
                                      isTransparent: true,
                                      text: context.tr.saveToDraft,
                                    ),
                                  ),
                                  16.horizontalSpace,
                                  Expanded(
                                    child: AppButton(
                                      onClick: () => strategy.submit(
                                        context,
                                        quickCashExpenseData,
                                        id: expenseId,
                                      ),
                                      enabled: true,
                                      text: context.tr.submitExpense,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
