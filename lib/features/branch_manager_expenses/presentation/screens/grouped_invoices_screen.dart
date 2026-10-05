import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/features/branch_manager_expenses/presentation/cubit/expense_details/expense_details_cubit.dart';
import 'package:assab/features/branch_manager_expenses/presentation/cubit/expense_details/expense_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/media/media_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/utils/app_dialog.dart';
import '../../../../core/widgets/animated_container_of_paging_widget.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/custom_paging_widget.dart';
import '../../domain/entities/grouped_invoice_entity.dart';
import '../../domain/strategies/expenses_strategy.dart';
import '../../domain/strategies/grouped_invoice_draft_strategy.dart';
import '../cubit/grouped_invoice/grouped_invoice_cubit.dart';
import '../widgets/expense_app_bar.dart';
import '../widgets/expenses_buttons_section.dart';
import 'expense_submitted_success.dart';
import 'grouped_invoice_invoices_view.dart';
import 'grouped_invoice_session_setup_view.dart';
import 'grouped_invoice_summary_view.dart';

class GroupedInvoicesScreen extends StatefulWidget {
  final GroupedInvoiceDraftStrategy strategy;
  final String? expenseId;

  const GroupedInvoicesScreen({
    super.key,
    required this.strategy,
    this.expenseId,
  });

  @override
  State<GroupedInvoicesScreen> createState() => _GroupedInvoicesScreenState();
}

class _GroupedInvoicesScreenState extends State<GroupedInvoicesScreen> {
  final Map<String, MediaCubit> mediaCubits = {};
  bool _allApiFieldsIsValid = false;

  @override
  void initState() {
    _getExpenseDetails();
    context.read<ValidationCubit>().validateFieldAndStoreValue(
      fieldName: 'paymentType',
      value: 'full',
      isValid: true,
    );
    super.initState();
  }

  @override
  void dispose() {
    widget.strategy.dispose();
    super.dispose();
  }

  void _getExpenseDetails() {
    widget.strategy.getDetails(context, widget.expenseId);
  }

  void _onClickSubmitInvoice(BuildContext context) {
    widget.strategy.submit(
      context,
      id: widget.expenseId ?? '',
      mediaCubits: mediaCubits,
    );
  }

  void _onClickSaveToDraft(BuildContext context) {
    widget.strategy.saveDraft(
      context,
      id: widget.expenseId ?? '',
      mediaCubits: mediaCubits,
    );
  }

  bool _selector(
    BuildContext context,
    ValidationState state,
    int currentIndex,
  ) {
    final validationCubit = context.read<ValidationCubit>();

    if (currentIndex == 0) {
      final requiredFields = ['supplierId', 'supplierName'];

      validationCubit.fieldIsExists('paymentMethod')
          ? requiredFields.add('paymentMethod')
          : null;

      validationCubit.fieldIsExists('dueDate')
          ? requiredFields.add('dueDate')
          : null;

      for (final field in requiredFields) {
        final isValid = state.fieldsValidity[field];

        if (isValid != true) {
          return false;
        }
      }

      return true;
    } else {
      return state.enableButton;
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = <String>[
      context.tr.sessionSetup.toUpperCase(),
      context.tr.invoices.toUpperCase(),
      context.tr.summary.toUpperCase(),
    ];

    return Scaffold(
      backgroundColor: context.theme.primaryColor,
      body: Column(
        children: [
          ExpenseAppBar(text: context.tr.groupedInvoices),
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
                    GroupedInvoiceEntity? groupedInvoiceEntity;

                    if (state is ExpenseDetailsLoading) {
                      return const AppLoadingWidget();
                    } else if (state is ExpenseDetailsFailure) {
                      return AppFailureWidget(
                        failure: state.failure,
                        withBorder: false,
                        onRetry: _getExpenseDetails,
                      );
                    } else if (state is ExpenseGroupedInvoiceDetailsSuccess) {
                      groupedInvoiceEntity = state.groupedInvoiceEntity;

                      if (!_allApiFieldsIsValid) {
                        widget.strategy.validateAll(
                          context,
                          groupedInvoiceEntity,
                        );
                        _allApiFieldsIsValid = true;
                      }
                    }

                    final initialPaymentIndex =
                        switch (groupedInvoiceEntity?.paymentType) {
                          'partial' => 1,
                          'deferred' => 2,
                          _ => 0,
                        };

                    if (groupedInvoiceEntity == null &&
                        widget.strategy
                            is EditDraftGroupedInvoiceDraftStrategy) {
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
                        12.verticalSpace,
                        Expanded(
                          child: BlocBuilder<PagingCubit, PagingState>(
                            builder: (context, state) {
                              final currentIndex = state.currentIndex;
                              return IndexedStack(
                                key: const ValueKey('GroupedInvoicesStack'),
                                index: currentIndex,
                                children: [
                                  GroupedInvoiceSessionSetupView(
                                    initialPaymentIndex: initialPaymentIndex,
                                  ),
                                  GroupedInvoiceInvoicesView(
                                    strategy: widget.strategy,
                                    mediaCubits: mediaCubits,
                                    groupedInvoiceEntity: groupedInvoiceEntity,
                                  ),
                                  GroupedInvoiceSummaryView(
                                    strategy: widget.strategy,
                                    groupedInvoiceEntity: groupedInvoiceEntity,
                                    mediaCubits: mediaCubits,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        20.verticalSpace,
                        BlocConsumer<GroupedInvoiceCubit, GroupedInvoiceState>(
                          listener: (context, state) {
                            if (state is GroupedInvoiceFailure) {
                              AppDialog.showErrorDialog(
                                context: context,
                                failure: state.failure,
                              );
                            } else if (state is GroupedInvoiceSuccess) {
                              NavigationService.I.popToFirst();

                              NavigationService.I.push(
                                MaterialPageRoute(
                                  builder: (context) => ExpenseSubmittedSuccess(
                                    expensesStrategy:
                                        GroupedInvoiceExpensesStrategy(),
                                    expenseId: state.response.id,
                                    expenseTypeModel:
                                        state.response.expenseType,
                                  ),
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is GroupedInvoiceLoading) {
                              return const AppButtonLoading();
                            }

                            return ExpensesButtonsSection(
                              selector: (state, currentIndex) =>
                                  _selector(context, state, currentIndex),
                              onClickBack: (currentIndex) {
                                context.read<PagingCubit>().previousStep();
                              },
                              onClickSaveToDraft: (currentIndex) =>
                                  _onClickSaveToDraft(context),
                              onClickNextInvoice: (currentIndex) {
                                context.read<PagingCubit>().nextStep();
                              },
                              onClickSubmitInvoice: () =>
                                  _onClickSubmitInvoice(context),
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
