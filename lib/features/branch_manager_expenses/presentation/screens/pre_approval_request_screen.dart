import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/features/branch_manager_expenses/presentation/screens/expense_submitted_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/widgets/animated_container_of_paging_widget.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/custom_paging_widget.dart';
import '../../domain/entities/pre_approval_entity.dart';
import '../../domain/strategies/expenses_strategy.dart';
import '../../domain/strategies/pre_approval_draft_strategy.dart';
import '../cubit/expense_details/expense_details_cubit.dart';
import '../cubit/expense_details/expense_details_state.dart';
import '../cubit/pre_approval/pre_approval_cubit.dart';
import '../cubit/pre_approval/pre_approval_state.dart';
import '../widgets/expense_app_bar.dart';
import '../widgets/expenses_buttons_section.dart';
import 'pre_approval_request_details_view.dart';
import 'pre_approval_request_items_view.dart';
import 'pre_approval_request_summary_view.dart';

class PreApprovalRequestScreen extends StatefulWidget {
  final PreApprovalDraftStrategy strategy;
  final String? expenseId;

  const PreApprovalRequestScreen({
    super.key,
    required this.strategy,
    this.expenseId,
  });

  @override
  State<PreApprovalRequestScreen> createState() =>
      _PreApprovalRequestScreenState();
}

class _PreApprovalRequestScreenState extends State<PreApprovalRequestScreen> {
  bool _allApiFieldsIsValid = false;

  @override
  void initState() {
    super.initState();
    _getExpenseDetails();
  }

  @override
  void dispose() {
    widget.strategy.dispose();
    super.dispose();
  }

  void _getExpenseDetails() {
    widget.strategy.getDetails(context, widget.expenseId);
  }

  bool _selector(ValidationState state, int currentIndex) {
    if (currentIndex == 0) {
      final purpose = state.fieldsValidity['purpose'] ?? false;
      final estimatedAmount = state.fieldsValidity['estimatedAmount'] ?? false;
      final paymentMethod = state.fieldsValidity['paymentMethod'] ?? false;
      final photos = state.fieldsValidity['photos'] ?? false;
      final priority = state.fieldsValidity['priority'] ?? false;

      return purpose && estimatedAmount && paymentMethod && photos && priority;
    } else {
      return state.enableButton;
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = <String>[
      context.tr.details,
      context.tr.items,
      context.tr.summary,
    ];

    return Scaffold(
      backgroundColor: context.theme.primaryColor,
      body: Column(
        children: [
          ExpenseAppBar(text: context.tr.preApprovalRequest),
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
                child: BlocBuilder<ExpenseDetailsCubit, ExpenseDetailsState>(
                  builder: (context, state) {
                    PreApprovalEntity? preApprovalEntity;

                    if (state is ExpenseDetailsLoading) {
                      return const AppLoadingWidget();
                    } else if (state is ExpenseDetailsFailure) {
                      return AppFailureWidget(
                        failure: state.failure,
                        withBorder: false,
                        onRetry: _getExpenseDetails,
                      );
                    } else if (state is ExpensePreApprovalDetailsSuccess) {
                      preApprovalEntity = state.preApprovalEntity;

                      if (!_allApiFieldsIsValid) {
                        widget.strategy.validateAll(context, preApprovalEntity);
                        _allApiFieldsIsValid = true;
                      }
                    }

                    if (preApprovalEntity == null &&
                        widget.strategy is EditDraftPreApprovalDraftStrategy) {
                      return widget.strategy.buildEmptyWidget(context);
                    }

                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            return BlocBuilder<PagingCubit, PagingState>(
                              builder: (context, state) {
                                final currentIndex = state.currentIndex;
                                return Row(
                                  children: [
                                    CustomPagingWidget(
                                      condition: index == currentIndex,
                                      text: title[index],
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.r,
                                        vertical: 5.r,
                                      ),
                                    ),
                                    AnimatedContainerOfPagingWidget(
                                      condition: index == currentIndex,
                                      width: 40.r,
                                      color: context.theme.primaryColor,
                                    ),
                                  ],
                                );
                              },
                            );
                          }),
                        ),
                        Expanded(
                          child: BlocBuilder<PagingCubit, PagingState>(
                            builder: (context, state) {
                              final currentIndex = state.currentIndex;
                              return IndexedStack(
                                index: currentIndex,
                                children: [
                                  PreApprovalRequestDetailsView(
                                    strategy: widget.strategy,
                                    attachments:
                                        preApprovalEntity?.attachments ?? [],
                                  ),
                                  PreApprovalRequestItemsView(
                                    strategy: widget.strategy,
                                  ),
                                  PreApprovalRequestSummaryView(
                                    strategy: widget.strategy,
                                    apiAttachments:
                                        preApprovalEntity?.attachments ?? [],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        20.verticalSpace,
                        BlocConsumer<PreApprovalCubit, PreApprovalState>(
                          listener: (context, state) {
                            if (state is PreApprovalFailure) {
                              AppDialog.showErrorDialog(
                                context: context,
                                failure: state.failure,
                              );
                            } else if (state is PreApprovalSuccess) {
                              NavigationService.I.popToFirst();

                              NavigationService.I.push(
                                MaterialPageRoute(
                                  builder: (context) => ExpenseSubmittedSuccess(
                                    expensesStrategy:
                                        PreApprovalExpensesStrategy(),
                                    expenseId: state.response.id,
                                    expenseTypeModel:
                                        state.response.expenseType,
                                  ),
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is PreApprovalLoading) {
                              return const AppLoadingWidget();
                            }

                            return ExpensesButtonsSection(
                              selector: _selector,
                              onClickBack: (currentIndex) {
                                context.read<PagingCubit>().previousStep();
                              },
                              onClickSaveToDraft: (currentIndex) =>
                                  widget.strategy.saveDraft(
                                    context,
                                    id: widget.expenseId ?? '',
                                  ),
                              onClickNextInvoice: (currentIndex) {
                                context.read<PagingCubit>().nextStep();
                              },
                              onClickSubmitInvoice: () => widget.strategy
                                  .submit(context, id: widget.expenseId ?? ''),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
