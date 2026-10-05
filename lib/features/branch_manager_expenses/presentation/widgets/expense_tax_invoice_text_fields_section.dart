import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/features/branch_manager_expenses/presentation/widgets/vat_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseTaxInvoiceTextFieldsSection extends StatelessWidget {
  final bool value;
  final TextEditingController taxIdController;
  final TextEditingController supplierNameController;
  final TextEditingController netAmountController;
  final TextEditingController vatAmountController;
  final TextEditingController totalIncVatController;
  final String taxIdFieldName;
  final String supplierNameFieldName;
  final String netAmountFieldName;
  final String vatAmountFieldName;
  final String totalIncVatFieldName;

  const ExpenseTaxInvoiceTextFieldsSection({
    super.key,
    required this.value,
    required this.taxIdController,
    required this.supplierNameController,
    required this.netAmountController,
    required this.vatAmountController,
    required this.totalIncVatController,
    required this.taxIdFieldName,
    required this.supplierNameFieldName,
    required this.netAmountFieldName,
    required this.vatAmountFieldName,
    required this.totalIncVatFieldName,
  });

  void _validationField({
    required BuildContext context,
    required String fieldName,
    required bool condition,
    required String value,
  }) {
    context.read<ValidationCubit>().validateFieldAndStoreValue(
      fieldName: fieldName,
      value: value,
      isValid: condition,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 300),
      crossFadeState: value
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      firstChild: const SizedBox.shrink(),
      secondChild: Padding(
        padding: EdgeInsets.only(top: 12.h),
        child: Column(
          children: [
            Divider(color: context.customColor.border, height: 1.r),
            12.verticalSpace,
            VatTextField(
              controller: taxIdController,
              hintText: context.tr.taxIdHint,
              labelText: context.tr.taxId,
              includeSaudiRiyalIcon: false,
              keyboardType: TextInputType.text,
              onChanged: (value) => _validationField(
                context: context,
                fieldName: taxIdFieldName,
                value: value,
                condition: value.isNotEmpty,
              ),
            ),
            10.verticalSpace,
            VatTextField(
              controller: supplierNameController,
              hintText: context.tr.supplierName,
              labelText: context.tr.supplierName,
              includeSaudiRiyalIcon: false,
              keyboardType: TextInputType.text,
              onChanged: (value) => _validationField(
                context: context,
                fieldName: supplierNameFieldName,
                value: value,
                condition: value.isNotEmpty,
              ),
            ),
            10.verticalSpace,
            VatTextField(
              controller: netAmountController,
              hintText: context.tr.netAmount,
              labelText: context.tr.netAmount,
              onChanged: (value) => _validationField(
                context: context,
                fieldName: netAmountFieldName,
                value: value,
                condition: value.isNotEmpty,
              ),
            ),
            10.verticalSpace,
            VatTextField(
              controller: vatAmountController,
              hintText: context.tr.vatAmount,
              labelText: context.tr.vatAmount,
              onChanged: (value) => _validationField(
                context: context,
                fieldName: vatAmountFieldName,
                value: value,
                condition: value.isNotEmpty,
              ),
            ),
            10.verticalSpace,
            VatTextField(
              controller: totalIncVatController,
              hintText: context.tr.totalInclVat,
              labelText: context.tr.totalInclVat,
              onChanged: (value) => _validationField(
                context: context,
                fieldName: totalIncVatFieldName,
                value: value,
                condition: value.isNotEmpty,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
