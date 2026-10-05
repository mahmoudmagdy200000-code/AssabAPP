import 'package:assab/core/enums/expenses_status.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/features/branch_manager_expenses/presentation/widgets/expense_details_vat_view.dart';
import 'package:assab/features/branch_manager_expenses/presentation/widgets/expense_summary_single_invoice_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/network_file_preview_widget.dart';
import '../../../../core/widgets/rejected_widget.dart';
import '../cubit/expense_details/expense_details_cubit.dart';
import '../cubit/expense_details/expense_details_state.dart';
import '../widgets/row_payment_widget.dart';

class ExpenseSingleInvoiceDetailsDetailsView extends StatefulWidget {
  final String id;

  const ExpenseSingleInvoiceDetailsDetailsView({super.key, required this.id});

  @override
  State<ExpenseSingleInvoiceDetailsDetailsView> createState() =>
      _ExpenseSingleInvoiceDetailsDetailsViewState();
}

class _ExpenseSingleInvoiceDetailsDetailsViewState
    extends State<ExpenseSingleInvoiceDetailsDetailsView> {
  @override
  void initState() {
    _loadExpenseDetails();
    super.initState();
  }

  void _loadExpenseDetails() {
    context.read<ExpenseDetailsCubit>().getSingleInvoiceExpensesDetails(
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
        } else if (state is ExpenseSingleInvoiceDetailsSuccess) {
          final singleInvoiceResponseDataModel =
              state.singleInvoiceResponseDataModel;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (singleInvoiceResponseDataModel.status.toLowerCase() ==
                        ExpensesStatus.rejected.key.toLowerCase()) ...[
                      RejectedWidget(
                        reason: singleInvoiceResponseDataModel.cancelReason,
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
                                  singleInvoiceResponseDataModel.status,
                                ).displayName(context),
                                style: AppStyles.s12W500.copyWith(
                                  color: ExpensesStatus.fromString(
                                    singleInvoiceResponseDataModel.status,
                                  ).statusColor(),
                                ),
                              ),
                            ],
                          ),
                          14.verticalSpace,
                          const CustomDivider(),
                          14.verticalSpace,
                          ExpenseSummarySingleInvoiceView(
                            issueDate:
                                DateFormatter.formatDateMDY(
                                  DateTime.tryParse(
                                    singleInvoiceResponseDataModel.createdAt,
                                  ),
                                ) ??
                                '-',
                            supplierName:
                                singleInvoiceResponseDataModel.supplierName,
                            taxId: singleInvoiceResponseDataModel.taxId,
                            totalAmountPaid:
                                singleInvoiceResponseDataModel.totalAmountPaid,
                            totalInvoiceItems: singleInvoiceResponseDataModel
                                .totalInvoiceItems,
                          ),
                          16.verticalSpace,
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: context.customColor.border,
                              ),
                            ),
                            padding: EdgeInsets.all(16.r),
                            child: Column(
                              children: [
                                Text(
                                  context.tr.thisExpenseIncludesVat,
                                  style: AppStyles.s14W500.copyWith(
                                    color: context.customColor.text1,
                                  ),
                                ),
                                14.verticalSpace,
                                const CustomDivider(),
                                14.verticalSpace,
                                ExpenseDetailsVatView(
                                  invoiceNumber: singleInvoiceResponseDataModel
                                      .invoiceNumber,
                                  netAmount:
                                      singleInvoiceResponseDataModel.netAmount,
                                  vatAmount:
                                      singleInvoiceResponseDataModel.vatAmount,
                                  totalInclVat: singleInvoiceResponseDataModel
                                      .totalAmount,
                                ),
                              ],
                            ),
                          ),
                          14.verticalSpace,
                          RowPaymentWidget(
                            paymentMethod:
                                singleInvoiceResponseDataModel.paymentMethod,
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
                itemCount: singleInvoiceResponseDataModel.attachments.length,
                itemBuilder: (context, index) {
                  return NetworkFilePreviewWidget(
                    attachmentModel:
                        singleInvoiceResponseDataModel.attachments[index],
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
