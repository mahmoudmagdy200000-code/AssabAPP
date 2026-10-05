import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_calendar.dart';
import 'package:assab/features/branch_manager_expenses/presentation/cubit/single_expense/single_expense_cubit.dart';
import 'package:assab/features/branch_manager_expenses/presentation/cubit/suppliers/suppliers_cubit.dart';
import 'package:assab/features/branch_manager_expenses/presentation/widgets/reuse_past_request_bottom_sheet_widget.dart';
import 'package:assab/features/branch_manager_expenses/presentation/widgets/supplier_list_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/search/search_cubit.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/label_text_field.dart';
import '../../data/models/single_invoice_data_model.dart';
import '../../data/models/supplier_model.dart';
import '../../domain/strategies/expenses_strategy.dart';
import '../../domain/strategies/single_invoice_draft_strategy.dart';
import '../cubit/create_expense_previous_request/create_expense_previous_request_cubit.dart';
import 'single_expense_tax_invoice.dart';

class SingleExpenseDetailsViewMiddleSection extends StatefulWidget {
  final SingleInvoiceDraftStrategy strategy;

  const SingleExpenseDetailsViewMiddleSection({
    super.key,
    required this.strategy,
  });

  @override
  State<SingleExpenseDetailsViewMiddleSection> createState() =>
      _SingleExpenseDetailsViewMiddleSectionState();
}

class _SingleExpenseDetailsViewMiddleSectionState
    extends State<SingleExpenseDetailsViewMiddleSection> {
  late final ValueNotifier<SupplierModel?> _selectedSupplierNotifier;
  late final TextEditingController _invoiceNumberController;

  @override
  void initState() {
    _invoiceNumberController = TextEditingController(
      text:
          context.read<ValidationCubit>().state.fieldsValue['invoiceNum'] ?? '',
    );
    _selectedSupplierNotifier = ValueNotifier(null);
    super.initState();
  }

  @override
  void dispose() {
    _invoiceNumberController.dispose();
    _selectedSupplierNotifier.dispose();
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
            create: (context) => SearchCubit<SingleInvoiceDataModel>(),
          ),
        ],
        child: ReusePastRequestBottomSheetWidget(
          expensesStrategy: SingleInvoiceExpensesStrategy(),
        ),
      ),
    );
  }

  void _openSupplierListBottomSheet(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();
    final singleExpenseCubit = context.read<SingleExpenseCubit>();
    final suppliersCubit = context.read<SuppliersCubit>();

    AppBottomSheet.show(
      context,
      (context) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: validationCubit),
          BlocProvider.value(value: singleExpenseCubit),
          BlocProvider.value(value: suppliersCubit),
          BlocProvider(create: (context) => SearchCubit<SupplierModel>()),
        ],
        child: SupplierListBottomSheetWidget(
          onSelected: (supplier) {
            _selectedSupplierNotifier.value = supplier;
            context.read<ValidationCubit>().validateFieldAndStoreValue(
              fieldName: 'supplierName',
              value: supplier.name,
              isValid: true,
            );
            context.read<ValidationCubit>().validateFieldAndStoreValue(
              fieldName: 'supplierId',
              value: supplier.id.toString(),
              isValid: true,
            );
          },
        ),
      ),
    );
  }

  void _openCalendar(BuildContext context) {
    AppBottomSheet.show(
      context,
      (context) => AppPaddingWidget(
        top: 0,
        child: CustomCalendar(
          onDateSelected: (date) => _onDateSelected(context, date),
        ),
      ),
    );
  }

  void _onDateSelected(BuildContext context, DateTime date) {
    _validate(
      context: context,
      fieldName: 'issueDate',
      value: date.toIso8601String(),
      isValid: true,
    );

    NavigationService.I.pop();
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

  void _validateTaxFields({
    required BuildContext context,
    required String taxId,
    required String supplierName,
    required String netAmount,
    required String vatAmount,
    required String totalIncVat,
  }) {
    _validate(
      context: context,
      fieldName: 'taxId',
      value: taxId,
      isValid: taxId.isNotEmpty,
    );
    _validate(
      context: context,
      fieldName: 'taxSupplierName',
      value: supplierName,
      isValid: supplierName.isNotEmpty,
    );
    _validate(
      context: context,
      fieldName: 'netAmount',
      value: netAmount,
      isValid: netAmount.isNotEmpty,
    );
    _validate(
      context: context,
      fieldName: 'vatAmount',
      value: vatAmount,
      isValid: vatAmount.isNotEmpty,
    );
    _validate(
      context: context,
      fieldName: 'totalIncVat',
      value: totalIncVat,
      isValid: totalIncVat.isNotEmpty,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: LabelTextField(text: context.tr.supplier)),
            widget.strategy.buildReusePastRequest(
              context,
              () => _openReusePastRequestBottomSheet(context),
            ),
          ],
        ),
        8.verticalSpace,
        AppGestureDetectorButton(
          onTap: () => _openSupplierListBottomSheet(context),
          child: ContainerCustomTextField(
            child: Row(
              children: [
                Expanded(
                  child:
                      BlocSelector<ValidationCubit, ValidationState, String?>(
                        selector: (state) => state.fieldsValue['supplierName'],
                        builder: (context, value) {
                          return Text(
                            value ?? context.tr.choose,
                            style: AppStyles.s13W400.copyWith(
                              color: context.customColor.text3,
                            ),
                          );
                        },
                      ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: context.customColor.text1,
                ),
              ],
            ),
          ),
        ),
        14.verticalSpace,
        ContainerCustomTextField(
          label: context.tr.invoiceNumber,
          child: Row(
            children: [
              Expanded(
                child: CustomTextField(
                  hintText: context.tr.invoiceNumberHint,
                  controller: _invoiceNumberController,
                  onChanged: (value) {
                    _validate(
                      context: context,
                      fieldName: 'invoiceNum',
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
        AppGestureDetectorButton(
          onTap: () => _openCalendar(context),
          child: ContainerCustomTextField(
            label: context.tr.issueDate,
            child: Row(
              children: [
                const AppSvg(assetName: AppAssets.calendar),
                10.horizontalSpace,
                Expanded(
                  child:
                      BlocSelector<ValidationCubit, ValidationState, String?>(
                        selector: (state) => state.fieldsValue['issueDate'],
                        builder: (context, selectedDate) {
                          return Text(
                            DateFormatter.formatDateMDY(
                                  DateTime.tryParse(selectedDate ?? ''),
                                ) ??
                                context.tr.whenWasThisInvoiceIssued,
                            style: AppStyles.s14W400.copyWith(
                              color: context.customColor.text3,
                            ),
                          );
                        },
                      ),
                ),
                12.horizontalSpace,
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: context.customColor.text1,
                ),
              ],
            ),
          ),
        ),
        14.verticalSpace,
        SingleExpenseTaxInvoice(
          onDataChange:
              (netAmount, supplierName, taxId, totalIncVat, vatAmount) {
                _validateTaxFields(
                  context: context,
                  taxId: taxId,
                  supplierName: supplierName,
                  netAmount: netAmount,
                  vatAmount: vatAmount,
                  totalIncVat: totalIncVat,
                );
              },
        ),
      ],
    );
  }
}
