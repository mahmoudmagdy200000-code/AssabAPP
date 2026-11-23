import 'package:assab/core/enums/expenses_status.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/rejected_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/features/branch_manager_expenses/domain/strategies/expenses_strategy.dart';
import 'package:assab/core/enums/expenses_steragies_keys.dart';

import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/network_file_preview_widget.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import '../cubit/expense_details/expense_details_cubit.dart';
import '../cubit/expense_details/expense_details_state.dart';
import '../widgets/expense_summary_quick_cash_view.dart';
import 'expense_details_screen.dart';

class ExpenseQuickCashDetailsDetailsView extends StatefulWidget {
  final String id;

  const ExpenseQuickCashDetailsDetailsView({super.key, required this.id});

  @override
  State<ExpenseQuickCashDetailsDetailsView> createState() =>
      _ExpenseQuickCashDetailsDetailsViewState();
}

class _ExpenseQuickCashDetailsDetailsViewState
    extends State<ExpenseQuickCashDetailsDetailsView> {
  @override
  void initState() {
    context.read<ExpenseDetailsCubit>().getQuickCashExpensesDetails(
      id: widget.id,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseDetailsCubit, ExpenseDetailsState>(
      builder: (context, state) {
        if (state is ExpenseDetailsLoading) {
          return const AppLoadingWidget();
        } else if (state is ExpenseDetailsFailure) {
          return AppFailureWidget(failure: state.failure);
        } else if (state is ExpenseQuickCashDetailsSuccess) {
          final quickCashResponseDataModel = state.quickCashResponseDataModel;
          final role = context
              .findAncestorWidgetOfExactType<ExpenseDetailsScreen>()
              ?.userTypeStrategy;
          final status = quickCashResponseDataModel.status.toLowerCase();
          final isRejected =
              status == ExpensesStatus.rejected.key.toLowerCase();
          final canEdit =
              (role is BranchManagerUserStrategy ||
                  role is CashierUserStrategy) &&
              (isRejected || status == ExpensesStatus.draft.key.toLowerCase());

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isRejected) ...[
                      RejectedWidget(
                        rejection: quickCashResponseDataModel.rejection,
                      ),
                      14.verticalSpace,
                    ],
                    if (canEdit) ...[
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: TextButton.icon(
                          onPressed: () {
                            final strategy =
                                ExpensesStrategiesKeys.fromType(
                                      'quick_cash',
                                    ).strategy
                                    as QuickCashExpensesStrategy;
                            NavigationService.I.push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    strategy.expenseScreen(context, widget.id),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit_outlined),
                          label: Text(context.tr.edit),
                        ),
                      ),
                      8.verticalSpace,
                    ],
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: context.customColor.border),
                      ),
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  context.tr.expenseSummary,
                                  style: AppStyles.s16W600.copyWith(
                                    color: context.customColor.text1,
                                  ),
                                ),
                              ),
                              Text(
                                ExpensesStatus.fromString(
                                  quickCashResponseDataModel.status,
                                ).displayName(context),
                                style: AppStyles.s12W500.copyWith(
                                  color: ExpensesStatus.fromString(
                                    quickCashResponseDataModel.status,
                                  ).statusColor(),
                                ),
                              ),
                            ],
                          ),
                          14.verticalSpace,
                          const CustomDivider(),
                          14.verticalSpace,
                          ExpenseSummaryQuickCashView(
                            quickCashEntity: quickCashResponseDataModel,
                          ),
                        ],
                      ),
                    ),
                    14.verticalSpace,
                    Text(
                      context.tr.expenseInvoiceReceipt,
                      style: AppStyles.s16W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    12.verticalSpace,
                  ],
                ),
              ),
              SliverList.builder(
                itemCount: quickCashResponseDataModel.attachments.length,
                itemBuilder: (context, index) {
                  return NetworkFilePreviewWidget(
                    attachmentModel:
                        quickCashResponseDataModel.attachments[index],
                  );
                },
              ),
            ],
          );
        }

        return Center(
          child: Text(
            context.tr.noExpensesYet,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),
        );
      },
    );
  }
}
