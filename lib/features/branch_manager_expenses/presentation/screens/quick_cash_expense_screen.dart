import 'package:assab/core/cubits/add_item/add_item_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/features/branch_manager_expenses/domain/strategies/quick_cash_draft_strategy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/media/media_cubit.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/payment_method.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/label_text_field.dart';
import '../../../../core/widgets/upload_expense_invoice_receipt.dart';
import '../../data/models/attachment_model.dart';
import '../../data/models/quick_cash_expense_data_model.dart';
import '../../domain/entities/quick_cash_entity.dart';
import '../cubit/expense_details/expense_details_cubit.dart';
import '../cubit/expense_details/expense_details_state.dart';
import '../cubit/quick_cash/quick_cash_cubit.dart';
import '../widgets/add_item_expense_button.dart';
import '../widgets/expense_app_bar.dart';
import '../widgets/expense_item_widget.dart';
import '../widgets/expenses_payment_field.dart';
import '../widgets/quick_cash_expenses_date_field.dart';
import 'quick_cash_expense_details_screen.dart';

class QuickCashExpenseScreen extends StatefulWidget {
  final QuickCashDraftStrategy strategy;
  final String? expenseId;

  const QuickCashExpenseScreen({
    super.key,
    required this.strategy,
    this.expenseId,
  });

  @override
  State<QuickCashExpenseScreen> createState() => _QuickCashExpenseScreenState();
}

class _QuickCashExpenseScreenState extends State<QuickCashExpenseScreen> {
  final List<AttachmentModel> apiAttachments = [];

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

  void _validationField({
    required BuildContext context,
    required String fieldName,
    required String value,
    required bool condition,
  }) {
    context.read<ValidationCubit>().validateFieldAndStoreValue(
      fieldName: fieldName,
      value: value,
      isValid: condition,
    );
  }

  void _onClickViewSummery(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();
    final fieldsValue = validationCubit.state.fieldsValue;

    final expenseItems =
        context.read<AddItemCubit>().state.lists['quick_cash_expense_items'] ??
        [];

    List<ExpenseItemData> listItems = [];

    if (expenseItems.isNotEmpty) {
      listItems = expenseItems.map((id) {
        final title = validationCubit.state.fieldsValue['item_title_$id'] ?? '';
        final amount =
            validationCubit.state.fieldsValue['item_amount_$id'] ?? '';
        return ExpenseItemData(itemTitle: title, itemAmount: amount);
      }).toList();
    }

    final quickCashExpenseData = QuickCashExpenseData(
      expenseDate: fieldsValue['date'].toString(),
      expenseTitle: fieldsValue['expenseTitle'].toString(),
      totalAmount: fieldsValue['totalAmount'].toString(),
      listItems: listItems,
      files: context.read<MediaCubit>().allFilesSelected,
      paymentMethod: fieldsValue['paymentMethod'].toString(),
      paymentSupplierId: fieldsValue['paymentSupplierId'].toString(),
    );

    NavigationService.I.push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => getIt<QuickCashCubit>(),
          child: QuickCashExpenseDetailsScreen(
            strategy: widget.strategy,
            quickCashExpenseData: quickCashExpenseData,
            apiAttachments: apiAttachments,
            expenseId: widget.expenseId ?? '',
          ),
        ),
      ),
    );
  }

  void _validateItemsAmount(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();

    final totalAmount =
        double.tryParse(
          validationCubit.state.fieldsValue['totalAmount'] ?? '0',
        ) ??
        0;

    final itemsTotalAmount = validationCubit.state.fieldsValue.entries
        .where((e) => e.key.startsWith('item_amount_'))
        .map((e) => double.tryParse(e.value) ?? 0)
        .fold<double>(0, (sum, value) => sum + value);

    validationCubit.validateField(
      'itemsAmount',
      totalAmount == itemsTotalAmount,
    );
  }

  void _onTitleAndTotalAmountChanged(
    BuildContext context,
    String title,
    String amount,
  ) {
    _validationField(
      context: context,
      fieldName: 'expenseTitle',
      value: title,
      condition: title.isNotEmpty,
    );

    final amountNum = double.tryParse(amount) ?? 0;

    _validationField(
      context: context,
      fieldName: 'totalAmount',
      value: amount,
      condition: amount.isNotEmpty && amountNum <= 500,
    );
  }

  void _onPaymentMethodSelected(BuildContext context, PaymentMethod value) {
    _validationField(
      context: context,
      fieldName: 'paymentMethod',
      value: value.paymentMethodToString(),
      condition: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.primaryColor,
      body: Column(
        children: [
          ExpenseAppBar(text: context.tr.quickCashExpense),
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
                      (current is ExpenseDetailsLoading) ||
                      (current is ExpenseDetailsFailure) ||
                      (current is ExpenseQuickCashDetailsSuccess),
                  builder: (context, state) {
                    QuickCashEntity? quickCashEntity;

                    if (state is ExpenseDetailsLoading) {
                      return const AppLoadingWidget();
                    } else if (state is ExpenseDetailsFailure) {
                      return AppFailureWidget(
                        failure: state.failure,
                        withBorder: false,
                        onRetry: _getExpenseDetails,
                      );
                    } else if (state is ExpenseQuickCashDetailsSuccess) {
                      quickCashEntity = state.quickCashResponseDataModel;
                      if (!_allApiFieldsIsValid) {
                        widget.strategy.validateAll(context, quickCashEntity);
                        _allApiFieldsIsValid = true;
                      }

                      apiAttachments.clear();
                      apiAttachments.addAll(quickCashEntity.attachments);
                    }

                    if (quickCashEntity == null &&
                        widget.strategy is EditDraftQuickCashStrategy) {
                      return widget.strategy.buildEmptyWidget(context);
                    }

                    return CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              QuickCashExpensesDateField(
                                date: quickCashEntity?.expenseDate,
                              ),
                              12.verticalSpace,
                              ExpensesItem(
                                isSingle: true,
                                labelTitle: context.tr.expenseTitle,
                                labelAmount: context.tr.totalAmount,
                                title: quickCashEntity?.expenseName,
                                amount: quickCashEntity?.totalAmount,
                                totalAmountFieldValidationKey: 'totalAmount',
                                onDataChanged: (title, amount) =>
                                    _onTitleAndTotalAmountChanged(
                                      context,
                                      title,
                                      amount,
                                    ),
                              ),
                              widget.strategy.buildQuickCashListItemExpense(
                                context,
                                () => _validateItemsAmount(context),
                                quickCashEntity,
                              ),
                              const AddItemExpenseButton(),
                              12.verticalSpace,
                              ExpensesPaymentField(
                                onPaymentMethodSelected: (value) =>
                                    _onPaymentMethodSelected(context, value),
                              ),
                              12.verticalSpace,
                              LabelTextField(
                                text: context.tr.uploadExpenseInvoiceReceipt,
                              ),
                              8.verticalSpace,
                              const UploadExpenseInvoiceReceipt(),
                              10.verticalSpace,
                            ],
                          ),
                        ),
                        widget.strategy.buildAttachmentsSection(
                          context,
                          quickCashEntity,
                        ),
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              47.verticalSpace,
                              BlocSelector<
                                ValidationCubit,
                                ValidationState,
                                bool
                              >(
                                selector: (state) => state.enableButton,
                                builder: (context, enableButton) {
                                  return AppButton(
                                    onClick: () => _onClickViewSummery(context),
                                    enabled: enableButton,
                                    text: context.tr.viewSummary,
                                  );
                                },
                              ),
                            ],
                          ),
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
