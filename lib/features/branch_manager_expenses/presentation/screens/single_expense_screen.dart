import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/paging_cubit/paging_state.dart';
import 'package:assab/core/cubits/payment_method/payment_method_cubit.dart';
import 'package:assab/core/cubits/switch_button/switch_button_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/helpers/payment_method_validator.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/features/branch_manager_expenses/domain/entities/single_invoice_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../domain/strategies/expenses_strategy.dart';
import '../../domain/strategies/single_invoice_draft_strategy.dart';
import '../cubit/expense_details/expense_details_cubit.dart';
import '../cubit/expense_details/expense_details_state.dart';
import '../cubit/single_expense/single_expense_cubit.dart';
import '../cubit/single_expense/single_expense_state.dart';
import '../widgets/expense_app_bar.dart';
import '../widgets/expenses_buttons_section.dart';
import '../widgets/single_expense_top_section.dart';
import 'expense_submitted_success.dart';
import 'single_expense_details_view.dart';
import 'single_expense_items_view.dart';
import 'single_expense_payment_view.dart';
import 'single_expense_summery_view.dart';

class SingleExpenseScreen extends StatefulWidget {
  final SingleInvoiceDraftStrategy strategy;
  final String? expenseId;

  const SingleExpenseScreen({
    super.key,
    required this.strategy,
    this.expenseId,
  });

  @override
  State<SingleExpenseScreen> createState() => _SingleExpenseScreenState();
}

class _SingleExpenseScreenState extends State<SingleExpenseScreen> {
  late final List<PaymentMethodValidator> _paymentMethodValidators;
  late final ValueNotifier<int> _currentIndexPaymentNotifier;

  bool _allApiFieldsIsValid = false;

  @override
  void initState() {
    _currentIndexPaymentNotifier = ValueNotifier<int>(0);

    _paymentMethodValidators = [
      FullPaymentMethodValidator(),
      PartialPaymentMethodValidator(),
      DeferredPaymentMethodValidator(),
    ];

    _getExpenseDetails();

    super.initState();
  }

  @override
  void dispose() {
    _currentIndexPaymentNotifier.dispose();
    widget.strategy.dispose();
    super.dispose();
  }

  void _getExpenseDetails() {
    widget.strategy.getDetails(context, widget.expenseId);
  }

  void _whenPaymentTypeChange(int index) {
    _currentIndexPaymentNotifier.value = index;
    context.read<PaymentMethodCubit>().clearSelection();

    if (_paymentMethodValidators.isEmpty) {
      _paymentMethodValidators.addAll(_paymentMethodValidators);
    }

    _removeValidationFieldsFromAnotherTypes(context: context, index: index);

    _paymentChangedToNextView(context, index);
  }

  void _changeView(BuildContext context) {
    context.read<PagingCubit>().nextStep();
  }

  void _goBackView(BuildContext context) {
    context.read<PagingCubit>().previousStep();
  }

