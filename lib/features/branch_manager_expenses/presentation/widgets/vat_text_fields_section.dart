import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/features/branch_manager_expenses/presentation/widgets/vat_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VatTextFieldsSection extends StatelessWidget {
  final bool value;
  final TextEditingController invNumController;
  final TextEditingController netAmountController;
  final TextEditingController vatAmountController;
  final TextEditingController totalIncVatController;

  const VatTextFieldsSection({
    super.key,
    required this.value,
    required this.invNumController,
    required this.netAmountController,
    required this.vatAmountController,
    required this.totalIncVatController,
  });

  void _validationField({
    required BuildContext context,
    required String fieldName,
    required bool condition,
  }) {
    context.read<ValidationCubit>().validateField(fieldName, condition);
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
              controller: invNumController,
              hintText: context.tr.invoiceNumberHint,
              labelText: context.tr.invoiceNumber,
              includeSaudiRiyalIcon: false,
              keyboardType: TextInputType.text,
              onChanged: (value) => _validationField(
                context: context,
                fieldName: 'invoiceNum',
                condition: value.isNotEmpty,
              ),
            ),
            10.verticalSpace,
            VatTextField(
              controller: netAmountController,
              hintText: '86.96',
              labelText: context.tr.netAmount,
              onChanged: (value) => _validationField(
                context: context,
                fieldName: 'netAmount',
                condition: value.isNotEmpty,
              ),
            ),
            10.verticalSpace,
            VatTextField(
              controller: vatAmountController,
              hintText: '13.04',
              labelText: context.tr.vatAmount,
              onChanged: (value) => _validationField(
                context: context,
                fieldName: 'vatAmount',
                condition: value.isNotEmpty,
              ),
            ),
            10.verticalSpace,
            VatTextField(
              controller: totalIncVatController,
              hintText: '100',
              labelText: context.tr.totalInclVat,
              onChanged: (value) => _validationField(
                context: context,
                fieldName: 'totalIncVat',
                condition: value.isNotEmpty,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
