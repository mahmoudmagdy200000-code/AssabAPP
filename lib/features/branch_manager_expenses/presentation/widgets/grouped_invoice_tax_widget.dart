import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/cusotm_qr_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/switch_button/switch_button_cubit.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/services/permission_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/button_text_icon.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/custom_switch_button.dart';
import 'expense_tax_invoice_text_fields_section.dart';

class GroupedInvoiceTaxWidget extends StatefulWidget {
  final String invoiceId;
  final void Function(
    String netAmount,
    String supplierName,
    String taxId,
    String totalIncVat,
    String vatAmount,
  )
  onDataChange;

  const GroupedInvoiceTaxWidget({
    super.key,
    required this.invoiceId,
    required this.onDataChange,
  });

  @override
  State<GroupedInvoiceTaxWidget> createState() =>
      _GroupedInvoiceTaxWidgetState();
}

class _GroupedInvoiceTaxWidgetState extends State<GroupedInvoiceTaxWidget> {
  late final TextEditingController _taxIdController;
  late final TextEditingController _supplierNameController;
  late final TextEditingController _netAmountController;
  late final TextEditingController _vatAmountController;
  late final TextEditingController _totalIncVatController;

  @override
  void initState() {
    final validationState = context.read<ValidationCubit>().state;

    _taxIdController = TextEditingController(
      text: validationState.fieldsValue['taxId_${widget.invoiceId}'] ?? '',
    );
    _supplierNameController = TextEditingController(
      text:
          validationState.fieldsValue['taxSupplierName_${widget.invoiceId}'] ??
          '',
    );
    _netAmountController = TextEditingController(
      text: validationState.fieldsValue['netAmount_${widget.invoiceId}'] ?? '',
    );
    _vatAmountController = TextEditingController(
      text: validationState.fieldsValue['vatAmount_${widget.invoiceId}'] ?? '',
    );
    _totalIncVatController = TextEditingController(
      text:
          validationState.fieldsValue['totalIncVat_${widget.invoiceId}'] ?? '',
    );

    if (validationState.fieldsValidity['taxId_${widget.invoiceId}'] == true &&
        validationState.fieldsValidity['taxSupplierName_${widget.invoiceId}'] ==
            true &&
        validationState.fieldsValidity['netAmount_${widget.invoiceId}'] ==
            true &&
        validationState.fieldsValidity['vatAmount_${widget.invoiceId}'] ==
            true) {
      context.read<SwitchButtonCubit>().toggle();
    }

    _taxIdController.addListener(_onDataChange);
    _supplierNameController.addListener(_onDataChange);
    _netAmountController.addListener(_onDataChange);
    _vatAmountController.addListener(_onDataChange);
    _totalIncVatController.addListener(_onDataChange);
    super.initState();
  }

  @override
  void dispose() {
    _taxIdController.dispose();
    _supplierNameController.dispose();
    _netAmountController.dispose();
    _vatAmountController.dispose();
    _totalIncVatController.dispose();
    super.dispose();
  }

  void _onDataChange() {
    widget.onDataChange(
      _netAmountController.text,
      _supplierNameController.text,
      _taxIdController.text,
      _totalIncVatController.text,
      _vatAmountController.text,
    );
  }

  void _whenSwitchChange(BuildContext context, bool newValue) {
    context.read<SwitchButtonCubit>().toggle();
    _makeAllFieldIsRequired(context, newValue);

    if (!newValue) {
      _taxIdController.text = '';
      _supplierNameController.text = '';
      _netAmountController.text = '';
      _vatAmountController.text = '';
      _totalIncVatController.text = '';
      _validateAllFields(context, false);
    }
  }

  void _makeAllFieldIsRequired(BuildContext context, bool newValue) {
    final validationCubit = context.read<ValidationCubit>();

    _handleRequirement(
      context,
      validationCubit,
      fieldName: 'taxId_${widget.invoiceId}',
      controller: _taxIdController,
      isRequired: newValue,
    );

    _handleRequirement(
      context,
      validationCubit,
      fieldName: 'taxSupplierName_${widget.invoiceId}',
      controller: _supplierNameController,
      isRequired: newValue,
    );

    _handleRequirement(
      context,
      validationCubit,
      fieldName: 'netAmount_${widget.invoiceId}',
      controller: _netAmountController,
      isRequired: newValue,
    );

    _handleRequirement(
      context,
      validationCubit,
      fieldName: 'vatAmount_${widget.invoiceId}',
      controller: _vatAmountController,
      isRequired: newValue,
    );

    _handleRequirement(
      context,
      validationCubit,
      fieldName: 'totalIncVat_${widget.invoiceId}',
      controller: _totalIncVatController,
      isRequired: newValue,
    );
  }

