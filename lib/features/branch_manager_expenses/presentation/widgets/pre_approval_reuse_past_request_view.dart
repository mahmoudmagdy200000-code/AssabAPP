import 'package:assab/core/cubits/search/search_cubit.dart';
import 'package:assab/core/cubits/search/search_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/features/branch_manager_expenses/data/models/expense_status_model.dart';
import 'package:assab/features/branch_manager_expenses/data/models/expense_type_model.dart';
import 'package:assab/features/branch_manager_expenses/presentation/cubit/pre_approval/pre_approval_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../data/models/pre_approval_data_model.dart';
import '../cubit/pre_approval/pre_approval_state.dart';
import 'expenses_empty_widget.dart';
import 'expenses_widget.dart';

class PreApprovalReusePastRequestView extends StatelessWidget {
  final ScrollController scrollController;
  final ValueNotifier<int?> selectedInvoice;
  final void Function(String id) selectedInvoiceId;

  const PreApprovalReusePastRequestView({
    super.key,
    required this.scrollController,
    required this.selectedInvoice,
    required this.selectedInvoiceId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PreApprovalCubit, PreApprovalState>(
      listener: (context, state) {
        if (state is GetPreviousPreApprovalSuccess) {
          context.read<SearchCubit<PreApprovalDataModel>>().setData(
            state.response.data,
          );
        }
      },
      builder: (context, state) {
        if (state is GetPreviousPreApprovalLoading) {
          return const AppLoadingWidget();
        } else if (state is GetPreviousPreApprovalFailure) {
          return AppFailureWidget(
            failure: state.failure,
            withBorder: false,
            onRetry: () {
              context.read<PreApprovalCubit>().getPastRequests(loadMore: false);
            },
          );
        }
        return BlocBuilder<
          SearchCubit<PreApprovalDataModel>,
          SearchState<PreApprovalDataModel>
        >(
          builder: (context, searchState) {
            if (searchState is SearchSuccess<PreApprovalDataModel>) {
              final expenses = searchState.results;

              if (expenses.isEmpty) {
                return SingleChildScrollView(
                  child: ExpensesEmptyWidget(
                    icon: AppAssets.expensesEmptyPNG,
                    title: context.tr.noExpensesYet,
                    desc: context.tr.noExpensesYetDesc,
                  ),
                );
              }

              return ListView.builder(
                controller: scrollController,
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final expense = expenses[index];

                  return AppGestureDetectorButton(
                    onTap: () {
                      if (selectedInvoice.value != index) {
                        selectedInvoice.value = index;
                        selectedInvoiceId(expense.id!);
                      }
                    },
                    child: Column(
                      children: [
                        ValueListenableBuilder(
                          valueListenable: selectedInvoice,
                          builder: (context, value, child) {
                            return ExpensesWidget(
                              border: value == index
                                  ? Border.all(
                                      color: context.theme.primaryColor,
                                    )
                                  : null,
                              amount: expense.totalAmount?.toDouble() ?? 0,
                              createdAt: expense.createdAt ?? 'N/A',
                              date: expense.createdAt ?? 'N/A',
                              expenseName: expense.data?.purpose ?? 'N/A',
                              expenseType:
                                  expense.expenseType ??
                                  ExpenseTypeModel(value: '', label: ''),
                              status:
                                  expense.status ??
                                  ExpenseStatusModel(
                                    value: '',
                                    label: '',
                                    color: '',
                                  ),
                            );
                          },
                        ),
                        if (index < expenses.length - 1) 6.verticalSpace,
                      ],
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}
