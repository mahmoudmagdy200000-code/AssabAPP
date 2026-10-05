import 'package:assab/core/cubits/search/search_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/strategies/priority_registry.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/upload_expense_invoice_receipt.dart';
import 'package:assab/features/branch_manager_expenses/data/models/attachment_model.dart';
import 'package:assab/features/branch_manager_expenses/domain/strategies/pre_approval_draft_strategy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/payment_method/payment_method_cubit.dart';
import '../../../../core/cubits/select_priority/select_priority_cubit.dart';
import '../../../../core/cubits/select_priority/select_priority_state.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/enums/payment_method.dart';
import '../../../../core/strategies/priorities_strategy.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/label_text_field.dart';
import '../../data/models/pre_approval_data_model.dart';
import '../../domain/strategies/expenses_strategy.dart';
import '../cubit/create_expense_previous_request/create_expense_previous_request_cubit.dart';
import '../widgets/expenses_payment_field.dart';
import '../widgets/reuse_past_request_bottom_sheet_widget.dart';

class PreApprovalRequestDetailsView extends StatefulWidget {
  final PreApprovalDraftStrategy strategy;
  final List<AttachmentModel> attachments;

  const PreApprovalRequestDetailsView({
    super.key,
    required this.strategy,
    required this.attachments,
  });

  @override
  State<PreApprovalRequestDetailsView> createState() =>
      _PreApprovalRequestDetailsViewState();
}

class _PreApprovalRequestDetailsViewState
    extends State<PreApprovalRequestDetailsView> {
  late final TextEditingController _purposeController;
  late final TextEditingController _estimatedAmountController;
  late List<PrioritiesStrategy> _priorities;

  @override
  void initState() {
    super.initState();

    final validationState = context.read<ValidationCubit>().state;

    _purposeController = TextEditingController(
      text: validationState.fieldsValue['purpose'] ?? '',
    );
    _estimatedAmountController = TextEditingController(
      text: validationState.fieldsValue['estimatedAmount'] ?? '',
    );

    _priorities = PriorityRegistry.getAllPriorities;

    if (_priorities.isNotEmpty) {
      _priorities.removeAt(0);
    }
  }

  @override
  void dispose() {
    _purposeController.dispose();
    _estimatedAmountController.dispose();
    super.dispose();
  }

  void _openReusePastRequestBottomSheet(BuildContext context) {
    AppBottomSheet.show(
      context,
      (context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => getIt<CreateExpensePreviousRequestCubit>(),
          ),
          BlocProvider(
            create: (context) => SearchCubit<PreApprovalDataModel>(),
          ),
        ],
        child: ReusePastRequestBottomSheetWidget(
          expensesStrategy: PreApprovalExpensesStrategy(),
        ),
      ),
    );
  }

  void _validate({
    required BuildContext context,
    required String fieldName,
    required String value,
    required bool isValid,
  }) {
    context.read<ValidationCubit>().validateFieldAndStoreValue(
      fieldName: fieldName,
      value: value,
      isValid: isValid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              15.verticalSpace,
              Text(
                context
                    .tr
                    .submitAnExpenseRequestRequiringPriorAdministrativeApproval,
                style: AppStyles.s14W400.copyWith(
                  color: context.customColor.text1,
                ),
              ),
              14.verticalSpace,
              const CustomDivider(),
              14.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: LabelTextField(text: context.tr.purpose)),
                  widget.strategy.buildReusePastRequest(
                    context,
                    () => _openReusePastRequestBottomSheet(context),
                  ),
                ],
              ),
              8.verticalSpace,
              ContainerCustomTextField(
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _purposeController,
                        hintText: context.tr.describeWhatThisRequestIsFor,
                        onChanged: (value) {
                          _validate(
                            context: context,
                            fieldName: 'purpose',
                            value: value,
                            isValid: value.isNotEmpty,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              14.verticalSpace,
              ContainerCustomTextField(
                label: context.tr.estimatedAmount,
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _estimatedAmountController,
                        hintText: context.tr.howMuchWillThisExpenseCost,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final amount = double.tryParse(value) ?? 0;

                          _validate(
                            context: context,
                            fieldName: 'estimatedAmount',
                            value: value,
                            isValid: amount > 0,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              14.verticalSpace,
              ExpensesPaymentField(
                onPaymentMethodSelected: (value) {
                  _validate(
                    context: context,
                    fieldName: 'paymentMethod',
                    value: value.paymentMethodToString(),
                    isValid: true,
                  );

                  if (value == PaymentMethod.supplier) {
                    context.read<ValidationCubit>().addDynamicFields({
                      'supplierId',
                    });

                    _validate(
                      context: context,
                      fieldName: 'supplierId',
                      value:
                          context
                              .read<PaymentMethodCubit>()
                              .state
                              .supplier
                              ?.id
                              .toString() ??
                          '',
                      isValid: true,
                    );
                  } else {
                    context.read<ValidationCubit>().removeDynamicFields({
                      'supplierId',
                    });
                  }
                },
              ),
              14.verticalSpace,
              LabelTextField(text: context.tr.uploadInvoiceReceipt),
              10.verticalSpace,
              const UploadExpenseInvoiceReceipt(),
            ],
          ),
        ),
        widget.strategy.buildAttachmentsSection(context, widget.attachments),
        SliverToBoxAdapter(
          child: Column(
            children: [
              14.verticalSpace,
              LabelTextField(text: context.tr.priority),
              8.verticalSpace,
              BlocBuilder<SelectPriorityCubit, SelectPriorityState>(
                builder: (context, state) {
                  if (_priorities.isEmpty) {
                    _priorities = PriorityRegistry.getAllPriorities
                      ..removeAt(0);
                  }

                  return Row(
                    children: List.generate(_priorities.length, (index) {
                      final isSelected =
                          state.selectedPriority?.priorityValue ==
                          _priorities[index].priorityValue;

                      return Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomTextButton(
                                text: _priorities[index].priorityLabel(context),
                                textColor: isSelected
                                    ? _priorities[index].color
                                    : context.customColor.text1,
                                borderColor: isSelected
                                    ? _priorities[index].color
                                    : context.customColor.border,
                                onTap: () {
                                  context
                                      .read<SelectPriorityCubit>()
                                      .selectPriority(_priorities[index]);

                                  _validate(
                                    context: context,
                                    fieldName: 'priority',
                                    value: _priorities[index].priorityValue,
                                    isValid: true,
                                  );
                                },
                              ),
                            ),
                            if (index != _priorities.length - 1)
                              10.horizontalSpace,
                          ],
                        ),
                      );
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