  void _handleRequirement(
    BuildContext context,
    ValidationCubit validationCubit, {
    required String fieldName,
    required TextEditingController controller,
    required bool isRequired,
  }) {
    validationCubit.toggleFieldRequirement(fieldName, isRequired: isRequired);

    final currentValue = controller.text.trim();
    final isValid = currentValue.isNotEmpty;

    validationCubit.validateField(fieldName, isRequired ? isValid : true);
  }

  void _validationField({
    required BuildContext context,
    required String fieldName,
    required bool condition,
  }) {
    context.read<ValidationCubit>().validateField(fieldName, condition);
  }

  void _validateAllFields(BuildContext context, bool value) {
    _validationField(
      context: context,
      fieldName: 'taxId_${widget.invoiceId}',
      condition: value,
    );
    _validationField(
      context: context,
      fieldName: 'taxSupplierName_${widget.invoiceId}',
      condition: value,
    );
    _validationField(
      context: context,
      fieldName: 'netAmount_${widget.invoiceId}',
      condition: value,
    );
    _validationField(
      context: context,
      fieldName: 'vatAmount_${widget.invoiceId}',
      condition: value,
    );
    _validationField(
      context: context,
      fieldName: 'totalIncVat_${widget.invoiceId}',
      condition: value,
    );
  }

  void _handleFillFieldsWhenQrGetDataSuccess(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    final invNum = data['invoice_number'].toString();
    final supplierName = data['seller_name'].toString();
    final totalIncVat = double.tryParse(data['total_with_vat']) ?? 0;
    final vatAmount = double.tryParse(data['vat_amount']) ?? 0;
    final netAmount = totalIncVat - vatAmount;

    _taxIdController.text = invNum;
    _supplierNameController.text = supplierName;
    _netAmountController.text = netAmount.toString();
    _vatAmountController.text = vatAmount.toString();
    _totalIncVatController.text = totalIncVat.toString();
    _validateAllFields(context, true);
  }

  void _openQrScanner(BuildContext parentContext) async {
    await PermissionService.requestPermission(permission: Permission.camera);

    if (!await PermissionService.isPermissionGranted(
      permission: Permission.camera,
    )) {
      return;
    }

    final validationCubit = parentContext.read<ValidationCubit>();

    AppBottomSheet.customPageRoute(parentContext, (sheetContext) {
      return BlocProvider.value(
        value: validationCubit,
        child: CustomQrScanner(
          onDetect: (data) {
            if (data != null) {
              _handleFillFieldsWhenQrGetDataSuccess(parentContext, data);
            }
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: context.customColor.border),
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 5.r),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.tr.taxInvoice,
                  style: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ),
              5.horizontalSpace,
              BlocBuilder<SwitchButtonCubit, bool>(
                builder: (context, state) {
                  return CustomSwitchButton(
                    value: state,
                    onChanged: (newValue) =>
                        _whenSwitchChange(context, newValue),
                  );
                },
              ),
            ],
          ),
          BlocBuilder<SwitchButtonCubit, bool>(
            builder: (context, state) {
              return AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: state
                    ? Column(
                        children: [
                          BlocSelector<SwitchButtonCubit, bool, bool>(
                            selector: (state) => state,
                            builder: (context, state) {
                              return ExpenseTaxInvoiceTextFieldsSection(
                                value: state,
                                taxIdController: _taxIdController,
                                supplierNameController: _supplierNameController,
                                netAmountController: _netAmountController,
                                vatAmountController: _vatAmountController,
                                totalIncVatController: _totalIncVatController,
                                taxIdFieldName: 'taxId_${widget.invoiceId}',
                                supplierNameFieldName:
                                    'taxSupplierName_${widget.invoiceId}',
                                netAmountFieldName:
                                    'netAmount_${widget.invoiceId}',
                                vatAmountFieldName:
                                    'vatAmount_${widget.invoiceId}',
                                totalIncVatFieldName:
                                    'totalIncVat_${widget.invoiceId}',
                              );
                            },
                          ),
                          10.verticalSpace,
                          const CustomDivider(),
                          10.verticalSpace,
                          ButtonTextIcon(
                            onTap: () => _openQrScanner(context),
                            label: context.tr.scanCode,
                            icon: AppSvg(
                              assetName: AppAssets.scan,
                              width: 13.w,
                              colorFilter: ColorFilter.mode(
                                context.customColor.text1,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          6.verticalSpace,
                        ],
                      )
                    : const SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
    );
  }
}
