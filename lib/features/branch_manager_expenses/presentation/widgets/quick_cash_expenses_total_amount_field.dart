import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';

class QuickCashExpensesTotalAmountField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Color? borderColor;

  const QuickCashExpensesTotalAmountField({
    super.key,
    required this.controller,
    required this.label,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return ContainerCustomTextField(
      label: label,
      borderColor: borderColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: CustomTextField(
              controller: controller,
              hintText: context.tr.expenseTitleHint,
              maxLength: 30,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                context.read<ValidationCubit>().validateField(
                  'amount',
                  value.isNotEmpty,
                );
              },
            ),
          ),
          const SaudiRiyalSvgWidget(),
        ],
      ),
    );
  }
}
