import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/features/branch_manager_expenses/data/models/expense_type_model.dart';
import 'package:assab/features/brand_owner_requests/presentation/cubits/branch_owner_approve_reject_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/expenses_status.dart';
import '../../../../core/enums/expenses_steragies_keys.dart';
import '../../../../core/strategies/user_type_strategy.dart';
import '../../../brand_owner_requests/presentation/cubits/branch_owner_approve_reject_cubit.dart';
import '../../../brand_owner_requests/presentation/widgets/brand_owner_reject_expense_bottom_sheet_widget.dart';
import '../../data/models/expense_status_model.dart';
import '../cubit/expense_details/expense_details_cubit.dart';
import '../cubit/expense_details/expense_details_state.dart';
import '../widgets/expense_details_taps.dart';
import '../widgets/expense_details_top_section.dart';
import 'expense_approval_view.dart';

class ExpenseDetailsScreen extends StatefulWidget {
  final String id;
  final ExpenseTypeModel expenseTypeModel;
  final UserTypeStrategy userTypeStrategy;
  final ExpenseStatusModel expenseStatusModel;

  const ExpenseDetailsScreen({
    super.key,
    required this.id,
    required this.expenseTypeModel,
    required this.userTypeStrategy,
    required this.expenseStatusModel,
  });

  @override
  State<ExpenseDetailsScreen> createState() => _ExpenseDetailsScreenState();
}

class _ExpenseDetailsScreenState extends State<ExpenseDetailsScreen> {
  @override
  void initState() {
    super.initState();
    final expenseStrategy = ExpensesStrategiesKeys.fromType(
      widget.expenseTypeModel.value,
    ).strategy;
    context.read<ExpenseDetailsCubit>().getExpenseDetails(
      id: widget.id,
      strategy: expenseStrategy,
    );
  }

  bool _isPending(ExpenseDetailsState? state) {
    if (state is ExpenseQuickCashDetailsSuccess) {
      return state.quickCashResponseDataModel.status.toLowerCase() ==
          ExpensesStatus.pending.key.toLowerCase();
    } else if (state is ExpenseSingleInvoiceDetailsSuccess) {
      return state.singleInvoiceResponseDataModel.status.toLowerCase() ==
          ExpensesStatus.pending.key.toLowerCase();
    } else if (state is ExpensePreApprovalDetailsSuccess) {
      return state.preApprovalEntity.status.toLowerCase() ==
          ExpensesStatus.pending.key.toLowerCase();
    } else if (state is ExpenseGroupedInvoiceDetailsSuccess) {
      return state.groupedInvoiceEntity.status.toLowerCase() ==
          ExpensesStatus.pending.key.toLowerCase();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final expenseSterategy = ExpensesStrategiesKeys.fromType(
      widget.expenseTypeModel.value,
    ).strategy;

    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Column(
        children: [
          ExpenseDetailsTopSection(
            title: expenseSterategy.displayName(context),
          ),
          12.verticalSpace,
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.circular(30.r),
              ),
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  const ExpenseDetailsTaps(),
                  12.verticalSpace,
                  Expanded(
                    child: BlocSelector<PagingCubit, PagingState, int>(
                      selector: (state) => state.currentIndex,
                      builder: (context, currentIndex) {
                        return IndexedStack(
                          index: currentIndex,
                          children: [
                            expenseSterategy.expenseDetailsView(widget.id),
                            BlocBuilder<
                              ExpenseDetailsCubit,
                              ExpenseDetailsState
                            >(
                              builder: (context, state) {
                                return state.buildTimeLinesView();
                              },
                            ),
                            BlocBuilder<
                              ExpenseDetailsCubit,
                              ExpenseDetailsState
                            >(
                              builder: (context, state) {
                                return state.buildApprovalView();
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  BlocBuilder<ExpenseDetailsCubit, ExpenseDetailsState>(
                    builder: (context, state) {
                      return buildApprovalSection(context, state);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildApprovalSection(
    BuildContext context,
    ExpenseDetailsState expenseState,
  ) {
    if (widget.userTypeStrategy is BrandOwnerUserStrategy &&
        _isPending(expenseState)) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Container(
          padding: EdgeInsets.all(16.r),
          child: BlocProvider(
            create: (context) => getIt<BranchOwnerApproveRejectCubit>(),
            child:
                BlocListener<
                  BranchOwnerApproveRejectCubit,
                  BranchOwnerApproveRejectState
                >(
                  listener: (context, state) {
                    if (state is BranchOwnerApproveRejectExpenseSuccess) {
                      final strategy = ExpensesStrategiesKeys.fromType(
                        widget.expenseTypeModel.value,
                      ).strategy;
                      context.read<ExpenseDetailsCubit>().getExpenseDetails(
                        id: widget.id,
                        strategy: strategy,
                      );
                    } else if (state is BranchOwnerApproveRejectFailure) {
                      AppDialog.showErrorDialog(
                        context: context,
                        failure: state.failure,
                      );
                    }
                  },
                  child:
                      BlocBuilder<
                        BranchOwnerApproveRejectCubit,
                        BranchOwnerApproveRejectState
                      >(
                        builder: (context, state) {
                          if (state is BranchOwnerApproveRejectLoading) {
                            return const AppButtonLoading();
                          }

                          return Row(
                            children: [
                              Expanded(
                                child: CustomTextButton(
                                  text: context.tr.reject,
                                  onTap: () {
                                    final cubit = context
                                        .read<BranchOwnerApproveRejectCubit>();
                                    final strategy =
                                        ExpensesStrategiesKeys.fromType(
                                          widget.expenseTypeModel.value,
                                        ).strategy;
                                    AppBottomSheet.showModal(
                                      context,
                                      isScrollControlled: true,
                                      (
                                        bottomSheetContext,
                                      ) => BlocProvider.value(
                                        value: cubit,
                                        child:
                                            BrandOwnerRejectExpenseBottomSheetWidget(
                                              id: widget.id,
                                              onSuccess: () {
                                                context
                                                    .read<ExpenseDetailsCubit>()
                                                    .getExpenseDetails(
                                                      id: widget.id,
                                                      strategy: strategy,
                                                    );
                                              },
                                            ),
                                      ),
                                    );
                                  },
                                  padding: EdgeInsets.symmetric(vertical: 16.r),
                                  textColor: context.customColor.error,
                                  borderRadius: 20.r,
                                ),
                              ),
                              12.horizontalSpace,
                              Expanded(
                                child: CustomTextButton(
                                  text: context.tr.approve,
                                  onTap: () {
                                    context
                                        .read<BranchOwnerApproveRejectCubit>()
                                        .approveExpense(
                                          expenseId: widget.id,
                                          onSuccess: () {
                                            final strategy =
                                                ExpensesStrategiesKeys.fromType(
                                                  widget.expenseTypeModel.value,
                                                ).strategy;
                                            context
                                                .read<ExpenseDetailsCubit>()
                                                .getExpenseDetails(
                                                  id: widget.id,
                                                  strategy: strategy,
                                                );
                                          },
                                        );
                                  },
                                  padding: EdgeInsets.symmetric(vertical: 16.r),
                                  textColor:
                                      context.customColor.reversedTextColor,
                                  borderRadius: 20.r,
                                  backgroundColor: context.theme.primaryColor,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
