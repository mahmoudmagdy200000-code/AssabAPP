import 'package:assab/core/enums/expenses_status.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/features/branch_manager_expenses/presentation/widgets/custom_data_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/network_file_preview_widget.dart';
import '../../../../core/widgets/rejected_widget.dart';
import '../cubit/expense_details/expense_details_cubit.dart';
import '../cubit/expense_details/expense_details_state.dart';
import '../widgets/expense_summary_pre_approval_view.dart';

class ExpensePreApprovalDetailsDetailsView extends StatefulWidget {
  final String id;

  const ExpensePreApprovalDetailsDetailsView({super.key, required this.id});

  @override
  State<ExpensePreApprovalDetailsDetailsView> createState() =>
      _ExpensePreApprovalDetailsDetailsViewState();
}

class _ExpensePreApprovalDetailsDetailsViewState
    extends State<ExpensePreApprovalDetailsDetailsView> {
  @override
  void initState() {
    _loadExpenseDetails();
    super.initState();
  }

  void _loadExpenseDetails() {
    context.read<ExpenseDetailsCubit>().getPreApprovalExpensesDetails(
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
        } else if (state is ExpensePreApprovalDetailsSuccess) {
          final preApprovalEntity = state.preApprovalEntity;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (preApprovalEntity.status.toLowerCase() ==
                        ExpensesStatus.rejected.key.toLowerCase()) ...[
                      RejectedWidget(reason: preApprovalEntity.cancelReason),
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
                                  context.tr.requestSummary,
                                  style: AppStyles.s16W600.copyWith(
                                    color: context.customColor.text1,
                                  ),
                                ),
                              ),
                              Text(
                                ExpensesStatus.fromString(
                                  preApprovalEntity.status,
                                ).displayName(context),
                                style: AppStyles.s12W500.copyWith(
                                  color: ExpensesStatus.fromString(
                                    preApprovalEntity.status,
                                  ).statusColor(),
                                ),
                              ),
                            ],
                          ),
                          14.verticalSpace,
                          const CustomDivider(),
                          14.verticalSpace,
                          ExpenseSummaryPreApprovalView(
                            purpose: preApprovalEntity.purpose,
                            estimatedAmount: preApprovalEntity.estimatedAmount,
                            paymentMethod: preApprovalEntity.paymentMethod,
                            priority: preApprovalEntity.priority.label ?? 'N/A',
                          ),
                        ],
                      ),
                    ),
                    14.verticalSpace,
                    Text(
                      context.tr.attachment,
                      style: AppStyles.s16W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    12.verticalSpace,
                  ],
                ),
              ),
              SliverList.builder(
                itemCount: preApprovalEntity.attachments.length,
                itemBuilder: (context, index) {
                  return NetworkFilePreviewWidget(
                    attachmentModel: preApprovalEntity.attachments[index],
                  );
                },
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    14.verticalSpace,
                    Text(
                      context.tr.itemList,
                      style: AppStyles.s16W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    8.verticalSpace,
                    CustomDataTable(
                      headers: [
                        context.tr.description,
                        context.tr.qty,
                        context.tr.rate,
                        context.tr.total,
                      ],
                      keysOrder: const ['description', 'qty', 'rate', 'total'],
                      items: preApprovalEntity.items
                          .map(
                            (e) => {
                              'description': e.description ?? 'N/A',
                              'qty': e.quantity?.toString(),
                              'rate': e.rate!.toStringAsFixed(2),
                              'total': e.total!.toStringAsFixed(2),
                            },
                          )
                          .toList(),
                    ),
                    14.verticalSpace,
                    Text(
                      context.tr.expenseList,
                      style: AppStyles.s16W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    8.verticalSpace,
                    CustomDataTable(
                      headers: [
                        context.tr.description,
                        context.tr.category,
                        context.tr.price,
                      ],
                      keysOrder: const ['description', 'category', 'price'],
                      items: preApprovalEntity.expenses
                          .map(
                            (e) => {
                              'description': e.description,
                              'category': e.category,
                              'price': e.price,
                            },
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