  void _onBackButtonPressed(BuildContext context, int currentIndex) {
    _goBackView(context);

    switch (currentIndex) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        _removeValidationFieldsPaymentTypes(context);
        break;
      case 3:
        break;
    }
  }

  void _onNextButtonPressed(BuildContext context, int currentIndex) {
    _changeView(context);

    switch (currentIndex) {
      case 0:
        break;
      case 1:
        _paymentMethodValidators[0].addValidationsFields(
          context.read<ValidationCubit>(),
        );
        break;
      case 2:
        break;
      case 3:
        break;
    }
  }

  void _paymentChangedToNextView(BuildContext context, int index) {
    _paymentMethodValidators[index].addValidationsFields(
      context.read<ValidationCubit>(),
    );
  }

  void _removeValidationFieldsFromAnotherTypes({
    required BuildContext context,
    required int index,
  }) {
    for (int i = 0; i < _paymentMethodValidators.length; i++) {
      if (i == index) {
        continue;
      }

      _paymentMethodValidators[i].removeValidationsFields(
        context.read<ValidationCubit>(),
      );
    }
  }

  void _removeValidationFieldsPaymentTypes(BuildContext context) {
    for (int i = 0; i < _paymentMethodValidators.length; i++) {
      _paymentMethodValidators[i].removeValidationsFields(
        context.read<ValidationCubit>(),
      );
    }
  }

  bool _selector(ValidationState state, int currentIndex) {
    if (currentIndex == 0) {
      final supplierNameValid = state.fieldsValidity['supplierName'] ?? false;
      final invoiceNumValid = state.fieldsValidity['invoiceNum'] ?? false;
      final issueDateValid = state.fieldsValidity['issueDate'] ?? false;
      final photosValid = state.fieldsValidity['photos'] ?? false;
      final taxIdValid = state.fieldsValidity['taxId'] ?? false;
      final taxSupplierNameValid =
          state.fieldsValidity['taxSupplierName'] ?? false;
      final netAmountValid = state.fieldsValidity['netAmount'] ?? false;
      final vatAmountValid = state.fieldsValidity['vatAmount'] ?? false;
      final totalIncVatValid = state.fieldsValidity['totalIncVat'] ?? false;

      if (context.read<SwitchButtonCubit>().state) {
        return supplierNameValid &&
            invoiceNumValid &&
            issueDateValid &&
            photosValid &&
            taxIdValid &&
            taxSupplierNameValid &&
            netAmountValid &&
            vatAmountValid &&
            totalIncVatValid;
      } else {
        return supplierNameValid &&
            invoiceNumValid &&
            issueDateValid &&
            photosValid;
      }
    } else {
      return state.enableButton;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.primaryColor,
      body: Column(
        children: [
          ExpenseAppBar(text: context.tr.singleInvoice),
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
                  buildWhen: (previous, current) =>
                      (current is ExpenseSingleInvoiceDetailsSuccess) ||
                      (current is ExpenseDetailsLoading ||
                          current is ExpenseDetailsFailure),
                  builder: (context, state) {
                    SingleInvoiceEntity? singleInvoiceEntity;

                    if (state is ExpenseDetailsLoading) {
                      return const AppLoadingWidget();
                    } else if (state is ExpenseDetailsFailure) {
                      return AppFailureWidget(
                        failure: state.failure,
                        withBorder: false,
                        onRetry: _getExpenseDetails,
                      );
                    } else if (state is ExpenseSingleInvoiceDetailsSuccess) {
                      singleInvoiceEntity =
                          state.singleInvoiceResponseDataModel;

                      if (!_allApiFieldsIsValid) {
                        widget.strategy.validateAll(
                          context,
                          singleInvoiceEntity,
                        );
                        _allApiFieldsIsValid = true;

                        final paymentType = singleInvoiceEntity.paymentType;
                        if (paymentType != 'N/A') {
                          final index = switch (paymentType) {
                            'partial' => 1,
                            'deferred' => 2,
                            _ => 0,
                          };
                          _currentIndexPaymentNotifier.value = index;
                          _paymentMethodValidators[index].addValidationsFields(
                            context.read<ValidationCubit>(),
                          );
                        }
                      }
                    }

                    if (singleInvoiceEntity == null &&
                        widget.strategy is EditDraftSingleInvoiceStrategy) {
                      return widget.strategy.buildEmptyWidget(context);
                    }

                    return Column(
                      children: [
                        const SingleExpenseTopSection(),
                        14.verticalSpace,
                        Expanded(
                          child: BlocBuilder<PagingCubit, PagingState>(
                            builder: (context, state) {
                              final currentIndex = state.currentIndex;

                              return IndexedStack(
                                index: currentIndex,
                                children: [
                                  SingleExpenseDetailsView(
                                    strategy: widget.strategy,
                                    attachments:
                                        singleInvoiceEntity?.attachments ?? [],
                                  ),
                                  SingleExpenseItemsView(
                                    strategy: widget.strategy,
                                  ),
                                  BlocProvider(
                                    create: (context) => PagingCubit(
                                      totalSteps: 3,
                                      initialIndex:
                                          _currentIndexPaymentNotifier.value,
                                    ),
                                    child: SingleExpensePaymentView(
                                      whenPaymentTypeChange: (index) =>
                                          _whenPaymentTypeChange(index),
                                    ),
                                  ),
                                  SingleExpenseSummeryView(
                                    strategy: widget.strategy,
                                    apiAttachments:
                                        singleInvoiceEntity?.attachments ?? [],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        30.verticalSpace,
                        BlocConsumer<SingleExpenseCubit, SingleExpenseState>(
                          listener: (context, state) {
                            if (state is SingleExpenseSuccess) {
                              NavigationService.I.popToFirst();

                              NavigationService.I.push(
                                MaterialPageRoute(
                                  builder: (context) => ExpenseSubmittedSuccess(
                                    expensesStrategy:
                                        SingleInvoiceExpensesStrategy(),
                                    expenseId: state.response.id,
                                    expenseTypeModel:
                                        state.response.expenseType,
                                  ),
                                ),
                              );
                            } else if (state is SingleExpenseFailure) {
                              AppDialog.showErrorDialog(
                                context: context,
                                failure: state.failure,
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is SingleExpenseLoading) {
                              return const AppButtonLoading();
                            }

                            return ExpensesButtonsSection(
                              selector: _selector,
                              onClickBack: (currentIndex) =>
                                  _onBackButtonPressed(context, currentIndex),
                              onClickSaveToDraft: (currentIndex) =>
                                  widget.strategy.saveDraft(
                                    context,
                                    id: widget.expenseId ?? '',
                                    paymentMethodValidators:
                                        _paymentMethodValidators,
                                    currentIndexPaymentNotifier:
                                        _currentIndexPaymentNotifier,
                                  ),
                              onClickNextInvoice: (currentIndex) =>
                                  _onNextButtonPressed(context, currentIndex),
                              onClickSubmitInvoice: () =>
                                  widget.strategy.submit(
                                    context,
                                    id: widget.expenseId ?? '',
                                    paymentMethodValidators:
                                        _paymentMethodValidators,
                                    currentIndexPaymentNotifier:
                                        _currentIndexPaymentNotifier,
                                  ),
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
