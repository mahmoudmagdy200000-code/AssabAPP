import 'package:assab/core/enums/expenses_status.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/rejected_widget.dart';
import '../cubit/expense_details/expense_details_cubit.dart';
import '../cubit/expense_details/expense_details_state.dart';
import '../widgets/expense_grouped_invoie_details_details_sliver_list_widget.dart';
import '../widgets/expense_summary_grouped_invoice_view.dart';
import '../widgets/row_payment_widget.dart';

class ExpenseGroupedInvoiceDetailsDetailsView extends StatefulWidget {
  final String id;

  const ExpenseGroupedInvoiceDetailsDetailsView({super.key, required this.id});

  @override
  State<ExpenseGroupedInvoiceDetailsDetailsView> createState() =>
      _ExpenseGroupedInvoiceDetailsDetailsViewState();
}

class _ExpenseGroupedInvoiceDetailsDetailsViewState
    extends State<ExpenseGroupedInvoiceDetailsDetailsView> {
  late final ValueNotifier<int?> _showDetailsNotifier;

  @override
  void initState() {
    _showDetailsNotifier = ValueNotifier<int?>(null);
    _loadExpenseDetails();
    super.initState();
  }

  void _loadExpenseDetails() {
    context.read<ExpenseDetailsCubit>().getGroupedInvoiceExpensesDetails(
      id: widget.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseDetailsCubit, ExpenseDetailsState>(
      builder: (context, state) {
        if (state is ExpenseDetailsLoading) {
          return const AppLoadingWidget();
        } else if (state is ExpenseDetailsFailure) {
          return AppFailureWidget(
            failure: state.failure,
            onRetry: () => _loadExpenseDetails(),
          );
        } else if (state is ExpenseGroupedInvoiceDetailsSuccess) {
          final groupedInvoiceEntity = state.groupedInvoiceEntity;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (groupedInvoiceEntity.status.toLowerCase() ==
                        ExpensesStatus.rejected.key.toLowerCase()) ...[
                      RejectedWidget(reason: groupedInvoiceEntity.cancelReason),
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
                                  groupedInvoiceEntity.status,
                                ).displayName(context),
                                style: AppStyles.s12W500.copyWith(
                                  color: ExpensesStatus.fromString(
                                    groupedInvoiceEntity.status,
                                  ).statusColor(),
                                ),
                              ),
                            ],
                          ),
                          14.verticalSpace,
                          const CustomDivider(),
                          14.verticalSpace,
                          ExpenseSummaryGroupedInvoiceView(
                            supplierName:
                                groupedInvoiceEntity.defaultSupplier.name,
                            totalGroupedInvoice:
                                groupedInvoiceEntity.totalGroupedInvoice,
                          ),
                          14.verticalSpace,
                          const CustomDivider(),
                          14.verticalSpace,
                          RowPaymentWidget(
                            paymentMethod: groupedInvoiceEntity.paymentMethod,
                          ),
                        ],
                      ),
                    ),
                    14.verticalSpace,
                    Text(
                      context.tr.groupedInvoices,
                      style: AppStyles.s16W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    12.verticalSpace,
                  ],
                ),
              ),
              SliverList.builder(
                itemCount: groupedInvoiceEntity.invoices.length,
                itemBuilder: (context, index) {
                  return ExpenseGroupedInvoieDetailsDetailsSliverListWidget(
                    showDetailsNotifier: _showDetailsNotifier,
                    index: index,
                    invoice: groupedInvoiceEntity.invoices[index],
                  );
                },
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
