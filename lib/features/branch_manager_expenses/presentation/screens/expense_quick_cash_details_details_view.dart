import 'package:assab/core/enums/expenses_status.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/rejected_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/network_file_preview_widget.dart';
import '../cubit/expense_details/expense_details_cubit.dart';
import '../cubit/expense_details/expense_details_state.dart';
import '../widgets/expense_summary_quick_cash_view.dart';

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

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (quickCashResponseDataModel.status.toLowerCase() ==
                        ExpensesStatus.rejected.key.toLowerCase()) ...[
                      RejectedWidget(
                        reason: quickCashResponseDataModel.cancelReason,
                      ),
                      14.verticalSpace,
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
